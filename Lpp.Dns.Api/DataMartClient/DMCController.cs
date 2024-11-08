﻿using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Xml.Linq;
using Lpp.Utilities.WebSites.Controllers;
using dmc = Lpp.Dns.DTO.DataMartClient;
using Lpp.Dns.Data;
using Lpp.Objects;
using Lpp.Dns.WebServices;
using Lpp.Dns.DTO.Security;
using System.Dynamic;

namespace Lpp.Dns.Api.DataMartClient
{
    /// <summary>
    /// Actions for supporting DMC client.
    /// </summary>
    /// <remarks>This controller is intentionally not included in the Lpp.Dns.NetClient generated file so that a dependency is not needed on Lpp.Dns.DTO.DataMartClient.</remarks>
    [ClientEntityIgnore]
    public class DMCController : LppApiController<Lpp.Dns.Data.DataContext>
    {
        static readonly Guid LegacyModularProcessorID = new Guid("C8BC0BD9-A50D-4B9C-9A25-472827C8640A");
        static readonly Guid ModularProgramTermID = new Guid("A1AE0001-E5B4-46D2-9FAD-A3D8014FFFD8");
        static readonly Guid ModularModelID = new Guid("1B0FFD4C-3EEF-479D-A5C4-69D8BA0D0154");
        static readonly Guid DefaultQEAdapterProcessorID = new Guid("AE0DA7B0-0F73-4D06-B70B-922032B7F0EB");
        static readonly log4net.ILog Logger = log4net.LogManager.GetLogger(typeof(DMCController));
        /// <summary>
        /// Gets the current Utilities.Security.ApiIdentity.
        /// </summary>
        /// <returns></returns>
        protected virtual Utilities.Security.ApiIdentity GetCurrentIdentity()
        {
            return Identity;
        }

        /// <summary>
        /// Gets the profile for the authenticated user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public async Task<dmc.Profile> GetProfile()
        {
            //authorize the user and then return details about the currently logged in user
            var identity = GetCurrentIdentity();
            var user = await (from u in DataContext.Users where u.ID == identity.ID && u.Active && !u.Deleted select new dmc.Profile { Email = u.Email, FullName = u.FirstName + " " + u.LastName, OrganizationName = u.Organization.Name, Username = u.UserName }).SingleOrDefaultAsync();

            if(user == null)
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "Invalid username or password, please check credentials."));

            return user;
        }        

        /// <summary>
        /// Gets the datamarts the authenticated user is authorized to see requests for.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<dmc.DataMart> GetDataMarts()
        {
            var result = GetGrantedDataMarts().Select(d => new dmc.DataMart
            {
                ID = d.ID,
                Name = d.Name,
                UnattendedMode = (DTO.DataMartClient.Enums.UnattendedModes)(int)(d.UnattendedMode ?? DTO.Enums.UnattendedModes.NoUnattendedOperation),
                OrganizationID = d.OrganizationID,
                OrganizationName = d.Organization.Name,
                Models = d.Models.Where(m => d.AdapterID.HasValue || m.Model.RequestTypes.Select(rt => rt.RequestType.ProcessorID).Any()).Select(m => new dmc.Model
                {
                    ID = d.AdapterID.HasValue ? d.AdapterID.Value : m.ModelID,
                    ProcessorID = d.ProcessorID.HasValue ? d.ProcessorID.Value : (d.AdapterID.HasValue ? DefaultQEAdapterProcessorID : m.Model.RequestTypes.Where(rt => rt.RequestType.ProcessorID.HasValue).Select(rt => rt.RequestType.ProcessorID).FirstOrDefault() ?? Guid.Empty),
                    PackageIdentifier = (d.AdapterID.HasValue ? DataContext.RequestTypes.Where(rt => (d.ProcessorID.HasValue && d.ProcessorID.Value == rt.ProcessorID.Value) || rt.ProcessorID.Value == DefaultQEAdapterProcessorID).Select(rt => rt.PackageIdentifier).FirstOrDefault() : m.Model.RequestTypes.Select(rt => rt.RequestType.PackageIdentifier).FirstOrDefault()) ?? string.Empty,
                    Name = d.AdapterID.HasValue ? d.Adapter.Name : m.Model.Name,
                    Properties = d.Models.Where(im => im.ModelID == m.ModelID).Select(im => im.Properties).FirstOrDefault()
                })
            });

            return result;
        }

        

        /// <summary>
        /// Gets the current request list.
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        /// <remarks>Note: To and From dates should be specified in UTC.</remarks>
        [HttpPost]
        public async Task<dmc.RequestList> GetRequestList(DTO.DataMartClient.Criteria.RequestListCriteria criteria)
        {
            if (criteria == null)
            {
                criteria = new dmc.Criteria.RequestListCriteria { 
                    StartIndex = 0
                };
            }
            var rd = from r in DataContext.Requests
                     where r.SubmittedOn != null && (criteria.FromDate == null || r.SubmittedOn >= criteria.FromDate) && (criteria.ToDate == null || r.SubmittedOn <= criteria.ToDate)
                     && r.RequestType.ProcessorID.HasValue
                     from d in r.DataMarts
                     from i in d.Responses
                     let isCurrent = i.Count == d.Responses.Max(rr => rr.Count)
                     where isCurrent && d.Status != DTO.Enums.RoutingStatus.Draft && d.Status != DTO.Enums.RoutingStatus.AwaitingRequestApproval && d.Status != DTO.Enums.RoutingStatus.Canceled && d.Status > 0
                     select new { r, d, i, OrganizationID = d.DataMart.OrganizationID };

            if (criteria.FilterByDataMartIDs != null && criteria.FilterByDataMartIDs.Any())
            {
                rd = rd.Where(x => criteria.FilterByDataMartIDs.Contains(x.d.DataMartID));
            }

            if (criteria.FilterByStatus != null && criteria.FilterByStatus.Any())
            {
                rd = rd.Where(x => criteria.FilterByStatus.Any(s => (int)s == (int)x.d.Status));
            }

            var res = from gd in GetGrantedDataMarts().SelectMany(x => x.Projects.Select(p => new { DataMartID = x.ID, p.ProjectID })).GroupBy(k => new { ProjectID = k.ProjectID, DataMartID = k.DataMartID })
                      join dm in rd on gd.Key equals new { ProjectID = dm.r.ProjectID, DataMartID = dm.d.DataMartID }
                      let r = dm.r
                      let d = dm.d
                      let i = dm.i
                      select new
                      {
                          r.ID,
                          r.Identifier,
                          r.MSRequestID,
                          r.Name,
                          r.RequestTypeID,
                          Priority = d.Priority,
                          DueDate = d.DueDate ?? r.DueDate,
                          RequestTypeName = r.RequestType.Name,
                          RequestTypeModelName = d.DataMart.AdapterID.HasValue ? d.DataMart.Adapter.Name : r.RequestType.Models.Select(m => m.DataModel.Name).FirstOrDefault(),
                          RequestTypePackageIdentifier = r.RequestType.PackageIdentifier,
                          r.AdapterPackageVersion,
                          d.Status,
                          r.SubmittedOn,                          
                          d.DataMartID,
                          DataMartName = d.DataMart.Name,
                          CreatedByUsername = r.CreatedBy.UserName,
                          RespondedByUsername = i.RespondedBy.UserName,
                          i.ResponseTime,
                          //PMNDEV-987: Submitted time is based on the time the routing is submitted, falling back to request submitted time if not available, field is non-nullable so it defaults to '0001-01-01 00:00:00.0000000'
                          RoutingSubmittedOn = i.SubmittedOn < new DateTime(1900, 1, 1) ? (r.SubmittedOn ?? DateTime.UtcNow) : i.SubmittedOn,
                          ProjectName = r.Project.Name,
                          AllowUnattendedProcessing = (from rt in DataContext.RequestTypes
                                                       let datamartRequestTypesFilter = DataContext.DataMartRequestTypeAcls.Where(a => a.RequestTypeID == rt.ID && a.SecurityGroup.Users.Any(u => u.UserID == r.CreatedByID) && a.Permission >= DTO.Enums.RequestTypePermissions.Automatic && a.DataMartID == d.DataMartID)
                                                       let projectDataMartRequestTypesFilter = DataContext.ProjectDataMartRequestTypeAcls.Where(a => a.RequestTypeID == rt.ID && a.SecurityGroup.Users.Any(u => u.UserID == r.CreatedByID) && a.Permission >= DTO.Enums.RequestTypePermissions.Automatic && a.DataMartID == d.DataMartID && a.ProjectID == r.ProjectID)
                                                       let projectRequestTypesFilter = DataContext.ProjectRequestTypeAcls.Where(a => a.RequestTypeID == rt.ID && a.SecurityGroup.Users.Any(u => u.UserID == r.CreatedByID) && a.Permission >= DTO.Enums.RequestTypePermissions.Automatic && a.ProjectID == r.ProjectID)
                                                       where rt.ID == r.RequestTypeID
                                                       && (datamartRequestTypesFilter.Any() || projectDataMartRequestTypesFilter.Any() || projectRequestTypesFilter.Any())                                                       
                                                       select rt).Any()

                      };

            var totalCount = await res.CountAsync();

            var effectiveSortColumn = criteria.SortColumn ?? dmc.RequestSortColumn.RequestTime;

            var sortHelper = SortIf(res, effectiveSortColumn, criteria.SortAscending);

            res =
                sortHelper.sort(dmc.RequestSortColumn.RequestId, r => r.ID) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestName, r => r.Name) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestPriority, r => r.Priority) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestType, r => r.RequestTypeID) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestModelType, r => r.RequestTypeID) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestDueDate, r => r.DueDate) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestStatus, r => r.Status) ??
                sortHelper.sort(dmc.RequestSortColumn.RequestTime, r => r.RoutingSubmittedOn) ??
                sortHelper.sort(dmc.RequestSortColumn.MSRequestID, r => r.MSRequestID) ??
                sortHelper.sort(dmc.RequestSortColumn.DataMartName, r => r.DataMartName) ??
                sortHelper.sort(dmc.RequestSortColumn.CreatedByUsername, r => r.CreatedByUsername) ??
                sortHelper.sort(dmc.RequestSortColumn.ResponseTime, r => r.ResponseTime) ??
                sortHelper.sort(dmc.RequestSortColumn.RespondedByUsername, r => r.RespondedByUsername) ??
                sortHelper.sort(dmc.RequestSortColumn.ProjectName, r => r.ProjectName) ??
                res;

            if (criteria.StartIndex.HasValue && criteria.StartIndex.Value >= 0)
                res = res.Skip(criteria.StartIndex.Value);

            if (criteria.MaxCount.HasValue && criteria.MaxCount.Value > 0)
                res = res.Take(criteria.MaxCount.Value);

            var result = new dmc.RequestList
            {
                Segment = Enumerable.Empty<dmc.RequestListRow>(),
                StartIndex = criteria.StartIndex ?? 0,
                TotalCount = totalCount,
                SortedByColumn = effectiveSortColumn,
                SortedAscending = !DefaultDescendingSort.Contains(effectiveSortColumn)
            };

            if (totalCount > 0)
            {
                result.Segment = await res
                    .Select(r => new dmc.RequestListRow
                    {
                        ID = r.ID,
                        Identifier = r.Identifier,
                        MSRequestID = r.MSRequestID,
                        AllowUnattendedProcessing = r.AllowUnattendedProcessing,
                        Name = r.Name,
                        Type = r.RequestTypeName,
                        RequestTypePackageIdentifier = r.RequestTypePackageIdentifier,
                        AdapterPackageVersion = r.AdapterPackageVersion,
                        ModelName = r.RequestTypeModelName,
                        Priority = (DTO.DataMartClient.Enums.Priorities)(int?)r.Priority,
                        DueDate = r.DueDate,
                        RoutingStatus = (int)r.Status,
                        //PMNDEV-987: Submitted time is based on the time the routing is submitted
                        Time = r.RoutingSubmittedOn,
                        DataMartID = r.DataMartID,
                        DataMartName = r.DataMartName,
                        CreatedBy = r.CreatedByUsername,
                        RespondedBy = r.RespondedByUsername,
                        ResponseTime = r.ResponseTime,
                        ProjectName = r.ProjectName,
                        Status = (DTO.DataMartClient.Enums.DMCRoutingStatus)((int)r.Status)
                    })
                    .ToListAsync();
            }

            return result;
        }       

        /// <summary>
        /// Gets the details for the specified requests.
        /// </summary>
        /// <param name="criteria"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<IEnumerable<dmc.Request>> GetRequests(DTO.DataMartClient.Criteria.RequestCriteria criteria)
        {

            if (criteria.ID == null || !criteria.ID.Any())
                return Enumerable.Empty<dmc.Request>();

            var dataMartIDs = GetGrantedDataMarts().Where(dm => criteria.DatamartID.HasValue ? dm.ID == criteria.DatamartID : true ).Select(dm => dm.ID).ToArray();

            var requests = await (from r in DataContext.Secure<Request>(Identity)
                                  let datamartID = criteria.DatamartID
                                  where criteria.ID.Contains(r.ID)
                           select new 
                           {
                               CreatedOn = r.CreatedOn,
                               Activity = r.Activity != null && r.Activity.TaskLevel == 3 && r.Activity.ParentActivityID.HasValue ? r.Activity.ParentActivity.Name : r.Activity != null && r.Activity.TaskLevel == 2 ? r.Activity.Name : "Not Selected",
                               ActivityProject = r.Activity != null && r.Activity.TaskLevel == 3 ? r.Activity.Name : "Not Selected",
                               TaskOrder = r.Activity.TaskLevel == 3 && r.Activity.ParentActivityID.HasValue && r.Activity.ParentActivity.ParentActivityID.HasValue ? r.Activity.ParentActivity.ParentActivity.Name : r.Activity != null && r.Activity.TaskLevel == 2 && r.Activity.ParentActivityID.HasValue ? r.Activity.ParentActivity.Name : r.Activity != null ? r.Activity.Name : "Not Selected",
                               SourceActivity = r.SourceActivity !=null ? r.SourceActivity.Name : "Not Selected",
                               SourceActivityProject = r.SourceActivityProject != null ? r.SourceActivityProject.Name : "Not Selected",
                               SourceTaskOrder = r.SourceTaskOrder != null ? r.SourceTaskOrder.Name : "Not Selected",
                               ActivityDescription = r.ActivityDescription,	
                               AdapterPackageVersion = r.AdapterPackageVersion,
                               AdditionalInstructions = r.AdditionalInstructions,
                               Author = new 
                               {
                                   FullName = r.CreatedBy.FirstName + " " + r.CreatedBy.LastName,
                                   OrganizationName = r.CreatedBy.Organization.Name,
                                   Username = r.CreatedBy.UserName,
                                   Email = r.CreatedBy.Email
                               },
                               Description = r.Description,
                               DueDate = r.DataMarts.Where(rdm => rdm.DueDate.HasValue && datamartID.HasValue && rdm.DataMartID == datamartID.Value).Select(rdm => rdm.DueDate).FirstOrDefault() ?? r.DueDate,
                               ID = r.ID,
                               Identifier = r.Identifier,
                               MSRequestID = r.MSRequestID,
                               IsMetadataRequest = r.RequestType.MetaData,
                               //need to use the adapter ID for the specified datamart first, then fallback to first available adapter ID
                               ModelID = r.DataMarts.Where(rdm => datamartID.HasValue && rdm.DataMartID == datamartID.Value && rdm.DataMart.AdapterID.HasValue).Select(rdm => rdm.DataMart.AdapterID).FirstOrDefault() ??  r.DataMarts.Where(rdm => rdm.DataMart.AdapterID.HasValue).Select(rdm => rdm.DataMart.AdapterID).FirstOrDefault() ?? r.RequestType.Models.Select(model => model.DataModelID).FirstOrDefault(),
                               Name = r.Name,
                               PhiDisclosureLevel = r.PhiDisclosureLevel,
                               Priority = (dmc.Enums.Priorities)(int?)r.Priority,
                               Project = new dmc.Project
                               {
                                   Name = r.Project.Name,
                                   Description = r.Project.Description,
                                   StartDate = r.Project.StartDate,
                                   EndDate = r.Project.EndDate
                               },
                               PurposeOfUse = r.PurposeOfUse,
                               RequestorCenter = r.RequesterCenter.Name,
                               RequestTypeID = r.RequestTypeID,
                               RequestTypeName = r.RequestType.Name,
                               RequestTypePackageIdentifier = r.RequestType.PackageIdentifier,
                               //legacy requests do not have a workflowID
                               //to check this, we get the value
                               WorkFlowActivityID = r.WorkFlowActivityID,
                               WorkPlanType = r.WorkplanType.Name,
                               ReportAggregationLevel = r.ReportAggregationLevel.Name,
                               Routings = (from rdm in r.DataMarts
                                     let uploadResultsPermissionID = PermissionIdentifiers.DataMartInProject.UploadResults.ID
                                     let holdRequestPermissionID = PermissionIdentifiers.DataMartInProject.HoldRequest.ID
                                     let rejectRequestPermissionID = PermissionIdentifiers.DataMartInProject.RejectRequest.ID
                                     let acls = DataContext.DataMartRights(Identity.ID, r.ProjectID, rdm.DataMartID)
                                    where dataMartIDs.Contains(rdm.DataMartID) 
                                    select new
                                   {
                                       DataMartID = rdm.DataMartID,
                                       AllowUnattendedProcessing = DataContext.DataMartAllowUnattendedProcessing(Identity.ID, r.RequestTypeID, r.ProjectID, rdm.DataMartID).Any() && DataContext.DataMartAllowUnattendedProcessing(Identity.ID, r.RequestTypeID, r.ProjectID, rdm.DataMartID).All(a => a.Permission == 2),
                                       Properties = rdm.Properties,
                                       Status = (dmc.Enums.DMCRoutingStatus)(int?)rdm.Status,
                                       canRun = acls.Where(a => a.PermissionID == uploadResultsPermissionID).Any() && acls.Where(a => a.PermissionID == uploadResultsPermissionID).All(a => a.Allowed) ? dmc.RequestRights.Run : 0,

                                       canHold = acls.Where(a => a.PermissionID == holdRequestPermissionID).Any() && acls.Where(a => a.PermissionID == holdRequestPermissionID).All(a => a.Allowed) ? dmc.RequestRights.Hold : 0,

                                       canReject = acls.Where(a => a.PermissionID == rejectRequestPermissionID).Any() && acls.Where(a => a.PermissionID == rejectRequestPermissionID).All(a => a.Allowed) ? dmc.RequestRights.Reject : 0,
                                   }),
                               Responses = r.DataMarts.Select(rdm => rdm.Responses.FirstOrDefault(response => !DataContext.Responses.Any(oReponse => oReponse.RequestDataMartID == response.RequestDataMartID && oReponse.Count > response.Count))).Select(response => new
                               {
                                   CreatedOn = response.ResponseTime ?? response.SubmittedOn,
                                   DataMartID = response.RequestDataMart.DataMartID,
                                   Email = response.RespondedBy.Email,
                                   FullName = response.RespondedBy.FirstName + " " + response.RespondedBy.LastName,
                                   OrganizationName = response.RespondedBy.Organization.Name,
                                   Username = response.RespondedBy.UserName
                               })							   
                           }).ToArrayAsync();

            
            var requestDocuments = from req in DataContext.Secure<Request>(Identity)
                                   join reqdm in DataContext.RequestDataMarts on req.ID equals reqdm.RequestID
                                   join res in DataContext.Responses on reqdm.ID equals res.RequestDataMartID
                                   join reqDoc in DataContext.RequestDocuments on res.ID equals reqDoc.ResponseID
                                   where criteria.ID.Contains(req.ID)
                                       && reqDoc.DocumentType == DTO.Enums.RequestDocumentType.Input
                                       && dataMartIDs.Contains(reqdm.DataMartID)
                                       && res.Count == reqdm.Responses.Max(r => r.Count)
                                   select reqDoc.RevisionSetID;


            IEnumerable<dmc.DocumentWithID> docs = await DataContext.Documents.Where(doc => requestDocuments.Contains(doc.RevisionSetID.Value) &&
                DataContext.Documents.Where(d => d.RevisionSetID == doc.RevisionSetID)
                .OrderByDescending(o => o.MajorVersion)
                .ThenByDescending(o => o.MinorVersion)
                .ThenByDescending(o => o.BuildVersion)
                .ThenByDescending(o => o.RevisionVersion)
                .FirstOrDefault() == doc
                 ).Union(DataContext.Documents.Where(dx => criteria.ID.Contains(dx.ItemID))).Select(doc => new dmc.DocumentWithID
                 {
                     ID = doc.ID,
                     Document = new dmc.Document
                     {
                         IsViewable = doc.Viewable,
                         Kind = doc.Kind,
                         MimeType = doc.MimeType,
                         Name = doc.FileName,
                         Size = doc.Length
                     }
                 }).ToArrayAsync();


            var results = (from r in requests
                           select new dmc.Request
                           {
                               Activity = r.Activity,
                               ActivityDescription = r.ActivityDescription,
                               ActivityProject = r.ActivityProject,
                               AdapterPackageVersion = r.AdapterPackageVersion,
                               AdditionalInstructions = r.AdditionalInstructions,
                               Author = new dmc.Profile
                               {
                                   Email = r.Author.Email,
                                   FullName = r.Author.FullName,
                                   OrganizationName = r.Author.OrganizationName,
                                   Username = r.Author.Username
                               },
                               CreatedOn = r.CreatedOn,
                               Description = r.WorkFlowActivityID.HasValue ? r.Description : FormatRequestDescription(r.Description),    //edit in line breaks for legacy requests
                               Documents = docs.ToArray(),
                              DueDate = r.DueDate,
                              ID = r.ID,
                              Identifier = r.Identifier,
                              MSRequestID = r.MSRequestID,
                              IsMetadataRequest = r.IsMetadataRequest,
                              ModelID = r.ModelID,
                              Name = r.Name,
                              PhiDisclosureLevel = r.PhiDisclosureLevel,
                              Priority = r.Priority,
                              Project = r.Project,
                              PurposeOfUse = TranslatePurposeOfUse(r.PurposeOfUse),
                              RequestorCenter = r.RequestorCenter,
                              RequestTypeID = r.RequestTypeID,
                              RequestTypeName = r.RequestTypeName,
                              RequestTypePackageIdentifier = r.RequestTypePackageIdentifier,
                              Responses = r.Responses.Select(response => new dmc.Response
                              {
                                  Author = new dmc.Profile
                                  {
                                      Email = response.Email,
                                      FullName = response.FullName,
                                      OrganizationName = response.OrganizationName,
                                      Username = response.Username
                                  },
                                  CreatedOn = response.CreatedOn,
                                  DataMartID = response.DataMartID
                              }).ToArray(),
                              Routings = r.Routings.Select(routing => new dmc.RequestRouting
                              {
                                  AllowUnattendedProcessing = routing.AllowUnattendedProcessing,
                                  DataMartID = routing.DataMartID,
                                  Rights = routing.canHold | routing.canReject | routing.canRun,
                                  Status = routing.Status,
                                  Properties = routing.Properties == null ? null : (
                                            from root in ParseXml(routing.Properties)
                                            from e in root.Elements()
                                            let key = (string)e.Attribute("Key")
                                            where !string.IsNullOrEmpty(key)
                                            select new dmc.RoutingProperty { Name = key, Value = e.Value }
                                        ).ToArray()
                              }).ToArray(),
                              //KT changes
                              SourceActivity = r.SourceActivity,
                              SourceActivityProject = r.SourceActivityProject,
                              SourceTaskOrder = r.SourceTaskOrder,
                              //end KT changes
                              TaskOrder = r.TaskOrder,
                              WorkPlanType = r.WorkPlanType,
                              ReportAggregationLevel = r.ReportAggregationLevel,
                          }).ToArray();

            return results;
        }

        private string FormatRequestDescription(string input)
        {
            if (string.IsNullOrEmpty(input))
                return string.Empty;
            return input.Replace(Environment.NewLine, "<br/>");
        }

        string TranslatePurposeOfUse(string value)
        {
            switch (value)
            {
                case "CLINTRCH":
                    return "Clinical Trial Research";
                case "HMARKT":
                    return "Healthcare Marketing";
                case "HOPERAT":
                    return "Healthcare Operations";
                case "HPAYMT":
                    return "Healthcare Payment";
                case "HRESCH":
                    return "Healthcare Research";
                case "OBSRCH":
                    return "Observational Research";
                case "PATRQT":
                    return "Patient Requested";
                case "PTR":
                    return "Prep-to-Research";
                case "PUBHLTH":
                    return "Public Health";
                case "QA":
                    return "Quality Assurance";
                case "TREAT":
                    return "Treatment";
            }
            return value;
        }

        /// <summary>
        /// Gets a chunck of the specified document.
        /// </summary>
        /// <param name="ID"></param>
        /// <param name="offset"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> GetDocumentChunk(Guid ID, int offset, int size)
        {
            var document = await DataContext.Documents.Where(d => d.ID == ID).Select(d => new { d.ID, d.Length }).FirstOrDefaultAsync();
            if (document == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Document not found for the specified ID.");
            }

            HttpResponseMessage response = this.Request != null ? this.Request.CreateResponse(HttpStatusCode.OK) :  new HttpResponseMessage(HttpStatusCode.OK);
            if (offset < document.Length)
            {
                byte[] buffer = new byte[Math.Min(size, Convert.ToInt32(document.Length) - offset)];
                using (var stream = new Lpp.Dns.Data.Documents.DocumentStream(DataContext, ID))
                {
                    int result = await stream.ReadAsync(buffer, offset, buffer.Length);
                }
                response.Content = new ByteArrayContent(buffer);
                response.Content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");
                response.Content.Headers.ContentRange = new System.Net.Http.Headers.ContentRangeHeaderValue(offset, offset + buffer.Length);
                response.Content.Headers.ContentLength = buffer.Length;
            }

            return response;
        }

        /// <summary>
        /// Creates/saves new response documents, document content is posted in PostResponseDocumentChunk().
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<Guid[]> PostResponseDocuments(dmc.Criteria.PostResponseDocumentsData data)
        {
            bool canUpload = await CheckUploadPermission(data.RequestID, data.DataMartID);
            if (canUpload == false)
            {
                throw new HttpResponseException(this.Request.CreateErrorResponse(HttpStatusCode.Forbidden, "Not authorizad to upload results."));
            }

            Response response = await DataContext.Responses
                                                 .Where(rsp => rsp.RequestDataMart.DataMartID == data.DataMartID && rsp.RequestDataMart.RequestID == data.RequestID)
                                                 .OrderByDescending(rsp => rsp.Count)
                                                 .FirstOrDefaultAsync();

            if (response == null)
            {
                RequestDataMart datamart = await DataContext.RequestDataMarts.FirstOrDefaultAsync(dm => dm.DataMartID == data.DataMartID && dm.RequestID == data.RequestID);
                if (datamart == null)
                {
                    throw new HttpResponseException(this.Request.CreateErrorResponse(HttpStatusCode.NotFound, "Unable to determine the routing for the response."));
                }

                //create the response
                response = datamart.AddResponse(GetCurrentIdentity().ID);
                response.SubmittedOn = datamart.RequestTime ?? DateTime.Now;
            }

            //As Per PMNDEV-4303: Previous documents are not wiped but versioned.
            //The DMC is responsible for restricting re-upload of results for Request Types other than Modular Program and File Distribution.
            //DataContext.Documents.RemoveRange(DataContext.Documents.Where(d => d.ItemID == response.ID));
            var requestWorkflowID = await DataContext.Requests.Where(r => r.ID == data.RequestID).Select(x => x.WorkFlowActivityID).FirstOrDefaultAsync();
            Guid[] documentIDs = {};
            String[] documentNames = (data.Documents ?? Enumerable.Empty<dmc.Document>()).Select(d => d.Name).ToArray();
            if (DataContext.Documents.Any(d => d.ItemID == response.ID && documentNames.Contains(d.FileName)))
            {
                //Get existing documents with revision 
                var existingDocuments = DataContext.Documents.Where(d => d.ItemID == response.ID 
                    && documentNames.Contains(d.FileName)).Select(d => new { d.FileName, d.RevisionVersion, d.ID, d.RevisionSetID });

                //As Per PMNDEV-4303: We need to version the documents that already exist in the database.

                //Add documents that don't need to be versioned here first.
                var newDocuments = (data.Documents ?? Enumerable.Empty<dmc.Document>()).Where(d => existingDocuments.Any(ed => ed.FileName == d.Name) == false).Select(d => new Document
                {
                    ItemID = response.ID,
                    FileName = d.Name,
                    Name = d.Name,
                    ParentDocumentID = null,
                    MimeType = d.MimeType,
                    Length = d.Size,
                    Viewable = d.IsViewable,
                    Kind = d.Kind,
                    RevisionSetID = Guid.NewGuid(),
                    Description = string.Empty,
                    UploadedByID = Identity.ID
                }).ToArray();

                List<RequestDocument> newRequestDocuments = new List<RequestDocument>();

                if (requestWorkflowID.HasValue)
                {
                    foreach (var doc in newDocuments)
                        newRequestDocuments.Add(new RequestDocument { ResponseID = doc.ItemID, RevisionSetID = doc.RevisionSetID.Value, DocumentType = DTO.Enums.RequestDocumentType.Output }); 
                }

                //Now add the ones that need to be versioned.
                var revisionedDocuments = (data.Documents ?? Enumerable.Empty<dmc.Document>()).Where(d => existingDocuments.Any(ed => ed.FileName == d.Name)).Select(d => new Document
                {
                    ItemID = response.ID,
                    FileName = d.Name,
                    Name = d.Name,
                    ParentDocumentID = existingDocuments.Where(ed => ed.FileName == d.Name).OrderByDescending(ed => ed.RevisionVersion).Select(ed => ed.ID).First(),
                    MimeType = d.MimeType,
                    Length = d.Size,
                    Viewable = d.IsViewable,
                    Kind = d.Kind,
                    //Set the RevisionSetID to the first version's ID.
                    RevisionSetID = existingDocuments.Where(ed => ed.FileName == d.Name && ed.RevisionVersion == 0).Select(ed => ed.RevisionSetID).First(),
                    Description = string.Empty,
                    UploadedByID = Identity.ID,
                    RevisionVersion = existingDocuments.Where(ed => ed.FileName == d.Name).OrderByDescending(ed => ed.RevisionVersion).Select(ed => ed.RevisionVersion + 1).First()
                }).ToArray();

                if (requestWorkflowID.HasValue)
                {
                    foreach (var doc in revisionedDocuments)
                        newRequestDocuments.Add(new RequestDocument { ResponseID = doc.ItemID, RevisionSetID = doc.RevisionSetID.Value, DocumentType = DTO.Enums.RequestDocumentType.Output }); 
                }

                DataContext.Documents.AddRange(newDocuments);
                DataContext.Documents.AddRange(revisionedDocuments);
                if (requestWorkflowID.HasValue)
                {
                    DataContext.RequestDocuments.AddRange(newRequestDocuments); 
                }
                var ids = newDocuments.Select(d => d.ID).ToList();
                ids.AddRange(revisionedDocuments.Select(d => d.ID).ToList());

                documentIDs = ids.ToArray();
            }
            else
            {
                //save add the new documents
                var newDocuments = (data.Documents ?? Enumerable.Empty<dmc.Document>()).Select(d => new Document
                {
                    ItemID = response.ID,
                    FileName = d.Name,
                    Name = d.Name,
                    ParentDocumentID = null,
                    MimeType = d.MimeType,
                    Length = d.Size,
                    Viewable = d.IsViewable,
                    Kind = d.Kind,
                    RevisionSetID = Guid.NewGuid(),
                    Description = string.Empty,
                    UploadedByID = Identity.ID
                }).ToArray();
                DataContext.Documents.AddRange(newDocuments);
                

                if (requestWorkflowID.HasValue)
                {
                    List<RequestDocument> newRequestDocuments = new List<RequestDocument>();
                    foreach (var doc in newDocuments)
                        newRequestDocuments.Add(new RequestDocument { ResponseID = doc.ItemID, RevisionSetID = doc.RevisionSetID.Value, DocumentType = DTO.Enums.RequestDocumentType.Output });
                    DataContext.RequestDocuments.AddRange(newRequestDocuments);
                }
                 
                
                
                documentIDs = newDocuments.Select(d => d.ID).ToArray();
            }

            DataContext.SaveChanges();

            return documentIDs;
        }
        
        /// <summary>
        /// Saves the actual document content for the document specified.
        /// </summary>
        /// <param name="documentID"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> PostResponseDocumentChunk([FromUri]Guid documentID, [RawBody]IEnumerable<byte> data)
        {            
            
            var details = await (from d in DataContext.Documents
                                 let requestDataMart = DataContext.Responses.Where(r => r.ID == d.ItemID).Select(r => r.RequestDataMart).FirstOrDefault()
                                 let processModularProgramSearchTerms = (
                                    from rt in DataContext.RequestTypes
                                    //make sure the request type has modular program term
                                    where (rt.Terms.Any(t => t.TermID == ModularProgramTermID) || rt.Models.Any(m => m.DataModelID == ModularModelID))
                                    //make sure the request for the document is associated to the request type
                                    && requestDataMart.Request.RequestTypeID == rt.ID
                                    //make sure the terms have not been processed for the request yet
                                    && !requestDataMart.Request.SearchTerms.Any()
                                    select rt
                                 ).Any()
                                 where d.ID == documentID 
                                 select new
                                 {
                                     Document = d,
                                     RequestID = requestDataMart.RequestID,
                                     DataMartID = requestDataMart.DataMartID,
                                     ProcessModularProgramSearchTerms = processModularProgramSearchTerms
                                 }
                                    ).FirstOrDefaultAsync();

            if (details == null)
            {
                return this.Request.CreateErrorResponse(HttpStatusCode.NotFound, "Document not found.");
            }

            bool canUpload = await CheckUploadPermission(details.RequestID, details.DataMartID);
            if (!canUpload)
            {
                return this.Request.CreateErrorResponse(HttpStatusCode.Forbidden, "Not authorized to upload results.");
            }

            using (var documentStream = new Lpp.Dns.Data.Documents.DocumentStream(DataContext, documentID))
            {
                using (var ms = new System.IO.MemoryStream())
                {
                    if (documentStream.Length > 0)
                    {
                        await documentStream.CopyToAsync(ms);
                    }                    

                    var b = data.ToArray();
                    await ms.WriteAsync(b, 0, b.Length);

                    ms.Position = 0;

                    await documentStream.WriteStreamAsync(ms);

                    if (details.ProcessModularProgramSearchTerms && ms.Length > 0)
                    {
                        try
                        {
                            ModularProgramResponsePostProcessor postProcessor = new ModularProgramResponsePostProcessor(DataContext);

                            using (var contentStream = new System.IO.MemoryStream(ms.ToArray()))
                            {
                                await postProcessor.ExecuteAsync(details.RequestID, details.Document, contentStream);
                            }
                        }
                        catch 
                        { 
                            //ignore if it fails, do not cause error to upload.
                        }
                    }                    
                }
            }

            return this.Request != null ? this.Request.CreateResponse(HttpStatusCode.OK) :  new HttpResponseMessage(HttpStatusCode.OK);
        }

        /// <summary>
        /// Sets the status of the specified request.
        /// </summary>
        /// <param name="data"></param>
        /// <returns></returns>
        [HttpPut]
        public async Task<HttpResponseMessage> SetRequestStatus(dmc.Criteria.SetRequestStatusData data)
        {
            var permission = data.Status == DTO.DataMartClient.Enums.DMCRoutingStatus.Hold ? PermissionIdentifiers.DataMartInProject.HoldRequest :
                                data.Status == DTO.DataMartClient.Enums.DMCRoutingStatus.RequestRejected ? PermissionIdentifiers.DataMartInProject.RejectRequest :
                                PermissionIdentifiers.DataMartInProject.UploadResults;

            bool hasPermission = await CheckPermission(data.RequestID, data.DataMartID, permission, GetCurrentIdentity());
            if (hasPermission == false)
            {
                string message = data.Status == DTO.DataMartClient.Enums.DMCRoutingStatus.Hold ? "You do not have permission to change the status of this request to Hold" :
                                data.Status == DTO.DataMartClient.Enums.DMCRoutingStatus.RequestRejected ? "You do not have permission to change the status of this request to Rejected" :
                                "You do not have permission to upload results.";
                return this.Request.CreateErrorResponse(HttpStatusCode.Forbidden, message);
            }

            var routing = await DataContext.RequestDataMarts.Include("Request").SingleOrDefaultAsync(dm => dm.DataMartID == data.DataMartID && dm.RequestID == data.RequestID);
            if (routing == null)
            {
                return this.Request.CreateErrorResponse(HttpStatusCode.NotFound, "Unable to determine the routing information based on the specified Request ID and DataMart ID.");
            }

            var originalRequestStatus = routing.Request.Status;
            var originalStatus = routing.Status;

            //PMNDEV-4303 - Change status to ResultsModified is previously uploaded.
            if (originalStatus == DTO.Enums.RoutingStatus.Completed)
                routing.Status = DTO.Enums.RoutingStatus.ResultsModified;

            //We should only update the routing status if it is not already complete or modified.
            if(originalStatus != DTO.Enums.RoutingStatus.Completed && originalStatus != DTO.Enums.RoutingStatus.ResultsModified)
                routing.Status = (Lpp.Dns.DTO.Enums.RoutingStatus)((int)data.Status);

            //updating the UpdatedOn property of the routing so that logs will get processed and will allow for status change notification to go out if further uploads are done while status is ResultsModified.
            routing.UpdatedOn = DateTime.UtcNow;

            if (routing.Status == DTO.Enums.RoutingStatus.AwaitingResponseApproval)
            {
                //TODO: should be checking against the request creator identity no the the current identity
                hasPermission = await CheckHasSkipApprovalPermission(data.RequestID, data.DataMartID);
                if (hasPermission)
                {
                    routing.Status = DTO.Enums.RoutingStatus.Completed;
                }
            }

            routing.Properties = data.Properties == null ? null :
                "<P>" + string.Join("",
                    from p in data.Properties
                    where !string.IsNullOrEmpty(p.Name)
                    select string.Format("<V Key=\"{0}\">{1}</V>", p.Name, p.Value)) +
                "</P>";

            var currentResponse = await DataContext.RequestDataMarts.Where(dm => dm.ID == routing.ID).SelectMany(dm => dm.Responses).OrderByDescending(r => r.Count).FirstOrDefaultAsync();

            currentResponse.ResponseMessage =   data.Message;

            //only set the response time and ID if the response is completed
            var completeStatuses = new[] {
                Lpp.Dns.DTO.Enums.RoutingStatus.Completed,
                Lpp.Dns.DTO.Enums.RoutingStatus.ResultsModified,
                Lpp.Dns.DTO.Enums.RoutingStatus.RequestRejected,
                Lpp.Dns.DTO.Enums.RoutingStatus.ResponseRejectedBeforeUpload,
                Lpp.Dns.DTO.Enums.RoutingStatus.ResponseRejectedAfterUpload,
                Lpp.Dns.DTO.Enums.RoutingStatus.AwaitingResponseApproval
            };

            if (completeStatuses.Contains(routing.Status))
            {
                currentResponse.ResponseTime = DateTime.UtcNow;
                currentResponse.RespondedByID = GetCurrentIdentity().ID;
            }

            await DataContext.SaveChangesAsync();

            if(completeStatuses.Contains(routing.Status))
            {
                await DataContext.Entry(routing.Request).ReloadAsync();
                if(routing.Request.Status == DTO.Enums.RequestStatuses.Complete)
                {
                    //send the request status complete notification
                    var request = routing.Request;

                    var requestStatusLogger = new Dns.Data.RequestLogConfiguration();
                    string[] emailText = await requestStatusLogger.GenerateRequestStatusChangedEmailContent(DataContext, request.ID, GetCurrentIdentity().ID, originalRequestStatus, request.Status);                    
                    var logItems = requestStatusLogger.GenerateRequestStatusEvents(DataContext, GetCurrentIdentity(), false, originalRequestStatus, request.Status, request.ID, emailText[1], emailText[0], "Request Status Changed");

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
            }


            try
            {
                Logger.Error("Attepmting to loop Response");
                Logger.Error("route is: " + routing.RoutingType);
                //if this is a CNDS routing communicate the routing status change to CNDS
                if (routing.RoutingType == DTO.Enums.RoutingType.SourceCNDS || routing.RoutingType == DTO.Enums.RoutingType.ExternalCNDS)
                {
                    System.Web.Hosting.HostingEnvironment.QueueBackgroundWorkItem(async cancellationToken =>
                    {
                        using (var helper = new Lpp.CNDS.ApiClient.NetworkRequestDispatcher())
                        {
                            Logger.Error("status is: " + routing.Status);
                            if (routing.Status == DTO.Enums.RoutingStatus.Completed || routing.Status == DTO.Enums.RoutingStatus.ResultsModified)
                            {
                                Logger.Error("attempting to Post Response doc");
                                //notify CNDS to sync the response output documents
                                await helper.PostResponseDocuments(currentResponse.ID);
                            }
                            Logger.Error("attempting to Update status");
                            //update the status of the route in the source request
                            await helper.UpdateSourceRoutingStatus(new[] { new DTO.CNDSUpdateRoutingStatusDTO { ResponseID = currentResponse.ID, Message = currentResponse.ResponseMessage, RoutingStatus = routing.Status } });
                        }
                    });
                }
            }
            catch (Exception ex)
            {
                Logger.Error(ex);
                throw;
            }

            return this.Request != null ? this.Request.CreateResponse(HttpStatusCode.OK) : new HttpResponseMessage(HttpStatusCode.OK);
        }
        
        IQueryable<DataMart> GetGrantedDataMarts()
        {
            var identity = GetCurrentIdentity();
            return DataContext.Secure<DataMart>(identity, PermissionIdentifiers.DataMartInProject.SeeRequests).Where(dm => dm.Deleted == false && dm.DataMartTypeID != DataMarts.DataMartsController.CNDSImportedDataMartTypeID && DataContext.Users.Any(u => u.ID == identity.ID && u.Active && !u.Deleted));
        }

        async Task<bool> CheckUploadPermission(Guid requestID, Guid datamartID)
        {
            return await CheckPermission(requestID, datamartID, PermissionIdentifiers.DataMartInProject.UploadResults, GetCurrentIdentity());
        }

        async Task<bool> CheckHasSkipApprovalPermission(Guid requestID, Guid datamartID)
        {
            var i = DataContext.Requests.Where(r => r.ID == requestID).Select(r => new { ID = r.CreatedBy.ID, r.CreatedBy.UserName, Name = (r.CreatedBy.FirstName + " " + r.CreatedBy.LastName).Trim(), r.CreatedBy.OrganizationID }).Single();

            return await CheckPermission(requestID, datamartID, PermissionIdentifiers.DataMartInProject.SkipResponseApproval, new Utilities.Security.ApiIdentity(i.ID, i.UserName, i.Name, i.OrganizationID));
        }

        async Task<bool> CheckPermission(Guid requestID, Guid datamartID, PermissionDefinition permission, Utilities.Security.ApiIdentity identity)
        {
            var filter = new ExtendedQuery
            {
                DataMarts = a => a.DataMartID == datamartID && a.DataMart.Requests.Any(r => r.RequestID == requestID),
                Projects = a => a.Project.Requests.Any(r => r.ID == requestID) && a.Project.DataMarts.Any(dm => dm.DataMartID == datamartID && dm.DataMart.Requests.Any(r => r.RequestID == requestID)),
                ProjectDataMarts = a => a.DataMartID == datamartID && a.Project.Requests.Any(r => r.ID == requestID) && a.DataMart.Requests.Any(r => r.RequestID == requestID),
                Organizations = a => a.Organization.DataMarts.Any(dm => dm.ID == datamartID && dm.Requests.Any(dr => dr.RequestID == requestID))
            };

            var permissions = await DataContext.HasGrantedPermissions<Request>(identity, requestID, filter, permission);

            return permissions.Any();
        }

        static readonly ISet<dmc.RequestSortColumn> DefaultDescendingSort = new HashSet<dmc.RequestSortColumn>(new[] { 
            dmc.RequestSortColumn.RequestTime, 
            dmc.RequestSortColumn.RequestPriority 
        });

        class SortHelper<T>
        {
            public dmc.RequestSortColumn Actual { get; set; }
            public IQueryable<T> Source { get; set; }
            public bool EffectiveAscending { get; set; }

            public IOrderedQueryable<T> sort<U>(dmc.RequestSortColumn expected, Expression<Func<T, U>> sortExpression)
            {
                if (Actual != expected) return null;
                return EffectiveAscending ? Source.OrderBy(sortExpression) : Source.OrderByDescending(sortExpression);
            }
        }

        static SortHelper<T> SortIf<T>(IQueryable<T> source, dmc.RequestSortColumn actual, bool? ascending)
        {
            return new SortHelper<T> { Actual = actual, EffectiveAscending = ascending ?? !DefaultDescendingSort.Contains(actual), Source = source };
        }

        static IEnumerable<XElement> ParseXml(string value)
        {
            try
            {
                return new[] { XElement.Parse(value) };
            }
            catch
            {
                return Enumerable.Empty<XElement>();
            }
        }

    }
}
