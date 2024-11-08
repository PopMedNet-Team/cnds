﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Lpp.Dns.Data;
using Lpp.Dns.DTO;
using Lpp.Utilities.WebSites.Controllers;
using Lpp.Dns.DTO.Security;
using System.Data.Entity;
using Lpp.Utilities;
using System.Threading.Tasks;
using Lpp.Dns.DTO.QueryComposer;
using Lpp.Workflow.Engine;
using LinqKit;
using Lpp.Dns.DTO.Enums;

namespace Lpp.Dns.Api.Requests
{
    /// <summary>
    /// Controller that services Request related actions.
    /// </summary>
    public class RequestsController : LppApiWorkflowController<Request, RequestDTO, DataContext, PermissionDefinition, WorkflowActivity, RequestCompletionRequestDTO, RequestCompletionResponseDTO>
    {
        /// <summary>
        /// The DataMartTypeID representing an imported CNDS DataSource.
        /// </summary>
        public static readonly Guid CNDSDataMartTypeID = new Guid("5B060001-2A5F-4243-980F-A70E011E7D5F");
        /// <summary>
        /// The ID of the organization that all the CNDS DataMart proxies belong to.
        /// </summary>
        public static readonly Guid CNDSOrganizationRouteProxyID = new Guid("39040001-38AC-49E9-8FAC-A7120111F82E");

        /// <summary>
        /// The routing statuses that are valid for a completed routing.
        /// </summary>
        private readonly static IEnumerable<Dns.DTO.Enums.RoutingStatus> CompletedRoutingStatuses = new[]{
                Dns.DTO.Enums.RoutingStatus.Completed,
                Dns.DTO.Enums.RoutingStatus.ResultsModified,
                Dns.DTO.Enums.RoutingStatus.RequestRejected,
                Dns.DTO.Enums.RoutingStatus.AwaitingResponseApproval,
                Dns.DTO.Enums.RoutingStatus.ResponseRejectedAfterUpload,
                Dns.DTO.Enums.RoutingStatus.ResponseRejectedBeforeUpload
            };

        Lpp.CNDS.ApiClient.CNDSClient _cndsClient = null;
        Lpp.CNDS.ApiClient.CNDSClient CNDSApi {
            get
            {
                if(_cndsClient == null)
                {
                    _cndsClient = new Lpp.CNDS.ApiClient.CNDSClient(System.Configuration.ConfigurationManager.AppSettings["CNDS.URL"]);
                }

                return _cndsClient;
            }
        }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if(_cndsClient != null)
                {
                    _cndsClient.Dispose();
                }
            }

            base.Dispose(disposing);
        }


        /// <summary>
        /// Creates a new request, supports having external routes.
        /// </summary>
        /// <param name="details"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<RequestCompletionResponseDTO> CreateRequest(CreateCNDSRequestDetailsDTO details)
        {
            if (details.Dto.ID.HasValue)
            {
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Only new request are suppported by this action."));
            }

            //TODO: register any external datamarts, map to requestdatamart dtos.
            DateTime? requestDueDate = null;
            if (details.Dto.DueDate.HasValue)
            {
                requestDueDate = details.Dto.DueDate.Value.DateTime;
            }

            //TODO: make sure that no routes point to the same local project but different requesttype - NOT ALLOWED and should throw exception
            List<RequestDataMartDTO> requestDataMarts = new List<RequestDataMartDTO>();

            var localRoutes = details.Routes.Where(rt => WebApiApplication.NetworkID == rt.NetworkID && rt.ProjectID == details.Dto.ProjectID && rt.RequestTypeID == details.Dto.RequestTypeID).ToArray();
            if (localRoutes.Any())
            {
                foreach(var rt in localRoutes)
                {
                    requestDataMarts.Add(new RequestDataMartDTO {
                        DataMartID = rt.DataMartID,
                        //leaving the routing type null because it is a normal local datamart
                        RoutingType = null,
                        DueDate = requestDueDate,
                        Priority = details.Dto.Priority
                    });
                }
            }

            var externalRoutes = details.Routes.Where(rt => (rt.NetworkID != WebApiApplication.NetworkID || (rt.NetworkID == WebApiApplication.NetworkID && rt.ProjectID != details.Dto.RequestTypeID)) && rt.DefinitionID.HasValue).ToArray();
            if (externalRoutes.Any())
            {
                //import the route as a DataMart if not already registered
                var routeIDs = externalRoutes.Select(rt => rt.DefinitionID).Distinct().ToArray();
                var existingDataMarts = await DataContext.DataMarts.Where(dm => routeIDs.Contains(dm.ID) && dm.DataMartTypeID == CNDSDataMartTypeID).Select(dm => dm.ID).ToArrayAsync();

                var routesToRegister = externalRoutes.Where(rt => !existingDataMarts.Contains(rt.DefinitionID.Value)).ToArray();
                if (routesToRegister.Any())
                {
                    //the route definition ID is going to be the ID of the local datamart object.
                    foreach(var route in routesToRegister)
                    {
                        DataContext.DataMarts.Add(new DataMart {
                            ID = route.DefinitionID.Value,
                            Name = route.DefinitionID.Value.ToString("D"),
                            Acronym = route.DefinitionID.Value.ToString("D"),
                            OrganizationID = CNDSOrganizationRouteProxyID,
                            DataMartTypeID = CNDSDataMartTypeID
                        });
                    }
                }


                foreach(var route in externalRoutes)
                {
                    requestDataMarts.Add(new RequestDataMartDTO {
                        DataMartID = route.DefinitionID.Value,
                        RoutingType = RoutingType.SourceCNDS,
                        DueDate = requestDueDate,
                        Priority = details.Dto.Priority
                    });
                }

            }


            var request = new RequestCompletionRequestDTO {
                Dto = details.Dto,
                DataMarts = requestDataMarts
            };

            var DataMartMap = new Dictionary<RequestDataMart, RequestDataMartDTO>();

            Func<Data.Request, WorkflowActivityContext> getWorkflowActivity = (entity) => {
                if (entity.WorkFlowActivityID == null)
                {
                    return (from cm in DataContext.WorkflowActivityCompletionMaps
                            join rt in DataContext.RequestTypes on cm.WorkflowID equals rt.WorkflowID
                            from wa in DataContext.WorkflowActivities
                            where rt.ID == entity.RequestTypeID && (cm.SourceWorkflowActivityID == wa.ID || cm.DestinationWorkflowActivityID == wa.ID) && wa.Start
                            select new WorkflowActivityContext
                            {
                                Activity = wa,
                                WorkflowID = cm.WorkflowID
                            }).First();

                }
                else
                {
                    return DataContext.WorkflowActivities.Where(a => a.ID == entity.WorkFlowActivityID.Value).Select(wa => new WorkflowActivityContext
                    {
                        WorkflowID = entity.WorkflowID.Value,
                        Activity = wa
                    }).First();
                }
            };

            Func<Data.Request, Task> entityPreSave = (entity) => {
                return Task.Run(() => {

                    entity.UpdatedByID = Identity.ID;
                    entity.UpdatedOn = DateTime.UtcNow;
                    entity.OrganizationID = Identity.EmployerID.Value;
                    entity.CreatedOn = DateTime.UtcNow;
                    entity.CreatedByID = Identity.ID;

                    //Save the data marts
                    var inserts = request.DataMarts.Where(rdm => rdm.ID == null);
                    foreach (var insert in inserts)
                    {
                        var obj = DataContext.RequestDataMarts.Add(RequestDataMart.Create(entity.ID, insert.DataMartID, Identity.ID));
                        insert.ID = obj.ID;
                        insert.RequestID = entity.ID;
                        insert.Apply(DataContext.Entry(obj));
                        obj.Status = DTO.Enums.RoutingStatus.Draft;
                        insert.Status = DTO.Enums.RoutingStatus.Draft;
                        obj.Priority = insert.Priority;
                        obj.DueDate = insert.DueDate;
                        obj.RoutingType = insert.RoutingType;

                        DataMartMap.Add(obj, insert);
                    }

                });
            };

            Func<Data.Request, Task> entityPostSave = (entity) => {
                return Task.Run(async () =>
                {

                    await DataContext.Entry(entity).ReloadAsync();

                    if (string.IsNullOrEmpty(entity.MSRequestID))
                    {
                        entity.MSRequestID = string.Format("Request {0}", entity.Identifier.ToString());
                    }

                    var currentTask = await PmnTask.GetActiveTaskForRequestActivityAsync(entity.ID, entity.WorkFlowActivityID.Value, DataContext);
                    if (currentTask != null)
                    {
                        await DataContext.Entry(currentTask).Collection(t => t.Users).LoadAsync();

                        //confirm that the creator has been set to as the requestor assignee on the request.
                        await DataContext.Entry(entity).Collection(r => r.Users).LoadAsync();
                        if (!entity.Users.Any(u => u.UserID == entity.CreatedByID))
                        {
                            Guid? requestCreatorRoleID = await DataContext.WorkflowRoles.Where(w => w.WorkflowID == entity.WorkflowID && w.IsRequestCreator).Select(w => (Guid?)w.ID).FirstOrDefaultAsync();
                            if (requestCreatorRoleID.HasValue)
                            {
                                entity.Users.Add(new RequestUser { UserID = entity.CreatedByID, WorkflowRoleID = requestCreatorRoleID.Value, RequestID = entity.ID });

                                //make sure the user is on the task - it should have been created when the activity was started
                                if (!await DataContext.ActionUsers.AnyAsync(tu => tu.UserID == entity.CreatedByID && tu.Task.WorkflowActivityID == entity.WorkFlowActivityID && tu.Task.References.Any(tr => tr.ItemID == entity.ID && tr.Type == DTO.Enums.TaskItemTypes.Request)))
                                {
                                    currentTask.Users.Add(
                                        new PmnTaskUser
                                        {
                                            Role = DTO.Enums.TaskRoles.Worker,
                                            UserID = entity.CreatedByID,
                                            TaskID = currentTask.ID
                                        }
                                    );
                                }

                                await DataContext.SaveChangesAsync();
                            }
                        }

                        //confirm that all the request users that have view task permission have been added to the task
                        await PmnTask.ConfirmUsersToTaskForWorkflowRequest(currentTask, entity, DataContext);

                        //Update the datamartdto timestamps
                        foreach (var dm in DataMartMap)
                        {
                            await DataContext.Entry(dm.Key).ReloadAsync();
                            dm.Value.ID = dm.Key.ID;
                            dm.Value.Timestamp = dm.Key.Timestamp;
                        }
                    }
                });
            };

            var result = await base.CompleteWorkflowActivity(request, getWorkflowActivity, entityPreSave, entityPostSave);

            return result; 
        }

        /// <summary>
        /// Completes a workflow activity based on the information provided.
        /// </summary>
        /// <param name="request"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<RequestCompletionResponseDTO> CompleteActivity(RequestCompletionRequestDTO request)
        {
            var DataMartMap = new Dictionary<RequestDataMart, RequestDataMartDTO>();
            bool isNew = request.Dto.ID == null;

            var result = await base.CompleteWorkflowActivity(request, 
                (entity) =>
                {
                   

                    if (entity.WorkFlowActivityID == null)
                    {
                        return (from cm in DataContext.WorkflowActivityCompletionMaps
                                join rt in DataContext.RequestTypes on cm.WorkflowID equals rt.WorkflowID
                                from wa in DataContext.WorkflowActivities
                                where rt.ID == entity.RequestTypeID && (cm.SourceWorkflowActivityID == wa.ID || cm.DestinationWorkflowActivityID == wa.ID) && wa.Start
                                select new WorkflowActivityContext
                                {
                                    Activity = wa,
                                    WorkflowID = cm.WorkflowID
                                }).First();

                    }
                    else
                    {
                        return DataContext.WorkflowActivities.Where(a => a.ID == entity.WorkFlowActivityID.Value).Select(wa => new WorkflowActivityContext {
                            WorkflowID = entity.WorkflowID.Value,
                            Activity = wa
                        }).First();
                    }
                }, 
                async (entity) =>
                {
                    /** Pre-Save **/

                    //Update basic settings on the request that cannot be trusted to the client

                    await Task.Run(() => {

                        entity.UpdatedByID = Identity.ID;
                        entity.UpdatedOn = DateTime.UtcNow;
                        if (isNew)
                        {
                            entity.OrganizationID = Identity.EmployerID.Value;
                            entity.CreatedOn = DateTime.UtcNow;
                            entity.CreatedByID = Identity.ID;
                        }

                        //Save the data marts
                        var inserts = request.DataMarts.Where(dm => dm.ID == null);                    
                        foreach (var insert in inserts)
                        {
                            var obj = DataContext.RequestDataMarts.Add(RequestDataMart.Create(entity.ID, insert.DataMartID, Identity.ID));
                            insert.ID = obj.ID;
                            insert.RequestID = entity.ID;
                            insert.Apply(DataContext.Entry(obj));
                            obj.Status = DTO.Enums.RoutingStatus.Draft;
                            insert.Status = DTO.Enums.RoutingStatus.Draft;
                            obj.Priority = insert.Priority;
                            obj.DueDate = insert.DueDate;
                            obj.RoutingType = insert.RoutingType;
                            DataMartMap.Add(obj, insert);                      
                        }

                    });

                    //Check for MSRequestID field
                    var securityGroups = DataContext.SecurityGroupUsers.Where(u => u.UserID == Identity.ID).Select(u => u.SecurityGroupID).ToArray();
                    var projectFieldOptions = DataContext.ProjectFieldOptionAcls.Where(fo => fo.FieldIdentifier == "Request-RequestID" && fo.ProjectID == entity.ProjectID && securityGroups.Contains(fo.SecurityGroupID)).ToArray();
                    var globalFieldOption = DataContext.GlobalFieldOptionAcls.Where(g => g.FieldIdentifier == "Request-RequestID").First();

                    //If MSRequestID is empty and required, throw an error
                    if ((entity.MSRequestID == null || entity.MSRequestID == "") && 
                          ( 
                            projectFieldOptions.Any(o => o.Permission == FieldOptionPermissions.Required)
                            || 
                            (globalFieldOption.Permission == FieldOptionPermissions.Required && projectFieldOptions.All(o => o.Permission != FieldOptionPermissions.Hidden)) 
                          ) 
                       )
                    {
                        throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "Request ID field cannot be empty."));
                    }
                    //If MS RequestID is not empty and is not hidden, check for duplicates
                    if ((entity.MSRequestID != null && entity.MSRequestID != "") &&
                            (
                            projectFieldOptions.All(o => o.Permission != FieldOptionPermissions.Hidden)
                            ||
                            (globalFieldOption.Permission != FieldOptionPermissions.Hidden && projectFieldOptions.All(o => o.Permission != FieldOptionPermissions.Hidden))
                            )
                        )
                    {
                        if (DataContext.Requests.Any(r => (r.MSRequestID == entity.MSRequestID) && (r.ID != entity.ID)))
                        {
                            throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "The Request ID entered is not unique. Please enter in a different Request ID."));
                        }
                    }


                    if (!isNew)
                    {
                        if (!DataContext.Entry(entity).Collection((e) => e.DataMarts).IsLoaded)
                            await DataContext.Entry(entity).Collection((e) => e.DataMarts).LoadAsync();

                        var deletes = entity.DataMarts.Where(dm => !request.DataMarts.Any(adm => adm.ID.HasValue && adm.ID.Value == dm.ID));
                        //cleanup logs
                        var requestDataMartDeleteID = deletes.Select(rdm => rdm.ID).ToArray();
                        DataContext.LogsRequestDataMartMetadataChange.RemoveRange(DataContext.LogsRequestDataMartMetadataChange.Where(l => requestDataMartDeleteID.Contains(l.RequestDataMartID)));
                        //remove the routes
                        DataContext.RequestDataMarts.RemoveRange(deletes);

                        var updates = request.DataMarts.Where(dm => dm.ID.HasValue && (!entity.DataMarts.Any(ad => (ad.ID == dm.ID.Value)) || entity.DataMarts.Any(adm => (adm.ID == dm.ID.Value) && ((adm.Priority != dm.Priority) || (adm.DueDate != dm.DueDate) || (adm.RoutingType != dm.RoutingType)))));

                        var sourceCNDS = new List<Lpp.CNDS.DTO.Requests.UpdateDataMartPriorityAndDueDateDTO>();
                        var participantCNDS = new List<Lpp.CNDS.DTO.Requests.UpdateDataMartPriorityAndDueDateDTO>();
                        foreach (var update in updates)
                        {
                            var dm = entity.DataMarts.First(adm => adm.ID == update.ID.Value);
                            if (dm.RoutingType == RoutingType.SourceCNDS && (dm.Priority != update.Priority || dm.DueDate != update.DueDate) && (dm.Status != RoutingStatus.Draft))
                                participantCNDS.Add(new Lpp.CNDS.DTO.Requests.UpdateDataMartPriorityAndDueDateDTO { RequestDataMartID = dm.ID, DueDate = update.DueDate, Priority = (int)update.Priority });

                            if (dm.RoutingType == RoutingType.ExternalCNDS && (dm.Priority != update.Priority || dm.DueDate != update.DueDate) && (dm.Status != RoutingStatus.Draft))
                                sourceCNDS.Add(new Lpp.CNDS.DTO.Requests.UpdateDataMartPriorityAndDueDateDTO { RequestDataMartID = dm.ID, DueDate = update.DueDate, Priority = (int)update.Priority });

                            dm.DueDate = update.DueDate;
                            dm.Priority = update.Priority;
                            dm.RoutingType = update.RoutingType;
                            update.Apply(DataContext.Entry(dm));

                            if ((await DataContext.Responses.Where(rsp => rsp.RequestDataMartID == dm.ID).AnyAsync()) == false)
                            {
                                DataContext.Responses.Add(new Response
                                {
                                    RequestDataMartID = update.ID.Value,
                                    SubmittedByID = Identity.ID
                                });
                            }
                            

                            DataMartMap.Add(dm, update);
                        }
                        if(sourceCNDS.Count() > 0 && request.DemandActivityResultID != new Guid("DFF3000B-B076-4D07-8D83-05EDE3636F4D"))
                        {
                            using (var helper = new Lpp.CNDS.ApiClient.NetworkRequestDispatcher())
                            {
                                var resp = await helper.UpdateSourceDataMartsPriorityAndDueDate(sourceCNDS);
                                if (!resp.IsSuccessStatusCode)
                                {
                                    throw new HttpResponseException(Request.CreateErrorResponse(resp.StatusCode, await resp.GetMessage()));
                                }
                            }
                        }

                        if(participantCNDS.Count() > 0 && request.DemandActivityResultID != new Guid("DFF3000B-B076-4D07-8D83-05EDE3636F4D"))
                        {
                            using (var helper = new Lpp.CNDS.ApiClient.NetworkRequestDispatcher())
                            {
                                var resp = await helper.UpdateParticipateDataMartsPriorityAndDueDate(participantCNDS);
                                if (!resp.IsSuccessStatusCode)
                                {
                                    throw new HttpResponseException(Request.CreateErrorResponse(resp.StatusCode, await resp.GetMessage()));
                                }
                            }
                        }
                    }
                },
                async (entity) =>
                {
                    /** Post Save **/

                    //IF MSRequestID is blank, populate it with a default value "Request [System Number]". Need to do it post save so that entity.Identifier is populated with the correct System Number
                    if (entity.MSRequestID == null || entity.MSRequestID == "")
                    {
                        entity.MSRequestID = "Request " + entity.Identifier.ToString();
                    }


                    var currentTask = await PmnTask.GetActiveTaskForRequestActivityAsync(entity.ID, entity.WorkFlowActivityID.Value, DataContext);
                    if (currentTask != null)
                    {
                        await DataContext.Entry(currentTask).Collection(t => t.Users).LoadAsync();

                        //confirm that the creator has been set to as the requestor assignee on the request.
                        await DataContext.Entry(entity).Collection(r => r.Users).LoadAsync();
                        if (!entity.Users.Any(u => u.UserID == entity.CreatedByID))
                        {
                            Guid? requestCreatorRoleID = await DataContext.WorkflowRoles.Where(w => w.WorkflowID == entity.WorkflowID && w.IsRequestCreator).Select(w => (Guid?)w.ID).FirstOrDefaultAsync();
                            if (requestCreatorRoleID.HasValue)
                            {
                                entity.Users.Add(new RequestUser { UserID = entity.CreatedByID, WorkflowRoleID = requestCreatorRoleID.Value, RequestID = entity.ID });

                                //make sure the user is on the task - it should have been created when the activity was started
                                if (!await DataContext.ActionUsers.AnyAsync(tu => tu.UserID == entity.CreatedByID && tu.Task.WorkflowActivityID == entity.WorkFlowActivityID && tu.Task.References.Any(tr => tr.ItemID == entity.ID && tr.Type == DTO.Enums.TaskItemTypes.Request)))
                                {
                                    currentTask.Users.Add(
                                        new PmnTaskUser
                                        {
                                            Role = DTO.Enums.TaskRoles.Worker,
                                            UserID = entity.CreatedByID,
                                            TaskID = currentTask.ID
                                        }
                                    );
                                }

                                await DataContext.SaveChangesAsync();
                            }
                        }

                        //confirm that all the request users that have view task permission have been added to the task
                        await PmnTask.ConfirmUsersToTaskForWorkflowRequest(currentTask, entity, DataContext);

                        //Update the datamartdto timestamps
                        foreach (var dm in DataMartMap)
                        {
                            await DataContext.Entry(dm.Key).ReloadAsync();
                            dm.Value.ID = dm.Key.ID;
                            dm.Value.Timestamp = dm.Key.Timestamp;
                        }
                    }
                }
            );

            return result;
        }

        /// <summary>
        /// Terminates the request
        /// </summary>
        /// <param name="requestID"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> TerminateRequest([FromBody]Guid requestID)
        {
            var request = await DataContext.Requests.FindAsync(requestID);

            var permissions = await DataContext.GetGrantedPermissionsForWorkflowActivityAsync(Identity, request.ProjectID, request.WorkFlowActivityID.Value, request.RequestTypeID, PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.TerminateWorkflow.ID);
            if (!permissions.Any())
            {
                return Request.CreateErrorResponse(HttpStatusCode.Forbidden, CommonMessages.RequirePermissionToTerminateWorkflow);
            }

            request.CancelledByID = Identity.ID;
            request.CancelledOn = DateTime.UtcNow;
            
            var newStatus = (int)request.Status < 400 ? RequestStatuses.TerminatedPriorToDistribution : DTO.Enums.RequestStatuses.Cancelled;


            var completedRoutingStatuses = new[] { RoutingStatus.RequestRejected, RoutingStatus.Canceled, RoutingStatus.ResponseRejectedAfterUpload, RoutingStatus.ResponseRejectedBeforeUpload, RoutingStatus.Failed, RoutingStatus.Completed };
            var rdms = DataContext.RequestDataMarts.Where(s => s.RequestID == requestID);
            var participantIDs = new List<Guid>();
            var sourceIDs = new List<Guid>();
            foreach (var rdm in rdms)
            {
                if (completedRoutingStatuses.Contains(rdm.Status) == false)
                    rdm.Status = DTO.Enums.RoutingStatus.Canceled;
                if (rdm.RoutingType == RoutingType.SourceCNDS)
                    participantIDs.Add(rdm.ID);
                if (rdm.RoutingType == RoutingType.ExternalCNDS)
                    sourceIDs.Add(rdm.ID);
            }

            if(participantIDs.Count() > 0)
            {
                using (var helper = new Lpp.CNDS.ApiClient.NetworkRequestDispatcher())
                {
                    var resp = await helper.TerminateParticipantRoutes(participantIDs);
                    if (!resp.IsSuccessStatusCode)
                    {
                        throw new HttpResponseException(Request.CreateErrorResponse(resp.StatusCode, await resp.GetMessage()));
                    }
                }
            }

            if (sourceIDs.Count() > 0)
            {
                using (var helper = new Lpp.CNDS.ApiClient.NetworkRequestDispatcher())
                {
                    var resp = await helper.TerminateSourceRoutes(sourceIDs);
                    if (!resp.IsSuccessStatusCode)
                    {
                        throw new HttpResponseException(Request.CreateErrorResponse(resp.StatusCode, await resp.GetMessage()));
                    }
                }
            }


            await DataContext.SaveChangesAsync();

            await DataContext.Entry(request).ReloadAsync();

            request.Status = newStatus;
            await DataContext.SaveChangesAsync();

            //have to explicitly change the request status since the property is marked as computed for EF.
            await DataContext.Database.ExecuteSqlCommandAsync("UPDATE Requests SET Status = @status WHERE ID = @ID", new System.Data.SqlClient.SqlParameter("@status", (int)newStatus), new System.Data.SqlClient.SqlParameter("@ID", request.ID));

            //cancel any outstanding tasks associated with the request.
            var incompleteTaskStatuses = new[] { TaskStatuses.Complete, TaskStatuses.Cancelled };
            IEnumerable<PmnTask> incompleteTasks = await DataContext.Actions.Where(t => t.References.Any(r => r.ItemID == requestID) && t.Status != TaskStatuses.Complete && t.Status != TaskStatuses.Cancelled).ToArrayAsync();
            foreach(var incompleteTask in incompleteTasks)
            {
                incompleteTask.Status = DTO.Enums.TaskStatuses.Cancelled;
                incompleteTask.EndOn = DateTime.UtcNow;
                incompleteTask.PercentComplete = 100d;
            }
            await DataContext.SaveChangesAsync();

            await DataContext.Entry(request).ReloadAsync();
            //This has to be down here or the task can't be found to update.
            request.WorkFlowActivityID = Guid.Parse("CC2E0001-9B99-4C67-8DED-A3B600E1C696");

            var ta = new PmnTask
            {
                CreatedOn = DateTime.UtcNow,
                PercentComplete = 100,
                Priority = DTO.Enums.Priorities.High,
                StartOn = DateTime.UtcNow,
                EndOn = DateTime.UtcNow,
                Status = DTO.Enums.TaskStatuses.Complete,
                Subject = "Request Terminated",
                Type = DTO.Enums.TaskTypes.Task,
                WorkflowActivityID = request.WorkFlowActivityID
            };

            DataContext.Actions.Add(ta);

            var reference = new TaskReference
            {
                ItemID = request.ID,
                TaskID = ta.ID,
                Type = DTO.Enums.TaskItemTypes.Request
            };

            DataContext.ActionReferences.Add(reference);

            await DataContext.SaveChangesAsync();

            //TODO: going to have to send the request status notification to indicate change to terminated/canceled

            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Returns a List of Requests filtered using OData.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public override IQueryable<RequestDTO> List()
        {
            var result = base.List().Where(l => !l.Deleted);
            return result;
        }

        /// <summary>
        /// Returns a list of Requests using HomepageRequestDetailDTO.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<HomepageRequestDetailDTO> ListForHomepage()
        {
            var globalAcls = DataContext.GlobalAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit);
            var projectAcls = DataContext.ProjectAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit, PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata);
            var projectOrganizationAcls = DataContext.ProjectOrganizationAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit);

            var result = from r in DataContext.Secure<Request>(Identity).AsNoTracking()
                         let gAcl = globalAcls
                         let pAcl = projectAcls.Where(a => a.ProjectID == r.ProjectID)
                         let poAcl = projectOrganizationAcls.Where(a => a.ProjectID == r.ProjectID && a.OrganizationID == r.OrganizationID)
                         select new HomepageRequestDetailDTO
                        {
                            ID = r.ID,
                            Timestamp = r.Timestamp,
                            Identifier = r.Identifier,
                            MSRequestID = r.MSRequestID,
                            Name = r.Name,
                            DueDate = r.DueDate,
                            Priority = r.Priority,
                            Project = r.Project.Name,
                            RequestType = r.RequestType.Name,
                            Status = r.Status,
                            StatusText = DataContext.GetRequestStatusDisplayText(r.ID),
                            SubmittedBy = r.SubmittedBy.UserName,
                            SubmittedByName = r.SubmittedBy.FirstName + " " + r.SubmittedBy.LastName,
                            SubmittedByID = r.SubmittedByID,
                            SubmittedOn = r.SubmittedOn,
                            IsWorkflowRequest = r.WorkFlowActivityID.HasValue,
                            //if the request status is less than submitted only need Request.Edit permission, else also need the EditMetadataAfterSubmission permission.
                            CanEditMetadata = ((gAcl.Any() || pAcl.Where(a => a.PermissionID == PermissionIdentifiers.Request.Edit.ID).Any() || poAcl.Any()) && (gAcl.All(a => a.Allowed) && pAcl.Where(a => a.PermissionID == PermissionIdentifiers.Request.Edit.ID).All(a => a.Allowed) && poAcl.All(a => a.Allowed))) &&
                            ( (int)r.Status < 500 ? true : (pAcl.Where(a => a.PermissionID == PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata.ID).Any() && pAcl.Where(a => a.PermissionID == PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata.ID).All(a => a.Allowed)))
                        };

            return result;
        }

        /// <summary>
        /// Gets routes with request details.
        /// </summary>
        /// <remarks>
        /// The results can be filtered by datamart without altering the odata filter statement by specifing query paramters 'id' with the datamart id.
        /// </remarks>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<HomepageRouteDetailDTO> RequestsByRoute()
        {
            var globalAcls = DataContext.GlobalAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit);
            var projectAcls = DataContext.ProjectAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit, PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata);
            var projectOrganizationAcls = DataContext.ProjectOrganizationAcls.FilterAcl(Identity, PermissionIdentifiers.Request.Edit);

            var datamarts = DataContext.Secure<DataMart>(Identity, PermissionIdentifiers.DataMartInProject.SeeRequests);
            var requests = DataContext.Secure<Request>(Identity);

            var queryParameters = Request.GetQueryNameValuePairs().ToLookup(kv => kv.Key, kv => kv.Value);
            var dataMartID = queryParameters["id"].Select(q => Guid.Parse(q)).ToArray();
            if(dataMartID.Length > 0)
            {
                datamarts = datamarts.Where(dm => dataMartID.Contains(dm.ID));
            }

            var query = from rdm in DataContext.RequestDataMarts
                        join dm in datamarts on rdm.DataMartID equals dm.ID
                        join r in requests on rdm.RequestID equals r.ID
                        let gAcl = globalAcls
                        let pAcl = projectAcls.Where(a => a.ProjectID == r.ProjectID)
                        let poAcl = projectOrganizationAcls.Where(a => a.ProjectID == r.ProjectID && a.OrganizationID == r.OrganizationID)
                        select new HomepageRouteDetailDTO
                        {
                            DataMartID = rdm.DataMartID,
                            DueDate = rdm.DueDate,
                            Identifier = r.Identifier,
                            IsWorkflowRequest = r.WorkFlowActivityID.HasValue,
                            MSRequestID = r.MSRequestID,
                            Name = r.Name,
                            Priority = rdm.Priority,
                            Project = r.Project.Name,
                            RequestDataMartID = rdm.ID,
                            RequestID = rdm.RequestID,
                            RequestType = r.RequestType.Name,
                            RequestStatus = r.Status,
                            RoutingStatus = rdm.Status,
                            RoutingStatusText = rdm.Status == RoutingStatus.Draft ? "Draft" :
                                rdm.Status == RoutingStatus.Submitted ? "Submitted" :
                                rdm.Status == RoutingStatus.Completed ? "Completed" :
                                rdm.Status == RoutingStatus.AwaitingRequestApproval ? "Awaiting Request Approval" :
                                rdm.Status == RoutingStatus.RequestRejected ? "Request Rejected" :
                                rdm.Status == RoutingStatus.Canceled ? "Canceled" :
                                rdm.Status == RoutingStatus.Resubmitted ? "Re-submitted" :
                                rdm.Status == RoutingStatus.PendingUpload ? "Pending Upload" :
                                rdm.Status == RoutingStatus.AwaitingResponseApproval ? "Awaiting Response Approval" :
                                rdm.Status == RoutingStatus.Hold ? "Hold" :
                                rdm.Status == RoutingStatus.ResponseRejectedBeforeUpload ? "Response Rejected Before Upload" :
                                rdm.Status == RoutingStatus.ResponseRejectedAfterUpload ? "Response Rejected After Upload" :
                                rdm.Status == RoutingStatus.ExaminedByInvestigator ? "Examined By Investigator" :
                                rdm.Status == RoutingStatus.ResultsModified ? "Results Modified" :
                                rdm.Status == RoutingStatus.Failed ? "Failed" : "Unknown",
                            StatusText = DataContext.GetRequestStatusDisplayText(r.ID),
                            SubmittedByName = r.SubmittedBy.FirstName + " " + r.SubmittedBy.LastName,
                            SubmittedOn = r.SubmittedOn,
                            CanEditMetadata = ((gAcl.Any() || pAcl.Where(a => a.PermissionID == PermissionIdentifiers.Request.Edit.ID).Any() || poAcl.Any()) && (gAcl.All(a => a.Allowed) && pAcl.Where(a => a.PermissionID == PermissionIdentifiers.Request.Edit.ID).All(a => a.Allowed) && poAcl.All(a => a.Allowed))) &&
                                ((int)r.Status < 500 ? true : (pAcl.Where(a => a.PermissionID == PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata.ID).Any() && pAcl.Where(a => a.PermissionID == PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditRequestMetadata.ID).All(a => a.Allowed)))
                        };

            var result = query.AsNoTracking();

            return result;
        }

        /// <summary>
        /// Gets a list of DataMarts that are compatible with the current request's criteria, stratifiers etc.
        /// </summary>
        /// <param name="requestDetails"></param>
        /// <returns></returns>
        [HttpPost]
        public IQueryable<DataMartListDTO> GetCompatibleDataMarts(MatchingCriteriaDTO requestDetails)
        {
            //var dataMarts = (from dm in DataContext.Secure<DataMart>(Identity) where dm.Models.Any(m => m.Model.SupportedTerms.Any(st => requestDetails.TermIDs.Contains(st.TermID))) && dm.Models.All(m => m.Model.SupportedTerms.Any(st => requestDetails.TermIDs.Contains(st.TermID))) select dm).Map<DataMart, DataMartListDTO>();
            //var dataMarts = (from dm in DataContext.Secure<DataMart>(Identity) where (requestDetails.ProjectID == null || dm.Projects.Any(proj => proj.ProjectID == requestDetails.ProjectID)) && dm.Models.Any(m => m.Model.SupportedTerms.Any(st => requestDetails.TermIDs.Contains(st.TermID))) && dm.Models.Any(m => requestDetails.TermIDs.All(t => m.Model.SupportedTerms.Any(st => st.TermID == t)) && m.Model.SupportedTerms.Any(st => requestDetails.TermIDs.Contains(st.TermID))) select dm).Map<DataMart, DataMartListDTO>();

            if (!requestDetails.TermIDs.IsNull())
            {
                var requestID = requestDetails.RequestID;
                var datamartAcls = DataContext.DataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                var projectDatamartAcls = DataContext.ProjectDataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                var projectAcls = DataContext.ProjectRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                var requests = DataContext.Secure<Request>(Identity).Where(r => r.ID == requestID);

                var dataMarts = (from dm in DataContext.Secure<DataMart>(Identity)
                             where (requestDetails.ProjectID == null || dm.Projects.Any(proj => proj.ProjectID == requestDetails.ProjectID))
                                && dm.AdapterID.HasValue
                                && dm.Deleted == false
                                && dm.Adapter.SupportedTerms.Any(st => requestDetails.TermIDs.Any(t => t == st.TermID))
                                && requestDetails.TermIDs.All(t => dm.Adapter.SupportedTerms.Any(st => st.TermID == t))
                             from r in requests
                             let dmAcls = datamartAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.DataMartID == dm.ID)
                             let pdmAcls = projectDatamartAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.DataMartID == dm.ID && a.ProjectID == r.ProjectID)
                             let pAcls = projectAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.ProjectID == r.ProjectID)
                             where r.ID == requestID &&
                             (dmAcls.Any(a => a.Permission > 0) || pdmAcls.Any(a => a.Permission > 0) || pAcls.Any(a => a.Permission > 0))
                             &&
                             (dmAcls.All(a => a.Permission > 0) && pdmAcls.All(a => a.Permission > 0) && pAcls.All(a => a.Permission > 0))
                             select dm).Map<DataMart, DataMartListDTO>();

                return dataMarts;
            }
            else
            {
                if (requestDetails.Request.IsNullOrWhiteSpace())
                {
                    //The request is empty.
                    return null;
                }

                QueryComposerRequestDTO dto = Newtonsoft.Json.JsonConvert.DeserializeObject<DTO.QueryComposer.QueryComposerRequestDTO>(requestDetails.Request);
                if (dto == null || dto.Where.Criteria.Count() == 0)
                {
                    return null;
                }

                bool primaryCriteria = true;
                var predicate = PredicateBuilder.True<DataMart>();
                predicate = predicate.And(p => (requestDetails.ProjectID == null || p.Projects.Any(proj => proj.ProjectID == requestDetails.ProjectID)));

                foreach (var paragraph in dto.Where.Criteria)
                {
                    var inner = PredicateBuilder.True<DataMart>();
                    List<Guid> paragraphTermIDs = paragraph.Terms.Select(p => p.Type).Concat(paragraph.Criteria.SelectMany(c => c.Terms.Select(t => t.Type))).Distinct().ToList();

                    //changing from looking at the installed model to the adapter set on the datamart.
                    //require that the datamart supports all the specified terms
                    inner = inner.And(dm => dm.AdapterID.HasValue
                                         && dm.Deleted == false
                                         && dm.Adapter.SupportedTerms.Any(t => paragraphTermIDs.Any(a => a == t.TermID)) 
                                         && paragraphTermIDs.All(t => dm.Adapter.SupportedTerms.Any(st => st.TermID == t))
                                     );

                    if (!primaryCriteria)
                    {
                        //For additional paragraphs, we need to use AND or OR. 
                        if (paragraph.Operator == DTO.Enums.QueryComposerOperators.And)
                        {
                            predicate = predicate.And(inner.Expand());
                        }
                        else
                        {
                            predicate = predicate.Or(inner.Expand());
                        }
                    }
                    else
                    {
                        //Use AND as this is the primary/first paragraph.
                        primaryCriteria = false;
                        predicate = predicate.And(inner.Expand());
                    }
                }

                var requestID = requestDetails.RequestID;

                if (requestID == null)
                {
                    return null;

                }
                else
                {
                    var datamartAcls = DataContext.DataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                    var projectDatamartAcls = DataContext.ProjectDataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                    var projectAcls = DataContext.ProjectRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
                    var requests = DataContext.Secure<Request>(Identity).Where(r => r.ID == requestID);

                    var query = (from dm in DataContext.Secure<DataMart>(Identity)
                                 from r in requests
                                 let dmAcls = datamartAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.DataMartID == dm.ID)
                                 let pdmAcls = projectDatamartAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.DataMartID == dm.ID && a.ProjectID == r.ProjectID)
                                 let pAcls = projectAcls.Where(a => a.RequestTypeID == r.RequestTypeID && a.ProjectID == r.ProjectID)
                                 where r.ID == requestID &&
                                 (dmAcls.Any(a => a.Permission > 0) || pdmAcls.Any(a => a.Permission > 0) || pAcls.Any(a => a.Permission > 0))
                                 &&
                                 (dmAcls.All(a => a.Permission > 0) && pdmAcls.All(a => a.Permission > 0) && pAcls.All(a => a.Permission > 0))
                                 select dm).AsExpandable().Where(predicate).Map<DataMart, DataMartListDTO>();
                    return query;
                }
            }
        }

        /// <summary>
        /// Gets a list of DataMarts that are compatible, i.e. the Terms specified are supported, with the installed models on the DataMarts with the option to limit by ProjectID.
        /// Important: This function should not be used for QueryComposer request since they should not use the Installed Models. Also, the Request member of the MatchingCriteria does not affect the results.
        /// </summary>
        /// <param name="requestDetails"></param>
        /// <returns></returns>
        [HttpPost]
        public IQueryable<DataMartListDTO> GetDataMartsForInstalledModels(MatchingCriteriaDTO requestDetails)
        {
            if (!requestDetails.TermIDs.IsNull())
            {
                var dataMarts = (from dm in DataContext.Secure<DataMart>(Identity)
                                 where (requestDetails.ProjectID == null || dm.Projects.Any(proj => proj.ProjectID == requestDetails.ProjectID))
                                 && dm.Models.Any(m => m.Model.SupportedTerms.Any(st => requestDetails.TermIDs.Any(t => t == st.TermID)))
                                 && requestDetails.TermIDs.All(t => dm.Models.Any(m => m.Model.SupportedTerms.Any(st => st.TermID == t)))
                                 select dm).Map<DataMart, DataMartListDTO>();
                return dataMarts;
            }
            else if (requestDetails.ProjectID != null)
            {
                var dataMarts = (from dm in DataContext.Secure<DataMart>(Identity)
                                 where (requestDetails.ProjectID == null || dm.Projects.Any(proj => proj.ProjectID == requestDetails.ProjectID))
                                 select dm).Map<DataMart, DataMartListDTO>();
                return dataMarts;

            }

            //The request is empty.
            return null;
        }

        /// <summary>
        /// Returns the DataMarts for a given request based on security
        /// </summary>
        /// <param name="requestID"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IQueryable<RequestDataMartDTO>> RequestDataMarts(Guid requestID)
        {
            var results = DataContext.RequestDataMarts.Join(DataContext.Secure<Response>(Identity), rdm => rdm.ID, rsp => rsp.RequestDataMartID, (rdm, rsp) => rdm).Where(rdm => rdm.RequestID == requestID).Distinct().Map<RequestDataMart, RequestDataMartDTO>().ToArray();

            var externalRoutes = results.Where(r => r.RoutingType.HasValue && (r.RoutingType.Value == RoutingType.SourceCNDS || r.RoutingType.Value == RoutingType.ExternalCNDS)).ToArray();
            if (externalRoutes.Any())
            {
                var routeDefinitions = (await CNDSApi.RequestTypeMapping.ListRequestTypeDefinitions("$filter=" + string.Join(" OR ", externalRoutes.Select(rdm => string.Format("ID eq {0:D}", rdm.DataMartID))))).ToDictionary(k => k.ID);
                foreach(var route in results.Where(r => r.RoutingType.HasValue && (r.RoutingType.Value == RoutingType.SourceCNDS || r.RoutingType.Value == RoutingType.ExternalCNDS)))
                {
                    Lpp.CNDS.DTO.NetworkRequestTypeDefinitionDTO definition;
                    if(routeDefinitions.TryGetValue(route.DataMartID, out definition))
                    {
                        route.DataMart = string.Format("{0}/{1}/{2}/{3}", definition.Network, definition.Project, definition.RequestType, definition.DataSource);
                    }
                }
            }

            return results.AsQueryable();
        }

        /// <summary>
        /// Gets the details for external routes registered to a request.
        /// </summary>
        /// <param name="requestID">The ID of the request.</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IEnumerable<DataMartListDTO>> GetExternalRoutesForRequest(Guid requestID)
        {
            var requestDetails = await DataContext.Secure<Dns.Data.Request>(Identity).Where(r => r.ID == requestID).SingleOrDefaultAsync();
            if(requestDetails == null)
            {
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.NotFound, "The specified request was not found."));
            }

            var externalRequestDataMarts = await DataContext.RequestDataMarts.Where(rdm => rdm.RequestID == requestID && rdm.DataMart.DataMartTypeID == CNDSDataMartTypeID).ToArrayAsync();

            var routeDefinitions = (await CNDSApi.RequestTypeMapping.ListRequestTypeDefinitions("$filter=" + string.Join(" OR ", externalRequestDataMarts.Select(rdm => string.Format("ID eq {0:D}", rdm.DataMartID))))).ToDictionary(k => k.ID);

            List<DataMartListDTO> dtos = new List<DataMartListDTO>();
            foreach (var d in externalRequestDataMarts)
            {
                DataMartListDTO dto = new DataMartListDTO {
                    ID = d.DataMartID,
                    Name = "",
                    Acronym = "",
                    Description = "",
                    Priority = d.Priority                    
                };

                if (d.DueDate.HasValue)
                {
                    dto.DueDate = d.DueDate.Value;
                }

                Lpp.CNDS.DTO.NetworkRequestTypeDefinitionDTO routeDefinition;
                if(routeDefinitions.TryGetValue(d.DataMartID, out routeDefinition))
                {
                    dto.Name = routeDefinition.DataSource;
                    dto.Organization = string.Format("{0} / {1} / {2} / {3}", routeDefinition.Network, routeDefinition.Project, routeDefinition.RequestType, routeDefinition.DataSource);
                }

                dtos.Add(dto);
            }

            return dtos;
        }
        
        /// <summary>
        /// Returns the routings for the specified request that can have their routing status overriden.
        /// </summary>
        /// <param name="requestID">The ID of the request.</param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<RequestDataMartDTO> GetOverrideableRequestDataMarts(Guid requestID)
        {
            var dmRequestTypeAcls = DataContext.DataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID) ;
            var projectRequestTypeAcls = DataContext.ProjectRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
            var projectDataMartRequestTypeAcls = DataContext.ProjectDataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);

            var dmAcls = DataContext.DataMartAcls.FilterAcl(Identity, PermissionIdentifiers.Request.OverrideDataMartRoutingStatus);
            var projectAcls = DataContext.ProjectAcls.FilterAcl(Identity, PermissionIdentifiers.Request.OverrideDataMartRoutingStatus);
            var projectDataMartAcls = DataContext.ProjectDataMartAcls.FilterAcl(Identity, PermissionIdentifiers.Request.OverrideDataMartRoutingStatus);

            var results = from dm in DataContext.Secure<DataMart>(Identity) 
                             join rdm in DataContext.RequestDataMarts on dm.ID equals rdm.DataMartID 
                             join r in DataContext.Secure<Request>(Identity) on rdm.RequestID equals r.ID
                             let dmA = dmRequestTypeAcls.Where(a => a.DataMartID == dm.ID)
                             let pA = projectRequestTypeAcls.Where(a => a.ProjectID == r.ProjectID)
                             let pdmA = projectDataMartRequestTypeAcls.Where(a => a.ProjectID == r.ProjectID && a.DataMartID == dm.ID)
                             let dmO = dmAcls.Where(a => a.DataMartID == dm.ID)
                             let prjO = projectAcls.Where(a => a.ProjectID == r.ProjectID)
                             let prjdmO = projectDataMartAcls.Where(a => a.ProjectID == r.ProjectID && a.DataMartID == dm.ID)
                             where rdm.RequestID == requestID && 
                             (
                                (dmA.Any() && dmA.All(a => a.Permission > 0)) ||
                                (pA.Any() && pA.All(a => a.Permission > 0)) ||
                                (pdmA.Any() && pdmA.All(a => a.Permission > 0))
                             )
                             && !CompletedRoutingStatuses.Contains(rdm.Status)
                             && (
                                (dmO.Any() || prjO.Any() || prjdmO.Any())
                                &&
                                (dmO.All(a => a.Allowed) && prjO.All(a => a.Allowed) && prjdmO.All(a => a.Allowed))
                             )
                             select rdm;


            return results.Map<RequestDataMart, RequestDataMartDTO>();
        }
        /// <summary>
        /// update request datamarts
        /// </summary>
        /// <param name="dataMarts"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UpdateRequestDataMarts(IEnumerable<UpdateRequestDataMartStatusDTO> dataMarts)
        {
            List<Guid> responsesAltered = new List<Guid>();

            //load up request datamart objects 
            var requestDataMartIDs = dataMarts.Select(i => i.RequestDataMartID).ToArray();
            var requestDataMarts = DataContext.RequestDataMarts.Include(rdm => rdm.Responses).Where(dm => requestDataMartIDs.Contains(dm.ID)).ToArray();

            var request = DataContext.Requests.Where(r => r.DataMarts.Where(rdm => requestDataMartIDs.Contains(rdm.ID)).Any()).First();
            var originalStatus = request.Status;

            foreach (var requestDataMart in requestDataMarts)
            {
                var filter = new ExtendedQuery
                {
                    DataMarts = a => a.DataMartID == requestDataMart.DataMartID,
                    Projects = a => a.Project.Requests.Any(r => r.ID == requestDataMart.RequestID) && a.Project.DataMarts.Any(d => d.DataMartID == requestDataMart.DataMartID),
                    ProjectDataMarts = a => a.DataMartID == requestDataMart.DataMartID && a.Project.Requests.Any(r => r.ID == requestDataMart.RequestID)
                };

                var permissions = await DataContext.HasGrantedPermissions<Request>(Identity, requestDataMart.RequestID, PermissionIdentifiers.Request.OverrideDataMartRoutingStatus);

                if (!permissions.Any())
                {
                    return Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to override the status of a routing for one or more of the specified DataMarts.");
                }

                dataMarts.ForEach((d) =>
                {
                    if (d.RequestDataMartID == requestDataMart.ID)
                    {
                        requestDataMart.Status = d.NewStatus;
                        var currentResponse = requestDataMart.Responses.OrderByDescending(r => r.Count).FirstOrDefault();
                        currentResponse.ResponseMessage = d.Message;

                        //only set the response time and ID if the response is completed
                        if (CompletedRoutingStatuses.Contains(d.NewStatus))
                        {
                            currentResponse.ResponseTime = DateTime.UtcNow;
                            currentResponse.RespondedByID = Identity.ID;
                        }

                        responsesAltered.Add(currentResponse.ID);
                    }
                });
            }
            
            await DataContext.SaveChangesAsync();

            await DataContext.Entry(request).ReloadAsync();

            if (request.Status == RequestStatuses.Complete && originalStatus != RequestStatuses.Complete)
            {

                var requestStatusLogger = new Dns.Data.RequestLogConfiguration();
                string[] emailText = await requestStatusLogger.GenerateRequestStatusChangedEmailContent(DataContext, request.ID, Identity.ID, originalStatus, request.Status);
                var logItems = requestStatusLogger.GenerateRequestStatusEvents(DataContext, Identity, false, originalStatus, request.Status, request.ID, emailText[1], emailText[0], "Request Status Changed");

                await DataContext.SaveChangesAsync();

                await Task.Run(() => {

                    List<Utilities.Logging.Notification> notifications = new List<Utilities.Logging.Notification>();

                    foreach (Lpp.Dns.Data.Audit.RequestStatusChangedLog logitem in logItems)
                    {
                        var items = requestStatusLogger.CreateNotifications(logitem, DataContext, true);
                        if (items != null && items.Any())
                            notifications.AddRange(items);
                    }

                    if (notifications.Any())
                        requestStatusLogger.SendNotification(notifications);
                });
            }

            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Update Routings Priorities and DueDates
        /// </summary>
        /// <param name="dataMarts"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UpdateRequestDataMartsMetadata(IEnumerable<DTO.RequestDataMartDTO> dataMarts)
        {
            //load up request datamart objects 
            var requestDataMartIDs = dataMarts.Select(i => i.ID).ToArray();
            var requestDataMarts = DataContext.RequestDataMarts.Include(rdm => rdm.Responses).Where(dm => requestDataMartIDs.Contains(dm.ID)).ToArray();

            foreach (var requestDataMart in requestDataMarts)
            {
                foreach (var dataMart in dataMarts)
                {
                    if (requestDataMart.ID == dataMart.ID)
                    {
                        requestDataMart.DueDate = dataMart.DueDate;
                        requestDataMart.Priority = dataMart.Priority;
                    }
                }
            }
            
            await DataContext.SaveChangesAsync();

            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Returns a list of Requester Centers
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<RequesterCenterDTO> ListRequesterCenters()
        {
            return DataContext.RequesterCenters.Map<RequesterCenter, RequesterCenterDTO>();
        }

        /// <summary>
        /// Returns a list of Work Plan Types
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<WorkplanTypeDTO> ListWorkPlanTypes()
        {
            return DataContext.WorkplanTypes.Map<WorkplanType, WorkplanTypeDTO>();
        }

        /// <summary>
        /// Returns a list of Request Aggregation Levels
        /// </summary>
        [HttpGet]
        public IQueryable<ReportAggregationLevelDTO> ListReportAggregationLevels()
        {
            return DataContext.ReportAggregationLevels.Map<ReportAggregationLevel, ReportAggregationLevelDTO>();
        }

        /// <summary>
        /// Gets the workflow history for the specified request.
        /// </summary>
        /// <param name="requestID">The ID of the request.</param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<WorkflowHistoryItemDTO> GetWorkflowHistory(Guid requestID)
        {
            return DataContext.GetWorkflowHistory(requestID, Identity.ID);
        }

        ///<summary>
        /// Gets the response history for the specified request dataMart
        /// </summary>
        [HttpGet]
        public async Task<ResponseHistoryDTO> GetResponseHistory(Guid requestDataMartID, Guid requestID)
        {
            var queryFilter = new ExtendedQuery
            {
                Projects = p => p.Project.Requests.Any(a => a.ID == requestID) && p.Project.DataMarts.Any(a => a.DataMart.Requests.Any(rdm => rdm.ID == requestDataMartID)),
                Organizations = o => o.Organization.Requests.Any( a => a.ID == requestID) && o.Organization.DataMarts.Any(b => b.Requests.Any(c=> c.ID == requestDataMartID)),
                ProjectOrganizations = po => po.Project.Requests.Any(a => a.ID == requestID) && po.Project.DataMarts.Any(a => a.DataMart.Requests.Any(rdm => rdm.ID == requestDataMartID)) && po.Organization.Requests.Any(a => a.ID == requestID) && po.Organization.DataMarts.Any(b => b.Requests.Any(c => c.ID == requestDataMartID))
            };

            bool canView = (await DataContext.HasGrantedPermissions<Request>(Identity, requestID, queryFilter, PermissionIdentifiers.Request.ViewHistory)).Any();
            if (!canView)
            {
                return new ResponseHistoryDTO {
                    ErrorMessage = "Do not have permission to view response history."
                };
            }

            var requestDatamart = DataContext.RequestDataMarts.Where(r => requestDataMartID == r.ID)
                                                .Select(r => new
                                                {
                                                    DataMartName = r.DataMart.Name,
                                                    CurrentCount = r.Responses.Max(rr => rr.Count),
                                                    Responses = r.Responses.Select(rr => new { rr.ID, rr.SubmittedOn, SubmittedBy = rr.SubmittedBy.UserName, rr.SubmitMessage, rr.ResponseTime, rr.ResponseMessage, rr.Count, RespondedBy = rr.RespondedBy.UserName }).OrderBy(rr => rr.SubmittedOn)
                                                }).FirstOrDefault();

            if (requestDatamart != null)
            {
                bool first = true;
                var route = new ResponseHistoryDTO() { DataMartName = requestDatamart.DataMartName };
                List<ResponseHistoryItemDTO> historyItems = new List<ResponseHistoryItemDTO>();
                requestDatamart.Responses.ForEach(response =>
                {
                    historyItems.Add(new ResponseHistoryItemDTO
                    {
                        ResponseID = response.ID,
                        RequestID = requestID,
                        Action = first ? "Submitted" : "ReSubmitted",
                        DateTime = response.SubmittedOn,
                        UserName = response.SubmittedBy,
                        Message = response.SubmitMessage,
                        IsResponseItem = false,
                        IsCurrent = requestDatamart.CurrentCount == response.Count
                    });

                    if (response.ResponseTime.HasValue)
                    {
                        historyItems.Add(new ResponseHistoryItemDTO
                        {
                            ResponseID = response.ID,
                            RequestID = requestID,
                            Action = "Responded",
                            DateTime = response.ResponseTime.Value,
                            UserName = response.RespondedBy,
                            Message = response.ResponseMessage,
                            IsResponseItem = true,
                            IsCurrent = requestDatamart.CurrentCount == response.Count
                        });
                    }

                    first = false;
                });
                route.HistoryItems = historyItems;

                return route;
            }
            else return null;
        }


        /// <summary>
        /// Gets the request search terms for the specified request.
        /// </summary>
        /// <param name="requestID">The ID of the request.</param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<RequestSearchTermDTO> GetRequestSearchTerms(Guid requestID)
        {
            return (from t in DataContext.RequestSearchTerms
                   join r in DataContext.Secure<Request>(Identity) on t.RequestID equals r.ID
                   where r.ID == requestID
                   select t).Map<RequestSearchTerm, RequestSearchTermDTO>();
        }


        ///<summary>
        /// Gets the model IDs associated with the Request Type
        /// </summary>
        /// <param name="requestID">The ID of the request</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Guid[]> GetRequestTypeModels(Guid requestID)
        {
            var requestTypeID = DataContext.Requests.Where(r => r.ID == requestID).Select(r => r.RequestTypeID).First();
            return (DataContext.RequestTypeDataModels.Where(rt => rt.RequestTypeID == requestTypeID).Select(rt => rt.DataModelID).ToArray());
        }

        /// <summary>
        /// Update the request metadata
        /// </summary>
        /// <param name="req"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UpdateRequestMetadata(RequestMetadataDTO reqMetadata)
        {
            if (reqMetadata.MSRequestID != null && reqMetadata.MSRequestID != "" &&
                DataContext.Requests.Any(req => req.MSRequestID == reqMetadata.MSRequestID && req.ID != reqMetadata.ID))
            {
                return Request.CreateErrorResponse(HttpStatusCode.Forbidden, "The Request ID is not unique. Please enter in a different Request ID.");
            }

            var request = await DataContext.Requests.FindAsync(reqMetadata.ID);
            request.Name = reqMetadata.Name;
            request.Description = reqMetadata.Description;
            request.PurposeOfUse = reqMetadata.PurposeOfUse;
            request.PhiDisclosureLevel = reqMetadata.PhiDisclosureLevel;
            request.RequesterCenterID = reqMetadata.RequesterCenterID;
            request.WorkplanTypeID = reqMetadata.WorkplanTypeID;
            request.DueDate = reqMetadata.DueDate;
            request.Priority = reqMetadata.Priority;
            request.MSRequestID = reqMetadata.MSRequestID;
            request.ReportAggregationLevelID = reqMetadata.ReportAggregationLevelID;

            if (reqMetadata.ActivityProjectID.HasValue)
            {
                request.ActivityID = reqMetadata.ActivityProjectID.Value;
            }
            else if (reqMetadata.ActivityID.HasValue)
            {
                request.ActivityID = reqMetadata.ActivityID.Value;
            }
            else if (reqMetadata.TaskOrderID.HasValue)
            {
                request.ActivityID = reqMetadata.TaskOrderID.Value;
            }
            else
            {
                request.ActivityID = null;
            }

            request.SourceActivityID = reqMetadata.SourceActivityID;
            request.SourceActivityProjectID = reqMetadata.SourceActivityProjectID;
            request.SourceTaskOrderID = reqMetadata.SourceTaskOrderID;

            //need to save Source Activity names
            //request.SourceActivity.Name = DataContext.Activities.Where(ac => ac.ID == request.SourceActivityID).Select(a => a.Name).FirstOrDefault();
            //request.SourceActivityProject.Name = DataContext.Activities.Where(ac => ac.ID == request.SourceActivityProjectID).Select(a => a.Name).FirstOrDefault();
            //request.SourceTaskOrder.Name = DataContext.Activities.Where(ac => ac.ID == request.SourceTaskOrderID).Select(a => a.Name).FirstOrDefault();

            await DataContext.SaveChangesAsync();
            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Updates the specified requests metadata values. Currently only Priority and Due Date is supported.
        /// </summary>
        /// <param name="updates">A collection of metadata updates.</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UpdateMetadataForRequests(IEnumerable<RequestMetadataDTO> updates)
        {
            //TODO: talk to Zac about that, if doing overall change should that only go to permission routes or all regardless of permission?

            Guid[] requestIDs = updates.Where(r => r.ID.HasValue).Select(r => r.ID.Value).Distinct().ToArray();

            var requests = await DataContext.Secure<Request>(Identity, PermissionIdentifiers.Request.Edit).Where(r => requestIDs.Contains(r.ID)).ToArrayAsync();

            if (requests.Length < requestIDs.Length)
            {
                return Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to edit one or more of the specified requests.");
            }

            IEnumerable<RequestDataMart> routes = Enumerable.Empty<RequestDataMart>();
            if (updates.Any(u => u.ApplyChangesToRoutings.HasValue && u.ApplyChangesToRoutings.Value))
            {
                requestIDs = updates.Where(r => r.ID.HasValue && r.ApplyChangesToRoutings.HasValue && r.ApplyChangesToRoutings.Value).Select(r => r.ID.Value).Distinct().ToArray();                

                routes = await DataContext.RequestDataMarts.Join(DataContext.Secure<DataMart>(Identity), rdm => rdm.DataMartID, dm => dm.ID, (rdm, dm) => rdm).Where(rdm => requestIDs.Contains(rdm.RequestID) && !CompletedRoutingStatuses.Contains(rdm.Status)).ToArrayAsync();
            }

            foreach (var update in updates)
            {
                var request = requests.Single(r => r.ID == update.ID.Value);
                request.Priority = update.Priority;
                request.DueDate = update.DueDate;

                foreach (var route in routes.Where(rdm => rdm.RequestID == request.ID))
                {
                    route.Priority = update.Priority;
                    route.DueDate = update.DueDate;
                }
            }

            await DataContext.SaveChangesAsync();

            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Gets the organizations of the datamarts associated with specified project.
        /// Used by DataChecker QE to get the data partners for a request.
        /// </summary>
        /// <param name="projectID">The ID of the project.</param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<OrganizationDTO> GetOrganizationsForRequest(Guid projectID)
        {
            var orgs = (from o in DataContext.Organizations
                        where o.DataMarts.Any(dm => dm.Deleted == false && dm.Projects.Any(p => p.Project.Active && p.Project.Deleted == false && p.Project.ID == projectID)) && o.Deleted == false
                        orderby o.Name ascending
                        select new OrganizationDTO {
                            ID = o.ID,
                            Acronym = o.Acronym,
                            Name = o.Name,
                            ParentOrganizationID = o.ParentOrganizationID,
                        });
                return orgs;
        }


        /// <summary>
        /// Checks if user is allowed to copy a request
        /// </summary>
        /// <param name="requestID">The ID of the request to be copied </param>
        /// <returns></returns>
        [HttpGet]
        public async Task<bool> AllowCopyRequest(Guid requestID)
        {
            var request = DataContext.Requests.Where(r => r.ID == requestID).First();
            var dataMartIDs = DataContext.RequestDataMarts.Where(dm => dm.RequestID == request.ID).Select(d => d.DataMartID).ToArray();
            var projectAcls = DataContext.ProjectDataMartRequestTypeAcls.Where(pa => pa.ProjectID == request.ID && pa.RequestTypeID == request.RequestTypeID && dataMartIDs.Contains(pa.DataMartID));


            var result = await (from r in DataContext.Secure<Request>(Identity)
                                 where r.ID == requestID
                                 let pAcls = DataContext.ProjectRequestTypeAcls.Where(pa => pa.ProjectID == request.ProjectID && pa.RequestTypeID == request.RequestTypeID)
                                 let dAcls = DataContext.DataMartRequestTypeAcls.Where(da => dataMartIDs.Contains(da.DataMartID) && da.RequestTypeID == request.RequestTypeID)
                                 let pdmAcls = DataContext.ProjectDataMartRequestTypeAcls.Where(pda => pda.ProjectID == request.ProjectID && pda.RequestTypeID == request.RequestTypeID && dataMartIDs.Contains(pda.DataMartID))
                                 where (
                                   (pAcls.Any() || dAcls.Any() || pdmAcls.Any())
                                   &&
                                   (pAcls.All(a => a.Permission > 0) && dAcls.All(a => a.Permission > 0) && pdmAcls.All(a => a.Permission > 0))
                                 )
                                 select r.ID).AnyAsync();

            return result;
        }

        /// <summary>
        /// Creates a copy of the request.
        /// </summary>
        /// <param name="requestID">The ID of the request to be copied.</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Guid> CopyRequest([FromBody]Guid requestID)
        {
            //add secure here
            Request request = DataContext.Secure<Request>(Identity).Where(rq => rq.ID == requestID).FirstOrDefault();
            if (request == null)
                throw new UnauthorizedAccessException("Not authorized to access the request.");

            var activityID = DataContext.WorkflowActivityCompletionMaps.Where(wa => wa.WorkflowID == request.WorkflowID && wa.SourceWorkflowActivity.Start == true).Select(a => a.SourceWorkflowActivityID).First();

            //create a new request
            var r = DataContext.Requests.Add(new Request
            {
                Name = request.Name + " (Copy)", //need max min here?
                Description = "",
                AdditionalInstructions = "",
                ProjectID = request.ProjectID,
                RequestTypeID = request.RequestTypeID,
                CreatedByID = Identity.ID,
                UpdatedByID = Identity.ID,
                OrganizationID = request.OrganizationID,
                Priority = Priorities.Medium,
                DataMarts = new List<RequestDataMart>(),
                WorkflowID = request.WorkflowID,
                WorkFlowActivityID = activityID,
                Query = request.Query
            });

            //update the rest of the metadata
            r.PurposeOfUse = request.PurposeOfUse;
            r.PhiDisclosureLevel = request.PhiDisclosureLevel;
            r.Description = request.Description ?? string.Empty;
            r.AdditionalInstructions = request.AdditionalInstructions ?? string.Empty;
            r.Priority = (Priorities)request.Priority;
            r.ActivityID = request.ActivityID;
            r.Activity = request.ActivityID == null ? null : DataContext.Activities.SingleOrDefault(a => a.ID == request.ActivityID);
            r.ActivityDescription = request.ActivityDescription ?? string.Empty;
            r.SourceActivityID = request.SourceActivityID;
            r.SourceActivity = request.SourceActivityID == null ? null : DataContext.Activities.SingleOrDefault(a => a.ID == request.SourceActivityID);
            r.SourceActivityProjectID = request.SourceActivityProjectID;
            r.SourceActivityProject = request.SourceActivityProjectID == null ? null : DataContext.Activities.SingleOrDefault(a => a.ID == request.SourceActivityProjectID);
            r.SourceTaskOrderID = request.SourceTaskOrderID;
            r.SourceTaskOrder = request.SourceTaskOrderID == null ? null : DataContext.Activities.SingleOrDefault(a => a.ID == request.SourceTaskOrderID);
            r.DueDate = request.DueDate;
            r.RequesterCenterID = request.RequesterCenterID;
            r.WorkplanTypeID = request.WorkplanTypeID;
            r.MirrorBudgetFields = Convert.ToBoolean(request.MirrorBudgetFields);
            r.ReportAggregationLevelID = request.ReportAggregationLevelID;            

            //update the datamarts
            foreach (var dm in DataContext.RequestDataMarts.Where(rdm => rdm.RequestID == requestID && rdm.Status != RoutingStatus.Canceled && DataContext.DataMarts.Any(dm => dm.ID == rdm.DataMartID)).ToArray())
            {
                var originalDataMart = dm;
                var requestDataMart = new RequestDataMart
                {
                    DataMartID = originalDataMart.DataMartID,
                    RequestID = r.ID,
                    DueDate = dm.DueDate,
                    Priority = dm.Priority,
                    Status = RoutingStatus.Draft,
                    Responses = new HashSet<Response>(),
                    RoutingType = dm.RoutingType
                };

                r.DataMarts.Add(requestDataMart);

                requestDataMart.Responses.Add(new Response
                {
                    RequestDataMartID = requestDataMart.ID,
                    RequestDataMart = requestDataMart,
                    SubmittedByID = Identity.ID
                });
            }

            r.Private = r.DataMarts.Count == 0;

            var ta = new PmnTask
            {
                CreatedOn = DateTime.UtcNow,
                Priority = DTO.Enums.Priorities.Medium,
                StartOn = DateTime.UtcNow,
                Status = DTO.Enums.TaskStatuses.InProgress,
                Subject = DataContext.Workflows.Where(w => w.ID == r.WorkflowID).Select(w => w.Name).FirstOrDefault() + ": " + DataContext.WorkflowActivities.Where(a => a.ID == r.WorkFlowActivityID).Select(a => a.Name).FirstOrDefault(),
                Type = DTO.Enums.TaskTypes.Task,
                WorkflowActivityID = r.WorkFlowActivityID
            };

            DataContext.Actions.Add(ta);

            var reference = new TaskReference
            {
                ItemID = r.ID,
                TaskID = ta.ID,
                Type = DTO.Enums.TaskItemTypes.Request
            };

            DataContext.ActionReferences.Add(reference);


            await DataContext.SaveChangesAsync();

            await DataContext.Entry(r).ReloadAsync();
            r.MSRequestID = "Request-" + r.Identifier;
            await DataContext.SaveChangesAsync();

            return r.ID;
        }



        ///// <summary>
        ///// Gets the available projects that the user has permission to manage.
        ///// </summary>
        ///// <param name="requestTypeID"></param>
        ///// <returns></returns>
        //[HttpGet]
        //public async Task<Guid> GetGrantedProjects(Guid requestTypeID)
        //{
        //    var result = from p in DataContext.Secure<Project>(Identity)
        //         where (!p.Deleted
        //            && !p.Group.Deleted
        //            && !p.Deleted
        //            && (p.ProjectDataMartRequestTypeAcls.Any(a => a.RequestTypeID == requestTypeID && a.Permission > 0 && a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID))
        //            || p.ProjectRequestTypeAcls.Any(a => a.RequestTypeID == requestTypeID && a.Permission > 0 && a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID))))
        //         select p.ID;

        //    return result.FirstOrDefault();
        //}
    }
}
