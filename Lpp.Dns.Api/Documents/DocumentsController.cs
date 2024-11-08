﻿using Lpp.Dns.Data;
using Lpp.Dns.DTO;
using Lpp.Dns.DTO.Security;
using Lpp.Utilities;
using Lpp.Utilities.Security;
using Lpp.Utilities.WebSites.Controllers;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security;
using System.Threading.Tasks;
using System.Web.Http;

namespace Lpp.Dns.Api.Documents
{
    /// <summary>
    /// Document specific endpoint.
    /// </summary>
    public class DocumentsController : LppApiController<Lpp.Dns.Data.DataContext>
    {
        /// <summary>
        /// Gets documents for the specified tasks.
        /// </summary>
        /// <param name="tasks">The tasks.</param>
        /// <returns></returns>
        [HttpGet]
        public IEnumerable<Lpp.Dns.DTO.ExtendedDocumentDTO> ByTask([FromUri]IEnumerable<Guid> tasks, [FromUri]IEnumerable<DTO.Enums.TaskItemTypes> filterByTaskItemType = null)
        {
            var baseAcls = DataContext.ProjectRequestTypeWorkflowActivities.FilterAcl(Identity, PermissionIdentifiers.ProjectRequestTypeWorkflowActivities.ViewDocuments);
            IEnumerable<Guid> baseA = baseAcls.Where(a => a.Allowed).Select(a => a.WorkflowActivityID);

           var acls = from reference in DataContext.ActionReferences
                       join request in DataContext.Requests.Where(r => r.WorkFlowActivityID.HasValue).Select(r => new { r.ID, WorkflowActivityID = r.WorkFlowActivityID.Value, r.ProjectID, r.RequestTypeID }) on reference.ItemID equals request.ID
                       join acl in baseAcls on new { request.ProjectID, request.RequestTypeID, request.WorkflowActivityID } equals new { acl.ProjectID, acl.RequestTypeID, WorkflowActivityID = acl.WorkflowActivityID }

                       where reference.Type == DTO.Enums.TaskItemTypes.Request 
                       && tasks.Contains(reference.TaskID)
                        && baseA.Contains(reference.Task.WorkflowActivityID.Value)
                       select new { TaskID = reference.Task.ID, request.ID, acl.PermissionID, acl.SecurityGroupID, acl.Allowed };


            var docs = (from d in DataContext.Documents
                        let taskReference = DataContext.ActionReferences.Where(tr => tr.ItemID == d.ID).DefaultIfEmpty()
                        let security = acls.Where(a => d.ItemID == a.TaskID)
                        where security.Any() && security.All(a => a.Allowed)
                        orderby d.ItemID descending, d.RevisionSetID descending, d.CreatedOn descending
                        select new ExtendedDocumentDTO
                        {
                            ID = d.ID,
                            Name = d.Name,
                            FileName = d.FileName,
                            MimeType = d.MimeType,
                            Description = d.Description,
                            Viewable = d.Viewable,
                            ItemID = d.ItemID,
                            ItemTitle = DataContext.Actions.Where(t => t.ID == d.ItemID).Select(t => t.WorkflowActivityID.HasValue ? t.WorkflowActivity.Name : t.Subject).FirstOrDefault(),
                            Kind = d.Kind,
                            Length = d.Length,
                            CreatedOn = d.CreatedOn,
                            ParentDocumentID = d.ParentDocumentID,
                            RevisionDescription = d.RevisionDescription,
                            RevisionSetID = d.RevisionSetID,
                            MajorVersion = d.MajorVersion,
                            MinorVersion = d.MinorVersion,
                            BuildVersion = d.BuildVersion,
                            RevisionVersion = d.RevisionVersion,
                            Timestamp = d.Timestamp,
                            UploadedByID = d.UploadedByID,
                            UploadedBy = DataContext.Users.Where(u => u.ID == d.UploadedByID).Select(u => u.UserName).FirstOrDefault(),
                            TaskItemType = taskReference.Select(tr => (DTO.Enums.TaskItemTypes?)tr.Type).FirstOrDefault()
                        }).Distinct();

            if (filterByTaskItemType != null && filterByTaskItemType.Any())
            {
                docs = docs.Where(d => d.TaskItemType.HasValue && filterByTaskItemType.Contains(d.TaskItemType.Value));
            }

            return docs;
        }

        /// <summary>
        /// Returns the most current document for each specified revision set.
        /// </summary>
        /// <param name="revisionSets">The collection of revision set IDs to get the current documents for.</param>
        /// <returns></returns>
        [HttpGet]
        public IEnumerable<Lpp.Dns.DTO.ExtendedDocumentDTO> ByRevisionID([FromUri]IEnumerable<Guid> revisionSets)
        {
            if (revisionSets == null)
                revisionSets = Enumerable.Empty<Guid>();

            var docs = from d in DataContext.Documents.AsNoTracking()
                       join x in (
                           DataContext.Documents.Where(dd => revisionSets.Contains(dd.RevisionSetID.Value))
                           .GroupBy(k => k.RevisionSetID)
                           .Select(k => k.OrderByDescending(d => d.MajorVersion).ThenByDescending(d => d.MinorVersion).ThenByDescending(d => d.BuildVersion).ThenByDescending(d => d.RevisionVersion).Select(y => y.ID).FirstOrDefault())
                       ) on d.ID equals x
                       orderby d.ItemID descending, d.RevisionSetID descending, d.CreatedOn descending
                       select new ExtendedDocumentDTO
                       {
                           ID = d.ID,
                           Name = d.Name,
                           FileName = d.FileName,
                           MimeType = d.MimeType,
                           Description = d.Description,
                           Viewable = d.Viewable,
                           ItemID = d.ItemID,
                           ItemTitle = DataContext.Actions.Where(t => t.ID == d.ItemID).Select(t => t.WorkflowActivityID.HasValue ? t.WorkflowActivity.Name : t.Subject).FirstOrDefault(),
                           Kind = d.Kind,
                           Length = d.Length,
                           CreatedOn = d.CreatedOn,
                           ParentDocumentID = d.ParentDocumentID,
                           RevisionDescription = d.RevisionDescription,
                           RevisionSetID = d.RevisionSetID,
                           MajorVersion = d.MajorVersion,
                           MinorVersion = d.MinorVersion,
                           BuildVersion = d.BuildVersion,
                           RevisionVersion = d.RevisionVersion,
                           Timestamp = d.Timestamp,
                           UploadedByID = d.UploadedByID,
                           UploadedBy = DataContext.Users.Where(u => u.ID == d.UploadedByID).Select(u => u.UserName).FirstOrDefault()
                       };

            return docs;
        }        

        /// <summary>
        /// Gets the documents for the specified response.
        /// </summary>
        /// <param name="ID">The ID of the response.</param>
        /// <returns></returns>
        [HttpGet]
        public IEnumerable<Dns.DTO.ExtendedDocumentDTO> ByResponse([FromUri] IEnumerable<Guid> ID)
        {
            var docs = DataContext.Documents
                .Where(d => ID.Contains(d.ItemID))
                .OrderByDescending(d => d.ItemID).ThenByDescending(d => d.RevisionSetID).ThenByDescending(d => d.CreatedOn)
                .Select(d => new ExtendedDocumentDTO
                {
                    ID = d.ID,
                    Name = d.Name,
                    FileName = d.FileName,
                    MimeType = d.MimeType,
                    Description = d.Description,
                    Viewable = d.Viewable,
                    ItemID = d.ItemID,
                    ItemTitle = DataContext.Actions.Where(t => t.ID == d.ItemID).Select(t => t.WorkflowActivityID.HasValue ? t.WorkflowActivity.Name : t.Subject).FirstOrDefault(),
                    Kind = d.Kind,
                    Length = d.Length,
                    CreatedOn = d.CreatedOn,
                    ParentDocumentID = d.ParentDocumentID,
                    RevisionDescription = d.RevisionDescription,
                    RevisionSetID = d.RevisionSetID,
                    MajorVersion = d.MajorVersion,
                    MinorVersion = d.MinorVersion,
                    BuildVersion = d.BuildVersion,
                    RevisionVersion = d.RevisionVersion,
                    Timestamp = d.Timestamp,
                    UploadedByID = d.UploadedByID,
                    UploadedBy = DataContext.Users.Where(u => u.ID == d.UploadedByID).Select(u => u.UserName).FirstOrDefault()
                });

            return docs;
        }

        /// <summary>
        /// Gets documents for a request that are not specific to a task.
        /// </summary>
        /// <param name="requestID">The ID of the request.</param>
        /// <returns></returns>
        [HttpGet, ActionName("GeneralRequestDocuments")]
        public IQueryable<Lpp.Dns.DTO.ExtendedDocumentDTO> GeneralRequestDocuments(Guid requestID)
        {
            var docs = (from d in DataContext.Documents where d.ItemID == requestID orderby d.RevisionSetID descending, d.CreatedOn descending select d).Map<Document, ExtendedDocumentDTO>();

            return docs;
        }

        /// <summary>
        /// Streams the content of the specified document, content is not specified as an attachment.
        /// </summary>
        /// <param name="id">The ID of the document.</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> Read(Guid id)
        {
            //TODO:implement security for viewing the content
            Document document = await DataContext.Documents.AsNoTracking().SingleOrDefaultAsync(d => d.ID == id);

            if (document == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Document not found.");
            }

            var content = new StreamContent(document.GetStream(DataContext));
            content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue(document.MimeType);
            content.Headers.ContentLength = document.Length;

            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = content
            };
        }

        /// <summary>
        /// Downloads a specific document.
        /// </summary>
        /// <param name="id">The ID of the document.</param>
        /// <returns></returns>
        [HttpGet]
        public async Task<HttpResponseMessage> Download(Guid id)
        {
            //TODO: implement security for downloading document, use Secure for the select
            Document document = await DataContext.Documents.AsNoTracking().SingleOrDefaultAsync(d => d.ID == id);

            if (document == null)
            {
                return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Document not found.");
            }

            var content = new StreamContent(document.GetStream(DataContext));
            //using application/octet-stream forces the browser to download rather than try to open if supports document mime type.
            content.Headers.ContentType = new System.Net.Http.Headers.MediaTypeHeaderValue("application/octet-stream");            
            content.Headers.ContentLength = document.Length;
            content.Headers.ContentDisposition = new System.Net.Http.Headers.ContentDispositionHeaderValue("attachment")
            {
                FileName = document.FileName,
                Size = document.Length
            };

            return new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = content
            };
        }

        /// <summary>
        /// Upload a document.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> Upload()
        {
            if (!Request.Content.IsMimeMultipartContent())
            {
                return Request.CreateErrorResponse(HttpStatusCode.UnsupportedMediaType, "Content must be mime multipart.");
            }  

            Guid taskID = Guid.Empty;
            Guid requestID = Guid.Empty;
            Stream stream = null;
            string documentName = string.Empty;
            string description = string.Empty;
            string filename = string.Empty;
            string comments = string.Empty;
            Guid? parentDocumentID = null;
            DTO.Enums.TaskItemTypes? taskItemType = null;

            var provider = new MultipartMemoryStreamProvider();
            var o = await Request.Content.ReadAsMultipartAsync(provider);
            foreach (var c in o.Contents)
            {
                string parameterName = c.Headers.ContentDisposition.Name.Replace("\"", "");
                switch (parameterName)
                {
                    case "requestID":
                        Guid.TryParse(await c.ReadAsStringAsync(), out requestID);
                        break;
                    case "taskID":
                        Guid.TryParse(await c.ReadAsStringAsync(), out taskID);
                        break;
                    case "taskItemType":
                        DTO.Enums.TaskItemTypes itemType;
                        if (Enum.TryParse<DTO.Enums.TaskItemTypes>(await c.ReadAsStringAsync(), out itemType))
                        {
                            taskItemType = itemType;
                        }
                        break;
                    case "comments":
                        comments = await c.ReadAsStringAsync();
                        break;
                    case "files":
                        filename = Path.GetFileName(c.Headers.ContentDisposition.FileName.Replace("\"", ""));
                        stream = await c.ReadAsStreamAsync();
                        break;
                    case "parentDocumentID":
                        Guid parentID;
                        if (Guid.TryParse(await c.ReadAsStringAsync(), out parentID))
                        {
                            parentDocumentID = parentID;
                        }
                        break;
                    case "description":
                        description = await c.ReadAsStringAsync();
                        break;
                    case "documentName":
                        documentName = await c.ReadAsStringAsync();
                        break;
                }
            }

            if (taskID == Guid.Empty && requestID == Guid.Empty)
            {
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Unable to determine the documents owning object ID.");
            }

            if (string.IsNullOrEmpty(filename))
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Filename is missing.");

            if (requestID == Guid.Empty)
            {
                //Get the requestID based on the task.
                requestID = await DataContext.ActionReferences.Where(tr => tr.TaskID == taskID && tr.Type == DTO.Enums.TaskItemTypes.Request).Select(tr => tr.ItemID).FirstOrDefaultAsync();
            }

            //TODO: check for upload permission


            var document = new Document { 
                Description = description,
                Name = string.IsNullOrEmpty(documentName) ? filename : documentName,
                FileName = filename,
                MimeType = Lpp.Utilities.FileEx.GetMimeTypeByExtension(filename),
                ItemID = taskID == Guid.Empty ? requestID : taskID,
                Length = stream.Length,               
                RevisionDescription = comments,
                UploadedByID = Identity.ID,
                ParentDocumentID = parentDocumentID
            };

            if (document.ParentDocumentID.HasValue)
            {
                var versionQuery = from d in DataContext.Documents
                               let revisionID = DataContext.Documents.Where(p => p.ID == parentDocumentID).Select(p => p.RevisionSetID).FirstOrDefault()
                               let taskReference = DataContext.ActionReferences.Where(tr => tr.ItemID == d.ID).DefaultIfEmpty()
                               where d.RevisionSetID == revisionID
                               orderby d.MajorVersion descending, d.MinorVersion descending, d.BuildVersion descending, d.RevisionVersion descending
                               select new
                               {
                                   d.ItemID,
                                   d.RevisionSetID,
                                   d.MajorVersion,
                                   d.MinorVersion,
                                   d.BuildVersion,
                                   d.RevisionVersion,
                                   TaskItemType = taskReference.Select(tr => (DTO.Enums.TaskItemTypes?)tr.Type).FirstOrDefault()
                               };
                var version = taskID != Guid.Empty ? await versionQuery.Where(d => d.ItemID == taskID).FirstOrDefaultAsync() : await versionQuery.Where(d => d.ItemID == requestID).FirstOrDefaultAsync();

                if (version != null)
                {
                    document.RevisionSetID = version.RevisionSetID;
                    document.MajorVersion = version.MajorVersion;
                    document.MinorVersion = version.MinorVersion;
                    document.BuildVersion = version.BuildVersion;
                    document.RevisionVersion = version.RevisionVersion + 1;

                    //if the task item type has not been specified for the upload but the parent document had it specified, inhertit the type.
                    if (taskItemType == null && version.TaskItemType.HasValue)
                    {
                        taskItemType = version.TaskItemType.Value;
                    }
                }

            }

            if(!document.RevisionSetID.HasValue)
                document.RevisionSetID = document.ID;

            DataContext.Documents.Add(document);

            if (taskItemType.HasValue && taskID != Guid.Empty)
            {
                DataContext.ActionReferences.Add(new TaskReference
                {
                    TaskID = taskID,
                    ItemID = document.ID,
                    Type = taskItemType.Value
                });
            }
            
            await DataContext.SaveChangesAsync();

            using (var dbStream = new Dns.Data.Documents.DocumentStream(DataContext, document.ID))
            {
                await stream.CopyToAsync(dbStream);
            }

            if (!string.IsNullOrWhiteSpace(comments))
            {
                //create a comment associated to the request
                var comment = DataContext.Comments.Add(new Comment
                {
                    CreatedByID = Identity.ID,
                    CreatedOn = DateTime.UtcNow,
                    Text = comments,
                    ItemID = requestID
                });

                //create the comment reference to the document
                DataContext.CommentReferences.Add(new CommentReference
                {
                    ItemID = document.ID,
                    ItemTitle = document.FileName,
                    CommentID = comment.ID,
                    Type = DTO.Enums.CommentItemTypes.Document
                });

                if (taskID != Guid.Empty)
                {
                    //create the comment reference to the task
                    DataContext.CommentReferences.Add(new CommentReference
                    {
                        ItemID = taskID,
                        CommentID = comment.ID,
                        Type = DTO.Enums.CommentItemTypes.Task
                    });
                }

                await DataContext.SaveChangesAsync();
            }           

            return Request.CreateResponse(HttpStatusCode.Created, new DTO.ExtendedDocumentDTO {
                ID = document.ID,
                Name = document.Name,
                FileName = document.FileName,
                MimeType = document.MimeType,
                Description = document.Description,
                Viewable = document.Viewable,
                ItemID = document.ItemID,
                ItemTitle = DataContext.Actions.Where(t => t.ID == taskID).Select(t => t.WorkflowActivityID.HasValue ? t.WorkflowActivity.Name : t.Subject).FirstOrDefault(),
                Kind = document.Kind,
                Length = document.Length,
                CreatedOn = document.CreatedOn,
                ParentDocumentID = document.ParentDocumentID,
                RevisionDescription = document.RevisionDescription,
                RevisionSetID = document.RevisionSetID,
                MajorVersion = document.MajorVersion,
                MinorVersion = document.MinorVersion,
                BuildVersion = document.BuildVersion,
                RevisionVersion = document.RevisionVersion,
                Timestamp = document.Timestamp,
                UploadedByID = document.UploadedByID,
                UploadedBy = Identity.UserName   
            });
        }

        /// <summary>
        /// Upload a response document.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        public async Task<HttpResponseMessage> UploadResponseOutput()
        {
            if (!Request.Content.IsMimeMultipartContent())
            {
                return Request.CreateErrorResponse(HttpStatusCode.UnsupportedMediaType, "Content must be mime multipart.");
            }

            Guid responseID = Guid.Empty;
            Guid documentID = Guid.Empty;
            Guid revisionSetID = Guid.Empty;
            Guid uploadedByID = Guid.Empty;
            Stream stream = null;
            string documentName = string.Empty;
            string description = string.Empty;
            string filename = string.Empty;
            Guid? parentDocumentID = null;
            string documentKind = null;

            var provider = new MultipartMemoryStreamProvider();
            var o = await Request.Content.ReadAsMultipartAsync(provider);
            foreach (var c in o.Contents)
            {
                string parameterName = c.Headers.ContentDisposition.Name.Replace("\"", "");
                switch (parameterName)
                {
                    case "responseID":
                        Guid.TryParse(await c.ReadAsStringAsync(), out responseID);
                        break;
                    case "id":
                        Guid.TryParse(await c.ReadAsStringAsync(), out documentID);
                        break;
                    case "revisionSetID":
                        Guid.TryParse(await c.ReadAsStringAsync(), out revisionSetID);
                        break;
                    case "files":
                        //filename = Path.GetFileName(c.Headers.ContentDisposition.FileName.Replace("\"", ""));
                        stream = await c.ReadAsStreamAsync();
                        break;
                    case "parentDocumentID":
                        Guid parentID;
                        if (Guid.TryParse(await c.ReadAsStringAsync(), out parentID))
                        {
                            parentDocumentID = parentID;
                        }
                        break;
                    case "description":
                        description = await c.ReadAsStringAsync();
                        break;
                    case "documentName":
                        documentName = await c.ReadAsStringAsync();
                        break;
                    case "uploadedByID":
                        Guid.TryParse(await c.ReadAsStringAsync(), out uploadedByID);
                        break;
                    case "kind":
                        documentKind = await c.ReadAsStringAsync();
                        break;
                }
            }


            if(responseID == Guid.Empty || !(await DataContext.Responses.AnyAsync(rsp => rsp.ID == responseID)))
            {
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.NotFound, "Unable to determine the response to associate the document to."));
            }

            if (string.IsNullOrEmpty(filename) && string.IsNullOrEmpty(documentName))
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Filename is missing.");

            Document document = new Document {
                ID = documentID,
                ItemID = responseID,
                Name = string.IsNullOrEmpty(documentName) ? filename : documentName,
                FileName = string.IsNullOrEmpty(documentName) ? filename : documentName,
                MimeType = string.IsNullOrEmpty(documentName) ? Lpp.Utilities.FileEx.GetMimeTypeByExtension(filename) : Lpp.Utilities.FileEx.GetMimeTypeByExtension(documentName),
                Length = stream.Length,
                Description = description,
                ParentDocumentID = parentDocumentID,
                UploadedByID = uploadedByID,
                Kind = documentKind
            };

            if (document.ParentDocumentID.HasValue)
            {
                var versionQuery = from d in DataContext.Documents
                                   let revisionID = DataContext.Documents.Where(p => p.ID == parentDocumentID).Select(p => p.RevisionSetID).FirstOrDefault()
                                   where d.RevisionSetID == revisionID && d.ItemID == responseID
                                   orderby d.MajorVersion descending, d.MinorVersion descending, d.BuildVersion descending, d.RevisionVersion descending
                                   select new
                                   {
                                       d.ItemID,
                                       d.RevisionSetID,
                                       d.MajorVersion,
                                       d.MinorVersion,
                                       d.BuildVersion,
                                       d.RevisionVersion
                                   };

                var version = await versionQuery.FirstOrDefaultAsync();

                if (version != null)
                {
                    document.RevisionSetID = version.RevisionSetID;
                    document.MajorVersion = version.MajorVersion;
                    document.MinorVersion = version.MinorVersion;
                    document.BuildVersion = version.BuildVersion;
                    document.RevisionVersion = version.RevisionVersion + 1;
                }

            }

            if (!document.RevisionSetID.HasValue)
                document.RevisionSetID = document.ID;

            DataContext.Documents.Add(document);

            if ((await DataContext.RequestDataMarts.Where(rdm => rdm.Responses.Any(rsp => rsp.ID == responseID)).Select(rdm => rdm.Request.WorkFlowActivityID).FirstOrDefaultAsync()).HasValue)
            {
                DataContext.RequestDocuments.Add(new RequestDocument { ResponseID = responseID, RevisionSetID = document.RevisionSetID.Value, DocumentType = DTO.Enums.RequestDocumentType.Output });
            }

            await DataContext.SaveChangesAsync();

            using (var dbStream = new Dns.Data.Documents.DocumentStream(DataContext, document.ID))
            {
                await stream.CopyToAsync(dbStream);
            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }

        /// <summary>
        /// Delete the specified documents.
        /// </summary>
        /// <param name="id">The ID's of the documents to delete.</param>
        /// <returns></returns>
        [HttpDelete]
        public async Task Delete([FromUri] IEnumerable<Guid> id)
        {
            try
            {
                

                //TODO: check for delete permission

                //if (!await DataContext.CanDelete<DataContext, Document, PermissionDefinition>(Identity, id.ToArray()))
                //    throw new SecurityException("We're sorry but you do not have permission to delete one or more of these items.");


                var taskReferences = (from tr in DataContext.ActionReferences where id.Contains(tr.ItemID) select tr);
                DataContext.Set<TaskReference>().RemoveRange(taskReferences);

                var commentReferences = (from cr in DataContext.CommentReferences where id.Contains(cr.ItemID) select cr);
                DataContext.Set<CommentReference>().RemoveRange(commentReferences);

                var dbSet = DataContext.Set<Document>();
                var objs = (from o in dbSet where id.Contains(o.ID) select o);

                foreach (var obj in objs)
                {
                    dbSet.Remove(obj);
                }

                

                await DataContext.SaveChangesAsync();
            }
            catch (System.Security.SecurityException se)
            {
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.Forbidden, se));
            }
            catch (DbUpdateException dbe)
            {
                Exception exception = dbe;
                while (exception.InnerException != null)
                    exception = exception.InnerException;

                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, exception));
            }
            catch (Exception e)
            {
                throw new HttpResponseException(Request.CreateErrorResponse(HttpStatusCode.BadRequest, e));
            }
        }

    }
}
