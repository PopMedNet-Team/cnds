﻿using Lpp.Dns.Data;
using Lpp.Dns.DTO;
using Lpp.Utilities.WebSites.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using Lpp.Utilities;
using System.Threading.Tasks;
using System.Data.Entity;
using Lpp.Dns.DTO.Security;

namespace Lpp.Dns.Api.Projects
{
    /// <summary>
    /// Controller that services the Projects
    /// </summary>
    public class ProjectsController : LppApiDataController<Project, ProjectDTO, DataContext, PermissionDefinition>
    {
        static readonly log4net.ILog Logger = log4net.LogManager.GetLogger(typeof(ProjectsController));

        /// <summary>
        /// Returns a specific Project by ID
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        [HttpGet]
        public override async System.Threading.Tasks.Task<ProjectDTO> Get(Guid ID)
        {
            return await base.Get(ID);
        }

        /// <summary>
        /// Returns a List of Projects filtered using OData
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public override IQueryable<ProjectDTO> List()
        {
            return base.List().Where(l => !l.Deleted);
        }

        
        /// <summary>
        /// Returns a list of projects that have viewable requests for the current user
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<ProjectDTO> ProjectsWithRequests()
        {
            var projects = (from p in DataContext.Secure<Project>(Identity) join r in DataContext.Secure<Request>(Identity) on p.ID equals r.ProjectID where !p.Deleted select p).Distinct().Map<Project, ProjectDTO>();

            return projects;
        }

        /// <summary>
        /// Returns the activities available for a given project with level structure.
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IEnumerable<ActivityDTO>> GetActivityTreeByProjectID(Guid projectID)
        {
            try
            {
                var results = await (from a in DataContext.Activities.AsNoTracking()
                                     where a.ProjectID == projectID
                                     orderby a.DisplayOrder, a.Name
                                     select a).ToArrayAsync();

                return  results.Where(a => a.TaskLevel == 1).Select(a => new ActivityDTO
                {
                    ID = a.ID,
                    Name = a.Name,
                    ParentActivityID = a.ParentActivityID,
                    Deleted = a.Deleted,
                    TaskLevel = a.TaskLevel,
                    Activities = results.Where(a2 => a2.ParentActivityID == a.ID).Select(a2 => new ActivityDTO
                    {
                        ID = a2.ID,
                        Name = a2.Name,
                        ParentActivityID = a2.ParentActivityID,
                        Deleted = a2.Deleted,
                        TaskLevel = a2.TaskLevel,
                        Activities = results.Where(a3 => a3.ParentActivityID == a2.ID).Select(a3 => new ActivityDTO
                        {
                            ID = a3.ID,
                            Name = a3.Name,
                            Activities = new ActivityDTO[] { },
                            ParentActivityID = a3.ParentActivityID,
                            Deleted = a3.Deleted,
                            TaskLevel = a3.TaskLevel
                        })
                    })
                }).AsEnumerable();
            }
            catch (Exception ex)
            {
                System.Diagnostics.Debug.Write(ex);
                throw ex;
            }
        }


        /// <summary>
        /// Returns the projects that the current user can create a request against
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<ProjectDTO> RequestableProjects()
        {
            var results = from p in DataContext.Secure<Project>(Identity, PermissionIdentifiers.Request.Edit)
                          where
                              p.Active && !p.Deleted && (!p.EndDate.HasValue || p.EndDate.Value > DateTime.UtcNow) && (p.StartDate <= DateTime.UtcNow)
                          select p;
            return results.Map<Project, ProjectDTO>();
        }
        /// <summary>
        /// Returns request types associated with project that the user has permission to manage.
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IQueryable<RequestTypeDTO>> GetRequestTypes(Guid projectID)
        {
            //var prtAcls = DataContext.ProjectRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);
            //var pdmrt = DataContext.ProjectDataMartRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);

            if (!await DataContext.HasPermissions<Project>(Identity, projectID, PermissionIdentifiers.Project.ManageRequestTypes))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to manage request types."));


            var result = from prt in DataContext.ProjectRequestTypes
                         join p in DataContext.Secure<Project>(Identity, PermissionIdentifiers.Project.ManageRequestTypes) on prt.ProjectID equals p.ID
                         where p.ID == projectID
                         select prt.RequestType;

            return result.Map<RequestType, RequestTypeDTO>();



            //var result = from prt in DataContext.ProjectRequestTypes 
            //             where prt.ProjectID == projectID 
            //             && (
            //                   (prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0)) 
            //                || (pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0))
            //                ) 
            //             select prt.RequestType;

            //return result.Distinct().Map<RequestType, RequestTypeDTO>();
        }


        /// <summary>
        /// Gets all of the request types that are available for the given project that support the specified datamodel.
        /// </summary>
        /// <param name="projectID">The project the request type is associated with.</param>
        /// <param name="dataModelID">The datamodel that the request type must support.</param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<RequestTypeDTO> GetRequestTypesByModel(Guid projectID, Guid dataModelID)
        {
            var prtAcls = DataContext.ProjectRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);
            var pdmrt = DataContext.ProjectDataMartRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);


            var result = from prt in DataContext.ProjectRequestTypes 
                         where prt.ProjectID == projectID && 
                         (
                            (prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0)) 
                            || 
                            (pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0))
                         ) 
                         && prt.RequestType.Models.Any(m => m.DataModelID == dataModelID) 
                         select prt.RequestType;

            return result.Distinct().Map<RequestType, RequestTypeDTO>();
        }

        /// <summary>
        /// Gets all the request types that are available for the given project, regardless of supported datamodel.
        /// </summary>
        /// <param name="projectID">The project the request type is associated with.</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IQueryable<RequestTypeDTO>> GetAvailableRequestTypeForNewRequest(Guid projectID)
        {
            if (!await DataContext.HasPermissions<Project>(Identity, projectID, PermissionIdentifiers.Request.Edit))
                return null;
            
            //For legacy request types, the user has to have the automatic or manual permission for the request type, which can be set at two levels within the Project (Project level or Project DataMart level)
            var projectDatamartAcls = DataContext.ProjectDataMartRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);
            var projectAcls = DataContext.ProjectRequestTypeAcls.FilterRequestTypeAcl(Identity.ID);

            //For WF request types, the user has to have the "Edit Task" permission on the "New Request" activity for the workflow
            var wfAcls = DataContext.ProjectRequestTypeWorkflowActivities.Where(p => p.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) &&
                                                                                   p.ProjectID == projectID &&
                                                                                   p.PermissionID == PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.EditTask.ID );

            var results = from rt in DataContext.ProjectRequestTypes
                       let wAcls = wfAcls.Where(a => a.RequestTypeID == rt.RequestTypeID && a.WorkflowActivity.Start == true)
                       let pAcls = projectAcls.Where(pa => pa.ProjectID == projectID && pa.RequestTypeID == rt.RequestTypeID)
                       let pdmAcls = projectDatamartAcls.Where(pa => pa.ProjectID == projectID && pa.RequestTypeID == rt.RequestTypeID)
                       where rt.ProjectID == projectID
                       && (
                            (rt.RequestType.WorkflowID.HasValue && wAcls.Any(a => a.Allowed) && wAcls.All(a => a.Allowed))
                            ||
                            (rt.RequestType.WorkflowID.HasValue == false && 
                            (pAcls.Any(a => a.Permission > 0) || pdmAcls.Any(a => a.Permission > 0)) &&
                            (pAcls.All(a => a.Permission > 0) && pdmAcls.All(a => a.Permission > 0)))
                       )
                       select rt.RequestType;

            return results.Map<RequestType, RequestTypeDTO>();

            
        }

        /// <summary>
        /// Gets the available data models from which to pick a request type to create a new request.
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        [HttpGet]
        public IQueryable<DataModelWithRequestTypesDTO> GetDataModelsByProject(Guid projectID)
        {
            var prtAcls = DataContext.ProjectRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);
            var pdmrt = DataContext.ProjectDataMartRequestTypeAcls.Where(a => a.SecurityGroup.Users.Any(u => u.UserID == Identity.ID) && a.ProjectID == projectID);

            var results = (from prt in DataContext.ProjectRequestTypes where prt.ProjectID == projectID && ((prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && prtAcls.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0)) || (pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).Any() && pdmrt.Where(a => a.RequestTypeID == prt.RequestTypeID).All(a => a.Permission > 0))) select prt.RequestType)
                .SelectMany(rt => rt.Models)
                .Select(m => new DataModelWithRequestTypesDTO
                {
                    Description = m.DataModel.Description,
                    ID = m.DataModelID,
                    Name = m.DataModel.Name,
                    RequestTypes = (from rt in m.DataModel.RequestTypes
                                    where ((prtAcls.Where(a => a.RequestTypeID == rt.RequestTypeID).Any() && prtAcls.Where(a => a.RequestTypeID == rt.RequestTypeID).All(a => a.Permission > 0)) || (pdmrt.Where(a => a.RequestTypeID == rt.RequestTypeID).Any() && pdmrt.Where(a => a.RequestTypeID == rt.RequestTypeID).All(a => a.Permission > 0)))
                                    select new RequestTypeDTO
                                    {
                                        AddFiles = rt.RequestType.AddFiles,
                                        Description = rt.RequestType.Description,
                                        ID = rt.RequestTypeID,
                                        Metadata = rt.RequestType.MetaData,
                                        Name = rt.RequestType.Name,
                                        PostProcess = rt.RequestType.PostProcess,
                                        RequiresProcessing = rt.RequestType.RequiresProcessing,
                                        Template = rt.RequestType.Template.Name,
                                        TemplateID = rt.RequestType.TemplateID,
                                        Timestamp = rt.RequestType.Timestamp,
                                        Workflow = rt.RequestType.Workflow.Name,
                                        WorkflowID = rt.RequestType.WorkflowID
                                    }),
                    RequiresConfiguration = m.DataModel.RequiresConfiguration,
                    Timestamp = m.DataModel.Timestamp
                });

            return results.ToArray().DistinctBy(r => r.ID).AsQueryable();
        }

        /// <summary>
        /// Gets the available request types for the project that the user has permission to manage.
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IQueryable<ProjectRequestTypeDTO>> GetProjectRequestTypes(Guid projectID)
        {
            if (!await DataContext.HasPermissions<Project>(Identity, projectID, PermissionIdentifiers.Project.ManageRequestTypes))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to manage request types."));


            var result = from prt in DataContext.ProjectRequestTypes 
                         join p in DataContext.Secure<Project>(Identity, PermissionIdentifiers.Project.ManageRequestTypes) on prt.ProjectID equals p.ID 
                         where p.ID == projectID select prt;

            return result.Map<ProjectRequestType, ProjectRequestTypeDTO>();
        }

        /// <summary>
        /// Updates the available request types for the project
        /// </summary>
        /// <param name="requestTypes"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UpdateProjectRequestTypes(UpdateProjectRequestTypesDTO requestTypes)
        {
            if (requestTypes == null)
                return Request.CreateResponse(HttpStatusCode.Accepted);

            var projectAclFilter = DataContext.ProjectAcls.FilterAcl(Identity, PermissionIdentifiers.Project.ManageRequestTypes);

            var globalAclFilter = DataContext.GlobalAcls.FilterAcl(Identity, PermissionIdentifiers.Project.ManageRequestTypes);

            var hasPermission = await (from p in DataContext.Secure<Project>(Identity)
                              let pacl = projectAclFilter.Where(a => a.ProjectID == p.ID)
                              let gacl = globalAclFilter
                              where p.ID == requestTypes.ProjectID
                              && (pacl.Any(a => a.Allowed) || gacl.Any(a => a.Allowed)) && (pacl.All(a => a.Allowed) && gacl.All(a => a.Allowed))
                              select p).AnyAsync();

            if (!hasPermission)
            {
                return Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to manage one or more Request Types associated with the permissions passed.");
            }

            var _dbRequestTypes = await (from prt in DataContext.ProjectRequestTypes.Include(i => i.RequestType) where prt.ProjectID == requestTypes.ProjectID select prt).ToArrayAsync();

            var requestTypeIDs = requestTypes.RequestTypes.Select(rt => rt.RequestTypeID).Distinct().ToArray();
            //Remove including security permissions
            var removeRequestTypes = _dbRequestTypes.Where(rt => !requestTypeIDs.Contains(rt.RequestTypeID) ).ToArray();
            var removeRequestTypeIDs = removeRequestTypes.Select(rt => rt.RequestTypeID).ToArray();
            
            var aclProjectRequestTypes = await (from a in DataContext.ProjectRequestTypeAcls where a.ProjectID == requestTypes.ProjectID && removeRequestTypeIDs.Contains(a.RequestTypeID) select a).ToArrayAsync();
            DataContext.ProjectRequestTypeAcls.RemoveRange(aclProjectRequestTypes);

            var aclProjectDataMartRequestTypes = await (from a in DataContext.ProjectDataMartRequestTypeAcls where a.ProjectID == requestTypes.ProjectID && removeRequestTypeIDs.Contains(a.RequestTypeID) select a).ToArrayAsync();
            DataContext.ProjectDataMartRequestTypeAcls.RemoveRange(aclProjectDataMartRequestTypes);

            DataContext.ProjectRequestTypes.RemoveRange(removeRequestTypes);
            
            //Now add all of the ones that aren't in there.
            foreach(var prt in requestTypes.RequestTypes.Where(rt => !_dbRequestTypes.Any(prt => prt.RequestTypeID == rt.RequestTypeID))) {

                DataContext.ProjectRequestTypes.Add(new ProjectRequestType {
                    ProjectID = prt.ProjectID,
                    RequestTypeID = prt.RequestTypeID
                });
            }

            await DataContext.SaveChangesAsync();


            return Request.CreateResponse(HttpStatusCode.Accepted);
        }

        /// <summary>
        /// Copies the specified project and returns the ID of the new project.
        /// </summary>
        /// <param name="projectID"></param>
        /// <returns></returns>
        [HttpGet]
        public async Task<Guid> Copy(Guid projectID)
        {
            var existing = await (from p in DataContext.Projects.Include(x => x.DataMarts) where p.ID == projectID select p).SingleOrDefaultAsync();

            if (existing == null)
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.NotFound, "The Project could not be found."));

            if (!await DataContext.HasPermissions<Project>(Identity, existing.ID, PermissionIdentifiers.Project.Copy))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to copy the specified project."));

            string newAcronym = "New " + existing.Acronym;
            string newName = "New " + existing.Name;

            while (await (from p in DataContext.Projects where !p.Deleted && (p.Name == newName && p.Acronym == newAcronym) select p).AnyAsync())
            {
                newAcronym = "New " + newAcronym;
                newName = "New " + newName;
            }

            var project = new Project
            {
                Acronym = newAcronym,
                StartDate = DateTime.Today,
                Name = newName,
                GroupID = null,
                Description = existing.Description,
                Active = true
            };

            DataContext.Projects.Add(project);

            //Security Groups
            var existingSecurityGroups = await (from sg in DataContext.SecurityGroups.Include(x => x.Users) where sg.OwnerID == existing.ID select sg).ToArrayAsync();
            var SecurityGroupMap = new Dictionary<Guid, Guid>();
            foreach(var existingSecurityGroup in existingSecurityGroups) {

                var sg = new SecurityGroup
                {
                    Kind = existingSecurityGroup.Kind,
                    Name = "New " + existingSecurityGroup.Name,
                    OwnerID = project.ID,
                    Type = DTO.Enums.SecurityGroupTypes.Project
                };
                DataContext.SecurityGroups.Add(sg);

                SecurityGroupMap.Add(existingSecurityGroup.ID, sg.ID);

                foreach (var existingUser in existingSecurityGroup.Users)
                {
                    DataContext.SecurityGroupUsers.Add(new SecurityGroupUser
                    {
                        Overridden = existingUser.Overridden,
                        SecurityGroupID = sg.ID,
                        UserID = existingUser.UserID
                    });
                }
            }

            //Data Marts
            foreach (var existingDataMart in existing.DataMarts)
            {
                var dm = new ProjectDataMart
                {
                    DataMartID = existingDataMart.DataMartID,
                    ProjectID = project.ID
                };

                DataContext.ProjectDataMarts.Add(dm);
            }

            //Project Acls
            var existingProjectAcls = await (from a in DataContext.ProjectAcls where a.ProjectID == existing.ID select a).ToArrayAsync();
            foreach (var existingProjectAcl in existingProjectAcls)
            {
                DataContext.ProjectAcls.Add(new AclProject
                {
                    Allowed = existingProjectAcl.Allowed,
                    Overridden = existingProjectAcl.Overridden,
                    PermissionID = existingProjectAcl.PermissionID,
                    ProjectID = project.ID,
                    SecurityGroupID = SecurityGroupMap.ContainsKey(existingProjectAcl.SecurityGroupID) ? SecurityGroupMap[existingProjectAcl.SecurityGroupID] : existingProjectAcl.SecurityGroupID
                });
            }

            //Project Event Acls
            var existingProjectEventAcls = await (from a in DataContext.ProjectEvents where a.ProjectID == existing.ID select a).ToArrayAsync();
            foreach (var existingProjectEventAcl in existingProjectEventAcls)
            {
                DataContext.ProjectEvents.Add(new ProjectEvent
                {
                    Allowed = existingProjectEventAcl.Allowed,
                    Overridden = existingProjectEventAcl.Overridden,
                    ProjectID = project.ID,
                    EventID = existingProjectEventAcl.EventID,
                    SecurityGroupID = SecurityGroupMap.ContainsKey(existingProjectEventAcl.SecurityGroupID) ? SecurityGroupMap[existingProjectEventAcl.SecurityGroupID] : existingProjectEventAcl.SecurityGroupID
                });
            }

            //Project DataMart Acls
            var existingProjectDataMartAcls = await (from a in DataContext.ProjectDataMartAcls where a.ProjectID == existing.ID select a).ToArrayAsync();
            foreach (var existingProjectDataMartAcl in existingProjectDataMartAcls)
            {
                DataContext.ProjectDataMartAcls.Add(new AclProjectDataMart
                {
                    Allowed = existingProjectDataMartAcl.Allowed,
                    Overridden = existingProjectDataMartAcl.Overridden,
                    PermissionID = existingProjectDataMartAcl.PermissionID,
                    ProjectID = project.ID,
                    DataMartID = existingProjectDataMartAcl.DataMartID,
                    SecurityGroupID = SecurityGroupMap.ContainsKey(existingProjectDataMartAcl.SecurityGroupID) ? SecurityGroupMap[existingProjectDataMartAcl.SecurityGroupID] : existingProjectDataMartAcl.SecurityGroupID
                });
            }


            //Project DataMart Event Acls
            //TODO -Jamie

            //Project DataMart Request Type Acls
            var existingProjectDataMartRequestTypeAcls = await (from a in DataContext.ProjectDataMartRequestTypeAcls where a.ProjectID == existing.ID select a).ToArrayAsync();
            foreach (var existingProjectDataMartRequestTypeAcl in existingProjectDataMartRequestTypeAcls)
            {
                DataContext.ProjectDataMartRequestTypeAcls.Add(new AclProjectDataMartRequestType
                {
                    Permission = existingProjectDataMartRequestTypeAcl.Permission,
                    Overridden = existingProjectDataMartRequestTypeAcl.Overridden,
                    ProjectID = project.ID,
                    RequestTypeID = existingProjectDataMartRequestTypeAcl.RequestTypeID,
                    DataMartID = existingProjectDataMartRequestTypeAcl.DataMartID,
                    SecurityGroupID = SecurityGroupMap.ContainsKey(existingProjectDataMartRequestTypeAcl.SecurityGroupID) ? SecurityGroupMap[existingProjectDataMartRequestTypeAcl.SecurityGroupID] : existingProjectDataMartRequestTypeAcl.SecurityGroupID
                });
            }
            
            await DataContext.SaveChangesAsync();

            return project.ID;
        }

        /// <summary>
        /// Flags the project as deleted.
        /// </summary>
        /// <param name="ID"></param>
        /// <returns></returns>
        [HttpDelete]
        public override async Task Delete([FromUri] IEnumerable<Guid> ID)
        {
            if (!await DataContext.CanDelete<Project>(Identity, ID.ToArray()))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, "You do not have permission to delete this project."));

            var projects = await (from p in DataContext.Projects where ID.Contains(p.ID) select p).ToArrayAsync();
            foreach (var project in projects)
                project.Deleted = true;

            await DataContext.SaveChangesAsync();
        }
        /// <summary>
        /// Insert project values
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
        [HttpPost]
        public override async System.Threading.Tasks.Task<System.Collections.Generic.IEnumerable<Lpp.Dns.DTO.ProjectDTO>> Insert(System.Collections.Generic.IEnumerable<Lpp.Dns.DTO.ProjectDTO> values)
        {
            await CheckForDuplicates(values);
            return await base.Insert(values);
        }
        /// <summary>
        /// insert or update project values
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
        [HttpPost]
        public override async Task<IEnumerable<ProjectDTO>> InsertOrUpdate(IEnumerable<ProjectDTO> values)
        {
            await CheckForDuplicates(values);
            return await base.InsertOrUpdate(values);
        }
        /// <summary>
        /// returns project values
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
        [HttpPut]
        public override async Task<IEnumerable<ProjectDTO>> Update(IEnumerable<ProjectDTO> values)
        {
            await CheckForDuplicates(values);
            return await base.Update(values);
        }

        private async Task CheckForDuplicates(IEnumerable<ProjectDTO> updates)
        {
            var ids = updates.Where(u => u.ID.HasValue).Select(u => u.ID.Value).ToArray();
            var names = updates.Select(u => u.Name).ToArray();
            var acronyms = updates.Where(u => u.Acronym != null && u.Acronym != "").Select(u => u.Acronym).ToArray();

            if (updates.GroupBy(u => u.Acronym).Any(u => u.Count() > 1))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, "The Acronym of Projects must be unique."));

            if (updates.GroupBy(u => u.Name).Any(u => u.Count() > 1))
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, "The Name of Projects must be unique."));

            if (await (from p in DataContext.Projects where !p.Deleted && !ids.Contains(p.ID) && (names.Contains(p.Name) || acronyms.Contains(p.Acronym)) select p).AnyAsync())
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, "The Name and Acronym of Projects must be unique."));
        }

        /// <summary>
        /// Updates the specified projects activies from an external service.
        /// </summary>
        /// <param name="ID">The ID of the project to update.</param>
        /// <param name="username">The username of the user executing the request.</param>
        /// <param name="password">The password of the user executing the request.</param>
        /// <returns></returns>
        [HttpGet, AllowAnonymous]
        public async Task<HttpResponseMessage> UpdateActivities(Guid ID, string username, string password)
        {
            if (string.IsNullOrEmpty(username) || string.IsNullOrEmpty(password))
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Username and password are required.");

            string hashedPassword = Password.ComputeHash(password);
            Guid? userID = await DataContext.Users.Where(u => u.UserName == username && u.PasswordHash == hashedPassword && u.Active && !u.Deleted).Select(u => (Guid?)u.ID).FirstOrDefaultAsync();

            if (!userID.HasValue)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Invalid credentials.");
            }

            string serviceUrl = System.Web.Configuration.WebConfigurationManager.AppSettings["Activities.Url"];
            string serviceUser = (System.Web.Configuration.WebConfigurationManager.AppSettings["Activities.Import.User"] ?? string.Empty).DecryptString();
            string servicePassword = (System.Web.Configuration.WebConfigurationManager.AppSettings["Activities.Import.Password"] ?? string.Empty).DecryptString();

            if (string.IsNullOrEmpty(serviceUrl) || string.IsNullOrEmpty(serviceUser) || string.IsNullOrEmpty(servicePassword))
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "External service configuration is incomplete, make sure the service url and credentials have been configured correctly.");
            }

            var updater = new ProjectActivitiesUpdater(DataContext, serviceUrl, serviceUser, servicePassword);
            
            if (!await updater.CanUpdate(userID.Value, ID))
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Unable to determine project, confirm that the specified project ID is correct for an Active project and that the user has permission to Update Activities for the project.");
            }

            await updater.DoUpdate(ID);

            if (updater.StatusCode != HttpStatusCode.OK)
            {
                return Request.CreateErrorResponse(updater.StatusCode, updater.StatusMessage);
            }

            //return ok for status if update was successful.
            return Request.CreateResponse(HttpStatusCode.OK);
        }

        /// <summary>
        /// Get the field options for the specified project.
        /// </summary>
        /// <param name="projectID">The ID of the project.</param>
        /// <param name="userID">The User of the request</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<IQueryable<BaseFieldOptionAclDTO>> GetFieldOptions(Guid projectID, Guid userID)
        {
            var globalOptions = await DataContext.GlobalFieldOptionAcls.ToDictionaryAsync(o => o.FieldIdentifier.ToUpper(), p => p.Permission);

            var securityGroups = DataContext.SecurityGroupUsers.Where(u => u.UserID == userID).Select(s => s.SecurityGroupID).ToArray();

            var projectOptions = await DataContext.ProjectFieldOptionAcls.Where(o => o.ProjectID == projectID && o.Permission != DTO.Enums.FieldOptionPermissions.Inherit && securityGroups.Contains(o.SecurityGroupID)).ToArrayAsync();

            List<BaseFieldOptionAclDTO> options = new List<BaseFieldOptionAclDTO>();
            foreach (string key in FieldOptionIdentifiers.AllFieldOptionKeys)
            {
                DTO.Enums.FieldOptionPermissions permission = DTO.Enums.FieldOptionPermissions.Optional;

                DTO.Enums.FieldOptionPermissions value;
                if (globalOptions.TryGetValue(key.ToUpper(), out value))
                {
                    permission = value;
                }

                var projectOptionTest = projectOptions.Where(po => po.FieldIdentifier.ToUpper() == key.ToUpper()).FirstOrDefault();

                if (projectOptionTest != null)
                {
                    permission = projectOptionTest.Permission;
                }

                var opt = new BaseFieldOptionAclDTO { FieldIdentifier = key, Overridden = true, Permission = permission };
                options.Add(opt);
            }

            return options.AsQueryable();
        }

    }
}
