var __extends = (this && this.__extends) || (function () {
    var extendStatics = Object.setPrototypeOf ||
        ({ __proto__: [] } instanceof Array && function (d, b) { d.__proto__ = b; }) ||
        function (d, b) { for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p]; };
    return function (d, b) {
        extendStatics(d, b);
        function __() { this.constructor = d; }
        d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
    };
})();
var Plugins;
(function (Plugins) {
    var Requests;
    (function (Requests) {
        var QueryBuilder;
        (function (QueryBuilder) {
            var DataMartRouting;
            (function (DataMartRouting) {
                var Routings = (function () {
                    function Routings(dataMart, existingRequestDataMart) {
                        this.Priority = ko.observable(existingRequestDataMart != null ? existingRequestDataMart.Priority : dataMart.Priority);
                        this.DueDate = ko.observable(existingRequestDataMart != null ? existingRequestDataMart.DueDate : dataMart.DueDate);
                        this.Name = dataMart.Name;
                        this.Organization = dataMart.Organization;
                        this.OrganizationID = dataMart.OrganizationID;
                        this.DataMartID = dataMart.ID;
                        this._existingRequestDataMart = existingRequestDataMart;
                        var self = this;
                        self.toRequestDataMartDTO = function () {
                            var route = null;
                            if (self._existingRequestDataMart != null) {
                                //do a deep copy clone of the existing routing information;
                                route = jQuery.extend(true, {}, self._existingRequestDataMart);
                            }
                            else {
                                route = new Dns.ViewModels.RequestDataMartViewModel().toData();
                                route.DataMartID = self.DataMartID;
                                route.RequestID = self.RequestID;
                                route.DataMart = self.Name;
                            }
                            route.Priority = self.Priority();
                            route.DueDate = self.DueDate();
                            return route;
                        };
                    }
                    return Routings;
                }());
                DataMartRouting.Routings = Routings;
                var ViewModel = (function (_super) {
                    __extends(ViewModel, _super);
                    function ViewModel(bindingControl, fieldOptions, existingRequestDataMarts, defaultDueDate, defaultPriority, additionalInstructions) {
                        var _this = _super.call(this, bindingControl) || this;
                        var self = _this;
                        _this.ExistingRequestDataMarts = existingRequestDataMarts || [];
                        _this.SelectedDataMartIDs = ko.observableArray(ko.utils.arrayMap(self.ExistingRequestDataMarts, function (exdm) { return exdm.DataMartID; }));
                        _this.DefaultPriority = ko.observable(defaultPriority);
                        _this.DefaultDueDate = ko.observable(defaultDueDate);
                        _this.DataMartAdditionalInstructions = ko.observable(additionalInstructions || '');
                        _this.ExternalRoutes = ko.observableArray();
                        //only get the external routes if in request workflow
                        if (window.location.pathname.toLowerCase().indexOf('/requests/') === 0) {
                            var requestID = Global.GetQueryParam("ID");
                            if (requestID) {
                                Dns.WebApi.Requests.GetExternalRoutesForRequest(requestID).done(function (result) {
                                    var externalRoutes = [];
                                    var _loop_1 = function (i) {
                                        var rt = result[i];
                                        rt.DueDate = self.DefaultDueDate();
                                        rt.Priority = self.DefaultPriority();
                                        var existingRT = ko.utils.arrayFirst(self.ExistingRequestDataMarts, function (r) { return r.DataMartID == rt.ID; });
                                        externalRoutes.push(new Plugins.Requests.QueryBuilder.DataMartRouting.Routings(rt, existingRT));
                                    };
                                    for (var i = 0; i < result.length; i++) {
                                        _loop_1(i);
                                    }
                                    self.ExternalRoutes(externalRoutes);
                                });
                            }
                        }
                        _this.DataMarts = ko.observableArray();
                        _this.LoadDataMarts = function (projectID, strQuery) {
                            Dns.WebApi.Requests.GetCompatibleDataMarts({
                                TermIDs: null,
                                ProjectID: projectID,
                                Request: strQuery,
                                RequestID: Global.GetQueryParam("ID")
                            }).done(function (dataMarts) {
                                var routes = [];
                                for (var di = 0; di < dataMarts.length; di++) {
                                    var dm = dataMarts[di];
                                    dm.Priority = self.DefaultPriority();
                                    dm.DueDate = self.DefaultDueDate();
                                    var existingRoute = ko.utils.arrayFirst(self.ExistingRequestDataMarts, function (r) { return r.DataMartID == dm.ID; });
                                    routes.push(new Plugins.Requests.QueryBuilder.DataMartRouting.Routings(dm, existingRoute));
                                }
                                self.DataMarts(routes);
                            });
                        };
                        _this.DataMartsSelectAll = function () {
                            var datamartIDs = ko.utils.arrayMap(self.DataMarts(), function (rt) { return rt.DataMartID; });
                            ko.utils.arrayForEach(self.ExternalRoutes(), function (rt) {
                                datamartIDs.push(rt.DataMartID);
                            });
                            self.SelectedDataMartIDs(datamartIDs);
                        };
                        _this.DataMartsClearAll = function () {
                            self.SelectedDataMartIDs.removeAll();
                        };
                        _this.SelectedRoutings = function (forSubmit) {
                            var dms;
                            dms = ko.utils.arrayMap(ko.utils.arrayFilter(self.DataMarts(), function (route) {
                                return self.SelectedDataMartIDs.indexOf(route.DataMartID) > -1;
                            }), function (route) { return route.toRequestDataMartDTO(); });
                            if (forSubmit) {
                                //return only the selected external routes
                                ko.utils.arrayForEach(self.ExternalRoutes(), function (route) {
                                    if (self.SelectedDataMartIDs.indexOf(route.DataMartID) > -1) {
                                        dms.push(route.toRequestDataMartDTO());
                                    }
                                });
                            }
                            else {
                                //always return all the external routes regardless of selection, else they will get dropped from the request
                                ko.utils.arrayForEach(self.ExternalRoutes(), function (route) {
                                    dms.push(route.toRequestDataMartDTO());
                                });
                            }
                            return dms;
                        };
                        _this.DataMartsBulkEdit = function () {
                            var dueDate = self.DefaultDueDate() != null ? new Date(self.DefaultDueDate().getTime()) : null;
                            Global.Helpers.ShowDialog("Edit Routings", "/dialogs/metadatabulkeditpropertieseditor", ["Close"], 500, 400, { defaultPriority: self.DefaultPriority(), defaultDueDate: dueDate })
                                .done(function (result) {
                                if (result != null) {
                                    var priority = null;
                                    if (result.UpdatePriority) {
                                        priority = result.PriorityValue;
                                    }
                                    if (result.UpdatePriority || result.UpdateDueDate) {
                                        ko.utils.arrayFilter(self.DataMarts(), function (route) {
                                            return self.SelectedDataMartIDs.indexOf(route.DataMartID) > -1;
                                        }).forEach(function (route) {
                                            if (priority != null)
                                                route.Priority(priority);
                                            if (result.UpdateDueDate)
                                                route.DueDate(new Date(result.stringDate));
                                        });
                                        ko.utils.arrayFilter(self.ExternalRoutes(), function (route) {
                                            return self.SelectedDataMartIDs.indexOf(route.DataMartID) > -1;
                                        }).forEach(function (route) {
                                            if (priority != null)
                                                route.Priority(priority);
                                            if (result.UpdateDueDate)
                                                route.DueDate(new Date(result.stringDate));
                                        });
                                    }
                                }
                            });
                        };
                        self.FieldOptions = fieldOptions || [];
                        self.IsFieldRequired = function (id) {
                            var options = ko.utils.arrayFirst(self.FieldOptions || [], function (item) { return item.FieldIdentifier == id; });
                            return options != null && options.Permission != null && options.Permission == Dns.Enums.FieldOptionPermissions.Required;
                        };
                        self.IsFieldVisible = function (id) {
                            var options = ko.utils.arrayFirst(self.FieldOptions || [], function (item) { return item.FieldIdentifier == id; });
                            return options == null || (options.Permission != null && options.Permission != Dns.Enums.FieldOptionPermissions.Hidden);
                        };
                        return _this;
                    }
                    ViewModel.prototype.UpdateRoutings = function (updates) {
                        var newPriority = updates != null ? updates.newPriority : null;
                        var newDueDate = updates != null ? updates.newDueDate : null;
                        this.DefaultDueDate(newDueDate);
                        this.DefaultPriority(newPriority);
                        this.DataMarts().forEach(function (dm) {
                            if (newPriority != null) {
                                dm.Priority(newPriority);
                            }
                            if (newDueDate != null) {
                                dm.DueDate(newDueDate);
                            }
                        });
                        this.ExternalRoutes().forEach(function (dm) {
                            if (newPriority != null) {
                                dm.Priority(newPriority);
                            }
                            if (newDueDate != null) {
                                dm.DueDate(newDueDate);
                            }
                        });
                    };
                    return ViewModel;
                }(Global.PageViewModel));
                DataMartRouting.ViewModel = ViewModel;
                function init(bindingControl, fieldOptions, existingRequestDataMarts, defaultDueDate, defaultPriority, additionalInstructions) {
                    var bindingControl = $('#DataMartsControl');
                    DataMartRouting.vm = new Plugins.Requests.QueryBuilder.DataMartRouting.ViewModel(bindingControl, fieldOptions, existingRequestDataMarts, defaultDueDate, defaultPriority, additionalInstructions);
                    ko.applyBindings(DataMartRouting.vm, bindingControl[0]);
                }
                DataMartRouting.init = init;
            })(DataMartRouting = QueryBuilder.DataMartRouting || (QueryBuilder.DataMartRouting = {}));
        })(QueryBuilder = Requests.QueryBuilder || (Requests.QueryBuilder = {}));
    })(Requests = Plugins.Requests || (Plugins.Requests = {}));
})(Plugins || (Plugins = {}));
//# sourceMappingURL=DataMartRouting.js.map