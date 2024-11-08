﻿/// <reference path="../../../../../js/requests/details.ts" />

module Workflow.Common.ListRoutings {
    export var vm: ViewModel;
    interface IExpandedResponseDTO extends Dns.Interfaces.IResponseDTO {
        Name: string;
    }
    export class VirtualRoutingViewModel {
        public ID: any;
        public Name: string = '';
        public IsGroup: boolean = false;
        public ResponseTime: Date;
        public Status: Dns.Enums.RoutingStatus = Dns.Enums.RoutingStatus.AwaitingResponseApproval;
        public Messages: string = '';
        public Routings: Dns.Interfaces.IRequestDataMartDTO[];
        public Children: KnockoutObservableArray<IExpandedResponseDTO>;
        

        constructor(routing: Dns.Interfaces.IRequestDataMartDTO, group: Dns.Interfaces.IResponseGroupDTO, responses?: Dns.Interfaces.IResponseDTO[]) {
            this.Routings = [];
            this.Routings.push(routing);
            this.Children = ko.observableArray([]);
            this.IsGroup = group != null;
            if (this.IsGroup) {
                this.ID = group.ID;
                this.Name = group.Name;
            } else {
                this.ID = routing.ResponseID;
                this.Name = routing.DataMart;
            }
            
            this.ResponseTime = routing.ResponseTime;
            this.Status = routing.Status;
            this.Messages = '';
            this.addToMessages(routing.ErrorMessage);
            this.addToMessages(routing.ResponseMessage);
            this.Children = ko.observableArray([]);
            if (responses != undefined || responses != null) {
                ko.utils.arrayForEach(responses, response => {
                    this.Children.push({
                        ID: response.ID,
                        Name: 'Response ' + response.Count++,
                        RequestDataMartID: response.RequestDataMartID,
                        ResponseGroupID: response.ResponseGroupID,
                        RespondedByID: response.ResponseGroupID,
                        ResponseTime: response.ResponseTime,
                        Count: response.Count,
                        SubmittedOn: response.SubmittedOn,
                        SubmittedByID: response.SubmittedByID,
                        SubmitMessage: response.SubmitMessage,
                        ResponseMessage: response.ResponseMessage
                    })

                });
            }
            this.Children.sort(function (l, r) { return l.Count > r.Count ? -1 : 1 });
        }

        public addRoutings(routings: Dns.Interfaces.IRequestDataMartDTO[]) { //
            if (routings == null || routings.length == 0)
                return;

            ko.utils.arrayFilter(routings, n => ko.utils.arrayFirst(this.Routings, r => r.ID == n.ID) == null).forEach(routing => {
                this.addToMessages(routing.ErrorMessage);
                this.addToMessages(routing.ResponseMessage);

                this.Routings.push(routing);
            });            
        }

        private addToMessages(message: string) {
            if (message != null && message.trim().length > 0) {
                if (this.Messages != null && this.Messages.trim().length > 0)
                    this.Messages += '<br/>';
                this.Messages += message;
            }
        }
    }

    export interface IHistoryResponseData {
        DataMartName: string;
        HistoryItems: Dns.Interfaces.IResponseHistoryDTO[];
    }

    export class ViewModel extends Global.WorkflowActivityViewModel {
        public CompletedRoutings: KnockoutComputed<Dns.Interfaces.IRequestDataMartDTO[]>;
        public IncompleteRoutings: KnockoutObservable<Dns.Interfaces.IRequestDataMartDTO[]>;
        private Routings: KnockoutObservableArray<Dns.Interfaces.IRequestDataMartDTO>;
        private VirtualRoutings: KnockoutObservableArray<VirtualRoutingViewModel>;
        private OverrideableRoutingIDs: any[];

        private SelectedCompleteResponses: KnockoutObservableArray<any>;
        private SelectedIncompleteRoutings: KnockoutObservableArray<any>;

        private HasSelectedCompleteRoutings: KnockoutComputed<boolean>;
        private CanGroupCompletedRoutings: KnockoutComputed<boolean>;
        private CanUnGroupCompletedRoutings: KnockoutComputed<boolean>;
        private HasSelectedIncompleteRoutings: KnockoutComputed<boolean>;
        private NewGroupingName: string = null;

        public DataMartsToChange: KnockoutObservableArray<string>;
        public strDataMartsToChange: string;
        public DataMartsToAdd: KnockoutObservableArray<string>;
        public strDataMartsToAdd: string;
        public strDataMartsToCancel: string;

        public OverrideableRoutings: KnockoutComputed<Dns.Interfaces.IRequestDataMartDTO[]>;
        public CanOverrideRoutingStatus: KnockoutComputed<boolean>;

        public RoutingHistory: KnockoutObservableArray<IHistoryResponseData> = ko.observableArray([]);

        public TranslatePriority: (item: Dns.Enums.Priorities) => string;
        public formatDueDate: (item: Date) => string;

        public isDefault: boolean;
        public AllowCopy: boolean;
        public AllowAggregateView: boolean;

        private onShowRoutingHistory: (item: VirtualRoutingViewModel) => void;
        private onShowIncompleteRoutingHistory: (item: Dns.Interfaces.IRequestDataMartDTO) => void;

        private onComplete: () => void;
        private onCompleteWorkflow: () => void;
        private onGroupResponses: () => void;
        private onAddDataMartDialog: () => void;
        private onRemoveDataMart: () => void;
        private onEditRoutingStatusDialog: () => void;
        private onDataMartsBulkEdit: () => void;
        private onResubmitRoutings: () => void;
        private ResubmissionMessage: string = null;
        private onViewResponses: (data:any, evt:any) => void;
        private responseIndex: number = 0;

        public ProjectID: any;

        private AllowViewResults: KnockoutObservable<boolean>;
        private AllowViewRoutingHistory: boolean;
        private ShowReportingOptions: boolean = false;
        public DisableAddRemoveRoutesButtons: boolean = false;

        constructor(bindingControl: JQuery, responses: Dns.Interfaces.ICommonResponseDetailDTO, responseGroups: Dns.Interfaces.IResponseGroupDTO[], overrideableRoutingIDs: any[], canViewResponses: boolean, requestTypeModels: any[], requestPermissions: any[]) {
            super(bindingControl, Requests.Details.rovm.ScreenPermissions);
            var self = this;
            //debugger;
            if (Requests.Details.rovm.Request.IsProxyRequest) {
                self.DisableAddRemoveRoutesButtons = true
            }
            self.Routings = ko.observableArray(responses.RequestDataMarts || []);
            self.ProjectID = Requests.Details.rovm.Request.ProjectID();
            self.OverrideableRoutingIDs = overrideableRoutingIDs || [];
            self.SelectedCompleteResponses = ko.observableArray([]);
            self.SelectedIncompleteRoutings = ko.observableArray([]);

            self.AllowViewResults = ko.observable(canViewResponses);
            self.isDefault = (Requests.Details.rovm.Request.WorkflowID().toUpperCase() == 'F64E0001-4F9A-49F0-BF75-A3B501396946');
            self.AllowCopy = Requests.Details.rovm.AllowCopy();
            self.AllowViewRoutingHistory = ko.utils.arrayFirst(requestPermissions, (p) => p.toUpperCase() == Permissions.Request.ViewHistory) != null;

            self.AllowAggregateView = true;
            //Do not allow Aggregate view for request types associated with DataChecker and ModularProgram Models
            requestTypeModels.forEach((rt) => {
                if (rt.toUpperCase() == '321ADAA1-A350-4DD0-93DE-5DE658A507DF' || rt.toUpperCase() == '1B0FFD4C-3EEF-479D-A5C4-69D8BA0D0154' || rt.toUpperCase() == 'CE347EF9-3F60-4099-A221-85084F940EDE')
                    self.AllowAggregateView = false;
            });
            self.DataMartsToAdd = ko.observableArray([]);
            self.strDataMartsToAdd = '';
            self.strDataMartsToCancel = '';

            self.DataMartsToChange = ko.observableArray([]);
            self.strDataMartsToChange = '';

            this.ShowReportingOptions = (Requests.Details.rovm.RequestType.WorkflowID || '').toUpperCase() == '7A82FE34-BE6B-40E5-AABF-B40A3DBE73B8' || (Requests.Details.rovm.RequestType.WorkflowID || '').toUpperCase() == '5CE55AF8-9737-4E7A-8E0A-8C483B23EA1D';

            var showRoutingHistory = (requestDataMartID: any, requestID: any): void => {
                Dns.WebApi.Requests.GetResponseHistory(requestDataMartID, requestID).done((results: Dns.Interfaces.IResponseHistoryDTO[]) => {
                    self.RoutingHistory.removeAll();

                    var errorMesssages = ko.utils.arrayMap(ko.utils.arrayFilter(results, (r) => { return (r.ErrorMessage || '').length > 0; }), (r) => {
                        return r.ErrorMessage;
                    });

                    if (errorMesssages.length > 0) {
                        Global.Helpers.ShowErrorAlert("Error Retrieving History", errorMesssages.join('<br/>'), 500);
                    } else {
                        self.RoutingHistory.push.apply(self.RoutingHistory, results);
                        $('#responseHistoryDialog').modal('show');
                    }
                });
            };

            self.onShowRoutingHistory = (item: VirtualRoutingViewModel) => {
                showRoutingHistory(item.Routings[0].ID, item.Routings[0].RequestID);               
            };

            self.onShowIncompleteRoutingHistory = (item: Dns.Interfaces.IRequestDataMartDTO) => {
                showRoutingHistory(item.ID, item.RequestID);
            };

            Requests.Details.rovm.RoutingsChanged.subscribe((info: any) => {
                //call function on the composer to update routing info
                this.UpdateRoutings(info);

            });            

            self.CompletedRoutings = ko.computed(() => {
                return ko.utils.arrayFilter(self.Routings(), (routing) => {
                    return routing.Status == Dns.Enums.RoutingStatus.Completed ||
                        routing.Status == Dns.Enums.RoutingStatus.ResultsModified ||
                        routing.Status == Dns.Enums.RoutingStatus.AwaitingResponseApproval ||
                        routing.Status == Dns.Enums.RoutingStatus.RequestRejected ||
                        routing.Status == Dns.Enums.RoutingStatus.ResponseRejectedBeforeUpload ||
                        routing.Status == Dns.Enums.RoutingStatus.ResponseRejectedAfterUpload
                });
            });

            //may need edits to not hide rejected?
            self.IncompleteRoutings = ko.observable(
                 ko.utils.arrayFilter(self.Routings(), (routing) => {
                    return routing.Status != Dns.Enums.RoutingStatus.Completed &&
                        routing.Status != Dns.Enums.RoutingStatus.ResultsModified &&
                        routing.Status != Dns.Enums.RoutingStatus.AwaitingResponseApproval &&
                        routing.Status != Dns.Enums.RoutingStatus.RequestRejected &&
                        routing.Status != Dns.Enums.RoutingStatus.ResponseRejectedBeforeUpload &&
                        routing.Status != Dns.Enums.RoutingStatus.ResponseRejectedAfterUpload
                })
            );
            

            self.HasSelectedCompleteRoutings = ko.computed(() => {
                return self.SelectedCompleteResponses().length > 0;
            });
            self.CanGroupCompletedRoutings = ko.computed(() => {
                return self.SelectedCompleteResponses().length > 1;
            });
            self.CanUnGroupCompletedRoutings = ko.computed(() => {
                if (self.SelectedCompleteResponses().length == 1) {
                    var virtualResponse = ko.utils.arrayFirst(self.VirtualRoutings(), routing => routing.ID == self.SelectedCompleteResponses()[0]);
                    return virtualResponse != null && virtualResponse.IsGroup;
                }
                return false;
            });
            self.HasSelectedIncompleteRoutings = ko.computed(() => {
                return self.SelectedIncompleteRoutings().length > 0;
            });

            self.VirtualRoutings = ko.observableArray([]);
            //create the virtual routings, do the groups first
            if (responseGroups.length > 0) {
                ko.utils.arrayForEach(responseGroups, group => {
                    var routing = ko.utils.arrayFirst(self.Routings(), r => r.ResponseGroupID == group.ID);

                    var vr = new VirtualRoutingViewModel(routing, group);
                    vr.addRoutings(ko.utils.arrayFilter(self.Routings(), r => r.ResponseGroupID == group.ID && r.ID != routing.ID));

                    self.VirtualRoutings.push(vr);
                });
            }

            ko.utils.arrayForEach(self.CompletedRoutings(), routing => {
                if (!routing.ResponseGroupID) {
                    var routeResponses: Dns.Interfaces.IResponseDTO[] = responses.Responses.filter(function (res) {
                        return res.RequestDataMartID == routing.ID
                    }); 
                    self.VirtualRoutings.push(new VirtualRoutingViewModel(routing, null, routeResponses));
                }
            });

            Requests.Details.rovm.ReloadRoutingsRequired.subscribe(() => {
                //reload the response groups and responses
                $.when<any>(
                    Dns.WebApi.Response.GetForWorkflowRequest(Requests.Details.rovm.Request.ID(), false),
                    Dns.WebApi.Response.GetResponseGroupsByRequestID(Requests.Details.rovm.Request.ID())
                ).done((
                    rts: Dns.Interfaces.ICommonResponseDetailDTO[],
                    rg: Dns.Interfaces.IResponseGroupDTO[]
                ) => {
                    //redo the virtual routes
                    var virtualRoutes = [];
                    if (rg!= null && rg.length > 0) {
                        ko.utils.arrayForEach(rg, group => {
                            var r = ko.utils.arrayFirst(rts[0].RequestDataMarts, rx => rx.ResponseGroupID == group.ID);
                            var virtRt = new VirtualRoutingViewModel(r, group);
                            virtualRoutes.push(virtRt);
                        });
                    }

                    ko.utils.arrayForEach(rts[0].RequestDataMarts, (rt) => {
                        if (rt.ResponseGroupID == null && (
                            rt.Status == Dns.Enums.RoutingStatus.Completed ||
                            rt.Status == Dns.Enums.RoutingStatus.ResultsModified ||
                            rt.Status == Dns.Enums.RoutingStatus.AwaitingResponseApproval ||
                            rt.Status == Dns.Enums.RoutingStatus.RequestRejected ||
                            rt.Status == Dns.Enums.RoutingStatus.ResponseRejectedBeforeUpload ||
                            rt.Status == Dns.Enums.RoutingStatus.ResponseRejectedAfterUpload
                        )) {
                            virtualRoutes.push(new VirtualRoutingViewModel(rt, null));
                        }
                    });

                    self.Routings(rts[0].RequestDataMarts);
                    self.VirtualRoutings(virtualRoutes);

                });
                
            });

            self.onRemoveDataMart = () => {
                Global.Helpers.ShowConfirm(
                    'Confirm', '<div class="alert alert-warning" style="line-height:2.0em;"><p>Removed DataMarts will have their Status changed to "Canceled". Are you sure you want to remove the selected DataMart(s)?</><p style="text-align:center;" >Select "Yes" to confirm, else select "No".</p></div>').fail(() => {
                    return;
                    }).done(() => {
                    self.strDataMartsToCancel = self.SelectedIncompleteRoutings().toString();
                        self.PostComplete('5E010001-1353-44E9-9204-A3B600E263E9');
                });
            };

            self.onAddDataMartDialog = () => {
                Dns.WebApi.Requests.GetCompatibleDataMarts({
                    TermIDs: null,
                    ProjectID: self.ProjectID,
                    Request: Requests.Details.rovm.Request.Query(),
                    RequestID: Requests.Details.rovm.Request.ID()
                }).done((dataMarts) => {
                    //compatible datamarts
                    var newDataMarts = dataMarts;
                    var i = 0;

                    var allRoutes = self.Routings();
                    while (i < 100) {
                        var dm = allRoutes[i];
                        //removing already submitted DMs from the list of available DMs
                        if (dm != null || undefined) {
                            var exisitngDataMarts = ko.utils.arrayFirst(newDataMarts, datamart => datamart.ID == dm.DataMartID);
                            ko.utils.arrayRemoveItem(newDataMarts, exisitngDataMarts);
                        } else { break; }
                        i++;
                    };

                    Global.Helpers.ShowDialog("Select DataMarts To Add", "/workflow/workflowrequests/adddatamartdialog", ["Close"], 750, 410, {
                        CurrentRoutings: responses.RequestDataMarts, AllDataMarts: newDataMarts
                    }).done((result) => {
                        if (!result)
                        { return; }

                        self.DataMartsToAdd(result);
                        self.strDataMartsToAdd = self.DataMartsToAdd().toString();
                        self.PostComplete('15BDEF13-6E86-4E0F-8790-C07AE5B798A8');
                    });
                });
            };

            self.onEditRoutingStatusDialog = () => {
                Global.Helpers.ShowDialog("Select DataMarts to Edit", "/Dialogs/EditRoutingStatus", ["Close"], 750, 400, {IncompleteDataMartRoutings: self.OverrideableRoutings()})
                    .done((result: any) => {
                        for (var dm in result) {
                            //code in this loop should never be hit, handled in EditRoutingStatus.
                            if (result[dm].NewStatus == null || result[dm].NewStatus == "") {
                                Global.Helpers.ShowAlert("Validation Error", "Every checked Datamart Routing must have a specified New Routing Status.");
                                return;
                            }
                        }
                        if (dm == undefined) { return; } else {
                            self.DataMartsToChange(result);
                            self.strDataMartsToChange = JSON.stringify(self.DataMartsToChange());
                            self.PostComplete('3CF0FEA0-26B9-4042-91F3-7192D44F6F7C');
                        }
                    });
            };
           
            self.onDataMartsBulkEdit = () => {
                Global.Helpers.ShowDialog("Edit Routings", "/dialogs/metadatabulkeditpropertieseditor", ["Close"], 500, 400, { defaultPriority: Requests.Details.rovm.Request.Priority(), defaultDueDate: Requests.Details.rovm.Request.DueDate() })
                    .done((result: any) => {
                        if (result != null) {
                            //update values for selected incomplete routings
                            var routings = self.IncompleteRoutings();
                            var updatedRoutings = [];
                            self.IncompleteRoutings([]);

                            var newDueDate: Date = new Date(result.stringDate);

                            routings.forEach((dm) => {
                                if (self.SelectedIncompleteRoutings.indexOf(dm.ID) != -1) {
                                    if (result.UpdateDueDate) {
                                        dm.DueDate = newDueDate;
                                    }
                                    if (result.UpdatePriority) {
                                        dm.Priority = result.PriorityValue;
                                    }
                                }
                                updatedRoutings.push(dm);
                            });
                            self.IncompleteRoutings(updatedRoutings);
                            //save values for selected incomplete routings
                            self.PostComplete('4F7E1762-E453-4D12-8037-BAE8A95523F7');
                        }
                    });
            };

            self.onComplete = () => {

                //show confirmation dialog to complete the workflow
                Global.Helpers.ShowConfirm("Please Confirm", '<p style="text-align:center">This will complete the workflow for the current request.<br/> Do you wish to continue?</p>').done(() => {
                    Dns.WebApi.Requests.CompleteActivity({
                        DemandActivityResultID: 'E1C90001-B582-4180-9A71-A3B600EA0C27',
                        Dto: Requests.Details.rovm.Request.toData(),
                        DataMarts: self.Routings(),
                        Data: null,
                        Comment: null
                    }).done((results) => {
                        //force a reload of the page
                        window.location.href = "/requests/details?ID=" + Requests.Details.rovm.Request.ID();
                    });
                });


                
            };

            self.onCompleteWorkflow = () => {
                Global.Helpers.ShowConfirm("Please Confirm", '<p style="text-align:center">This will complete the workflow for the current request.<br/> Do you wish to continue?</p>').done(() => {
                    Dns.WebApi.Requests.CompleteActivity({
                        DemandActivityResultID: 'E93CED3B-4B55-4991-AF84-07058ABE315C',
                        Dto: Requests.Details.rovm.Request.toData(),
                        DataMarts: self.Routings(),
                        Data: null,
                        Comment: null
                    }).done((results) => {
                        //force a reload of the page
                        window.location.href = "/requests/details?ID=" + Requests.Details.rovm.Request.ID();
                    });
                });
            };

            self.onGroupResponses = () => {
                //show a dialog to get the group name
                Global.Helpers.ShowPrompt('Group Name', 'Please enter a name for the grouping:', 600, true).done(result => {
                    self.NewGroupingName = result;
                    self.PostComplete('49F9C682-9FAD-4AE5-A2C5-19157E227186');
                });
            };

            self.OverrideableRoutings = ko.computed(() => {
                return ko.utils.arrayFilter(self.Routings(),(item) => {
                    return ko.utils.arrayFirst(self.OverrideableRoutingIDs,(id) => item.ID.toUpperCase() == id.ID.toUpperCase()) != null;
                });
            });

            self.CanOverrideRoutingStatus = ko.computed(() => self.OverrideableRoutings().length > 0);

            self.onResubmitRoutings = () => {
                Global.Helpers.ShowPrompt("Resubmit Message", 'Please enter resubmit message:', 600, false).done(result => {
                    self.ResubmissionMessage = result;
                    self.PostComplete('22AE0001-0B5A-4BA9-BB55-A3B600E2728C');
                });
            };

            self.TranslatePriority = (item: Dns.Enums.Priorities) => {
                var translated = null;
                Dns.Enums.PrioritiesTranslation.forEach((p) => {
                    if (p.value == item) {
                        translated = p.text;
                    }
                });
                return translated;
            };

            self.formatDueDate = (item: Date) => {
                if (item == null)
                    return '';

                return moment(item).format('MM/D/YYYY');
            };

            self.onViewResponses = (data: any, evt: any) => {
                
                var ctl = $(evt.target);
                var resultID = ctl.attr("data-ResultID");

                var responseView: Dns.Enums.TaskItemTypes = Dns.Enums.TaskItemTypes.Response;
                if (resultID.toUpperCase() == '354A8015-5C1D-42F7-BE31-B9FCEF4A8798') {
                    //aggregate view
                    responseView = Dns.Enums.TaskItemTypes.AggregateResponse;
                }

                var tabID = 'responsedetail_' + self.responseIndex;
                self.responseIndex++;

                var q = '//' + window.location.host + '/workflowrequests/responsedetail';
                q += '?id=' + self.SelectedCompleteResponses();
                q += '&view=' + responseView;
                q += '&workflowID=' + Requests.Details.rovm.Request.WorkflowID();

                var contentFrame = document.createElement('iframe');
                contentFrame.id = 'responsedetailframe_' + self.responseIndex;
                contentFrame.src = q;
                contentFrame.setAttribute('style', 'margin:0px;padding:0px;border:none;width:100%;height:940px;min-height:940px;');
                contentFrame.setAttribute('scrolling', 'no');

                var contentContainer = $('<div class="tab-pane fade" id="' + tabID + '"></div>');
                contentContainer.append(contentFrame);
                $('#root-tab-content').append(contentContainer);

                var tl = $('<li></li>');
                var ta = $('<a href="#' + tabID + '" role="tab" data-toggle="tab" style="display:inline-block">Response Detail <i class="glyphicon glyphicon-remove-circle"></i></a>');

                var tac = ta.find('i');

                tac.click((evt) => {
                    evt.stopPropagation();
                    evt.preventDefault();

                    tl.remove();
                    $('#' + tabID).remove();

                    if ($(tl).hasClass('active')) {
                        tl.removeClass('active');
                        $('#tabs a:last').tab('show');
                    }
                });

                tl.append(ta);

                $('#tabs').append(tl);

            }   
        }

        public UpdateRoutings(updates) {
            var newPriority = updates != null ? updates.newPriority : null;
            var newDueDate = updates != null ? updates.newDueDate : null;
            if (newPriority != null) {
                var requestDataMarts = this.IncompleteRoutings();
                var updatedDataMarts = [];
                this.IncompleteRoutings([]);
                requestDataMarts.forEach((rdm) => {
                    rdm.Priority = newPriority;
                    updatedDataMarts.push(rdm);
                });
                this.IncompleteRoutings(updatedDataMarts);
            }
            if (newDueDate != null) {
                var requestDataMarts = this.IncompleteRoutings();
                var updatedDataMarts = [];
                this.IncompleteRoutings([]);
                requestDataMarts.forEach((rdm) => {
                    rdm.DueDate = newDueDate;
                    updatedDataMarts.push(rdm);
                });
                this.IncompleteRoutings(updatedDataMarts);
            }
        }

        public PostComplete(resultID: string) {
            if (!Requests.Details.rovm.Validate())
                return;

            var triggerRefresh: boolean = true;
            var groupResultID = '49F9C682-9FAD-4AE5-A2C5-19157E227186';
            var ungroupResultID = '7821FC45-9FD5-4597-A405-B021E5ED14FA';

            //The viewResponseID is not directly called by the viewing button but used when calling the PostComplete. The Individual and Aggregate ID's are on the view result buttons.
            var viewResponseID = '1C1D0001-65F4-4E02-9BB7-A3B600E27A2F';
            var viewIndiviualResultsID = '8BB67F67-764F-433B-9B61-0307836E61D8';
            var viewAggregateResultsID = '354A8015-5C1D-42F7-BE31-B9FCEF4A8798';
            var addDataMartsResultID = '15BDEF13-6E86-4E0F-8790-C07AE5B798A8';
            var removeDataMartsResultID = '5E010001-1353-44E9-9204-A3B600E263E9';
            var editRoutingStatusResultID = '3CF0FEA0-26B9-4042-91F3-7192D44F6F7C';
            var resubmitRoutingsResultID = '22AE0001-0B5A-4BA9-BB55-A3B600E2728C';
            var routingsBulkEditID = '4F7E1762-E453-4D12-8037-BAE8A95523F7';

            var data = null;
            if (resultID.toUpperCase() == viewIndiviualResultsID || resultID.toUpperCase() == viewAggregateResultsID) {


                var selectedResponses = [];
                this.SelectedCompleteResponses().forEach(id => {
                    var virtualRouting = ko.utils.arrayFirst(this.VirtualRoutings(), vr => vr.ID == id);
                    if (virtualRouting != null) {
                        ko.utils.arrayForEach(ko.utils.arrayMap(virtualRouting.Routings, r => r.ResponseID), vr => { selectedResponses.push(vr) });
                    }
                });

                data = JSON.stringify({ 'ResponseID': selectedResponses, 'Mode': (resultID.toUpperCase() == viewIndiviualResultsID.toUpperCase()) ? Dns.Enums.TaskItemTypes.Response : Dns.Enums.TaskItemTypes.AggregateResponse });
                resultID = viewResponseID;
            }
            else if (resultID.toUpperCase() == ungroupResultID) {
                //will be collection of group IDs.
                data = this.SelectedCompleteResponses().join(',');
            } else if (resultID.toUpperCase() == groupResultID) {
                //include the group name and selected responses
                data = JSON.stringify({
                    GroupName: this.NewGroupingName,
                    Responses: this.SelectedCompleteResponses()
                });
            } else if (resultID.toUpperCase() == addDataMartsResultID) {
                data = this.strDataMartsToAdd;
            } else if (resultID.toUpperCase() == removeDataMartsResultID) {
                data = this.strDataMartsToCancel.toUpperCase();
                triggerRefresh = false;
            } else if (resultID.toUpperCase() == editRoutingStatusResultID) {
                data = this.strDataMartsToChange;
            } else if (resultID.toUpperCase() == routingsBulkEditID) {
                data = this.IncompleteRoutings;
            } else if (resultID.toUpperCase() == resubmitRoutingsResultID) {
                data = JSON.stringify({
                    Responses: this.SelectedCompleteResponses(),
                    ResubmissionMessage: this.ResubmissionMessage
                });
            }


            //clear out the grouping name so that it doesn't accidentally get used again.
            this.NewGroupingName = null;
            this.ResubmissionMessage = null;

            var datamarts = this.Routings();

            Requests.Details.PromptForComment()
                .done((comment) => {
                    Dns.WebApi.Requests.CompleteActivity({
                        DemandActivityResultID: resultID,
                        Dto: Requests.Details.rovm.Request.toData(),
                        DataMarts: datamarts,
                        Data: data,
                        Comment: comment
                    }).done((results) => {

                        var result = results[0];
                        if (triggerRefresh) {
                            if (result.Uri) {
                                Global.Helpers.RedirectTo(result.Uri);
                            } else {
                                //Update the request etc. here 
                                Requests.Details.rovm.Request.ID(result.Entity.ID);
                                Requests.Details.rovm.Request.Timestamp(result.Entity.Timestamp);
                                Requests.Details.rovm.UpdateUrl();
                            }
                        }
                        else {
                            //Need to go back to the endpoint cause the results information doesnt contain anything about DM Statuses
                            Dns.WebApi.Requests.RequestDataMarts(result.Entity.ID, "Status ne Lpp.Dns.DTO.Enums.RoutingStatus'" + Dns.Enums.RoutingStatus.Canceled + "'").done((response) => {
                                if (response.length == 0) {
                                    Dns.WebApi.Requests.TerminateRequest(result.Entity.ID).done(() => {
                                        window.location.reload();
                                    });
                                }
                                else {
                                    if (result.Uri) {
                                        Global.Helpers.RedirectTo(result.Uri);
                                    } else {
                                        //Update the request etc. here 
                                        Requests.Details.rovm.Request.ID(result.Entity.ID);
                                        Requests.Details.rovm.Request.Timestamp(result.Entity.Timestamp);
                                        Requests.Details.rovm.UpdateUrl();
                                    }
                                }
                            });
                            
                        }
                        });
                        
                });
        }

        public OpenChildDetail(id: string) {
            var img = $('#img-' + id);
            var child = $('#response-' + id);
            if (img.hasClass('k-plus')) {
                img.removeClass('k-plus');
                img.addClass('k-minus');
                child.show();
            }
            else
            {
                img.addClass('k-plus');
                img.removeClass('k-minus');
                child.hide();
            }
        }

        public ViewChildResponse = (id: string) => {
            var self = this;
            var responseView: Dns.Enums.TaskItemTypes = Dns.Enums.TaskItemTypes.Response;
            var tabID = 'responsedetail_' + self.responseIndex;
            self.responseIndex++;
            var q = '//' + window.location.host + '/workflowrequests/responsedetail';
            q += '?id=' + id;
            q += '&view=' + responseView;
            q += '&workflowID=' + Requests.Details.rovm.Request.WorkflowID();

            var contentFrame = document.createElement('iframe');
            contentFrame.id = 'responsedetailframe_' + self.responseIndex;
            contentFrame.src = q;
            contentFrame.setAttribute('style', 'margin:0px;padding:0px;border:none;width:100%;height:940px;min-height:940px;');
            contentFrame.setAttribute('scrolling', 'no');

            var contentContainer = $('<div class="tab-pane fade" id="' + tabID + '"></div>');
            contentContainer.append(contentFrame);
            $('#root-tab-content').append(contentContainer);

            var tl = $('<li></li>');
            var ta = $('<a href="#' + tabID + '" role="tab" data-toggle="tab" style="display:inline-block">Response Detail <i class="glyphicon glyphicon-remove-circle"></i></a>');

            var tac = ta.find('i');

            tac.click((evt) => {
                evt.stopPropagation();
                evt.preventDefault();

                tl.remove();
                $('#' + tabID).remove();

                if ($(tl).hasClass('active')) {
                    tl.removeClass('active');
                    $('#tabs a:last').tab('show');
                }
            });

            tl.append(ta);

            $('#tabs').append(tl);

        }
    }

    export function init() {
        $(() => {
            var id: any = Global.GetQueryParam("ID");
            $.when<any>(
                Dns.WebApi.Response.GetForWorkflowRequest(id, false),
                Dns.WebApi.Response.CanViewResponses(id),
                Dns.WebApi.Response.GetResponseGroupsByRequestID(id),
                Dns.WebApi.Requests.GetOverrideableRequestDataMarts(id, null, 'ID'),
                Dns.WebApi.Requests.GetRequestTypeModels(id),
                Dns.WebApi.Requests.GetPermissions([id], [Permissions.Request.ViewHistory, Permissions])
                )
                .done((
                    responses: Dns.Interfaces.ICommonResponseDetailDTO[],
                    canViewResponses: boolean[],
                    responseGroups: Dns.Interfaces.IResponseGroupDTO[],
                    overrideableRoutingIDs: any[],
                    requestTypeModels: any[],
                    requestPermissions: any[]
                ) => {
                    Requests.Details.rovm.SaveRequestID("DFF3000B-B076-4D07-8D83-05EDE3636F4D");
                    var bindingControl = $("#CommonListRoutings");
                    vm = new ViewModel(bindingControl, responses[0], responseGroups || [], overrideableRoutingIDs, canViewResponses[0], requestTypeModels, requestPermissions || []);
                    $(() => {
                        ko.applyBindings(vm, bindingControl[0]);
                    });

            });
        });
    }
    init();
} 