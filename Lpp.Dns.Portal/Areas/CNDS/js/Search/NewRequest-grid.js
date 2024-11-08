/// <reference path="../../../../../Lpp.Dns.Api/Scripts/Lpp.CNDS.Interfaces.ts" />
/// <reference path="../../../../js/_layout.ts" />
/// <reference path="common.ts" />
var CNDS;
(function (CNDS) {
    var Search;
    (function (Search) {
        var DataSources_Grid;
        (function (DataSources_Grid) {
            var vm = null;
            var ViewModel = (function () {
                function ViewModel() {
                    var self = this;
                    self.DisableNewRequestButton = ko.observable(false);
                    self.SelectedDataSources = {};
                    self.NumberOfSelectedDataSources = ko.observable(0);
                    self.SelectedRequestTypeDetails = ko.observable(null);
                    self.SelectedRequestTypeName = ko.pureComputed(function () {
                        if (self.SelectedRequestTypeDetails() != null) {
                            return self.SelectedRequestTypeDetails().RequestType;
                        }
                        return "";
                    });
                    self.SelectedRequestTypeProjectName = ko.pureComputed(function () {
                        if (self.SelectedRequestTypeDetails() != null) {
                            return self.SelectedRequestTypeDetails().Project;
                        }
                        return "";
                    });
                    self.dsDataSources = new kendo.data.DataSource({
                        data: [],
                        schema: {
                            model: Dns.Interfaces.KendoModelCNDSDataSourceExtendedDTO
                        },
                        sort: [
                            { field: 'Network', dir: 'asc' },
                            { field: 'Organization', dir: 'asc' },
                            { field: 'Name', dir: 'asc' }
                        ]
                    });
                    var ids = $.url().param("id");
                    if (Array.isArray(ids) == false) {
                        //if only one id is specified the result is only a string, need to convert to an array.
                        ids = [ids];
                    }
                    var idFilter = ids.map(function (id) { return "ID eq " + id; }).join(' or ');
                    Dns.WebApi.CNDSSearch.DataSources(idFilter).done(function (datasources) {
                        self.dsDataSources.data(datasources);
                    });
                    var grid = $('#gDataSources').kendoGrid({
                        dataSource: self.dsDataSources,
                        pageable: false,
                        sortable: true,
                        height: 600,
                        resizable: true,
                        reorderable: true,
                        scrollable: { virtual: false },
                        filterable: true,
                        columns: [
                            { template: "# if (AdapterSupported != '') {# <input id='#: ID #' type='checkbox' class='checkbox' /> #} #", width: 40, headerTemplate: "<input type='checkbox' class='header-checkbox' />", attributes: { 'style': "align:center;" }, filterable: true },
                            { field: 'Name', title: 'Data Source' },
                            { field: 'Acronym', title: 'Acronym' },
                            { field: 'Organization', title: 'Organization' },
                            { field: 'Network', title: 'Network' },
                            { field: 'AdapterSupported', title: 'Adapter' }
                        ],
                        columnMenu: true,
                        dataBound: function (e) {
                            var id = $.url().param("id");
                            if (id != undefined && id != null) {
                                ko.utils.arrayForEach(id, function (item) {
                                    $("#" + item).click();
                                });
                            }
                        },
                        columnMenuInit: function (e) {
                            var menu = e.container.find(".k-menu").data("kendoMenu");
                            menu.bind("close", function () {
                                try {
                                    Users.SetSetting("CNDS.Search.DataSources.gDataSources.User:" + User.ID, Global.Helpers.GetGridSettings(grid));
                                }
                                catch (ex) {
                                    //ignore the error
                                }
                                ;
                            });
                        }
                    }).data("kendoGrid");
                    grid.table.on('click', '.checkbox', function (data) {
                        var checked = data.target.checked;
                        var row = $(data.target).closest("tr");
                        var dataItem = grid.dataItem(row);
                        if (checked) {
                            self.SelectedDataSources[dataItem.uid] = {
                                'checked': checked,
                                'item': dataItem
                            };
                            self.NumberOfSelectedDataSources(self.NumberOfSelectedDataSources() + 1);
                        }
                        else {
                            delete self.SelectedDataSources[dataItem.uid];
                            self.NumberOfSelectedDataSources(self.NumberOfSelectedDataSources() - 1);
                        }
                        if (checked) {
                            row.addClass("k-state-selected");
                        }
                        else {
                            row.removeClass("k-state-selected");
                        }
                        var headerCheckbox = $('.header-checkbox');
                        if (self.NumberOfSelectedDataSources() > 0) {
                            headerCheckbox.prop('checked', true);
                        }
                        else {
                            headerCheckbox.removeProp('checked');
                        }
                    });
                    grid.thead.on('click', '.header-checkbox', function (data) {
                        var checked = data.target.checked;
                        var rows = $(grid.tbody).children('tr:has(input[type=checkbox])');
                        if (checked) {
                            rows.addClass('k-state-selected');
                        }
                        else {
                            rows.removeClass('k-state-selected');
                        }
                        var checkboxes = $(grid.table).find('.checkbox');
                        checkboxes.prop('checked', checked);
                        var items = {};
                        if (checked) {
                            ko.utils.arrayForEach(grid.dataItems(), function (r) {
                                if (r.AdapterSupportedID) {
                                    items[r.uid] = { 'checked': checked, 'item': r };
                                }
                            });
                        }
                        self.SelectedDataSources = items;
                        self.NumberOfSelectedDataSources(Object.keys(self.SelectedDataSources).length);
                    });
                    self.onSelectRequestType = function () {
                        var selected = [];
                        for (var key in self.SelectedDataSources) {
                            var ds = self.SelectedDataSources[key];
                            if (ds.checked) {
                                selected.push({ ID: ds.item.ID, NetworkID: ds.item.NetworkID, OrganizationID: ds.item.OrganizationID, Name: ds.item.Name, Network: ds.item.Network, Organization: ds.item.Organization });
                            }
                        }
                        if (selected.length == 0) {
                            self.SelectedDataSources = {};
                            self.NumberOfSelectedDataSources(0);
                            return;
                        }
                        self.DisableNewRequestButton(true);
                        Global.Helpers.ShowDialog('Select the Request Project and Type', '/CNDS/Search/SelectRequestType', [], 800, 700, { DataSources: selected }).done(function (result) {
                            if (result == null) {
                                self.DisableNewRequestButton(false);
                                self.SelectedRequestTypeDetails(null);
                                return;
                            }
                            self.SelectedRequestTypeDetails(result);
                            Global.Helpers.ShowDialog('Request Form', '/cnds/search/createrequest', [], 800, 700, result).done(function (request) {
                                if (!request) {
                                    self.DisableNewRequestButton(false);
                                    return;
                                }
                                Global.Helpers.ShowExecuting();
                                var routes = (self.SelectedRequestTypeDetails().LocalRoutes || []).concat((self.SelectedRequestTypeDetails().ExternalRoutes || [])).map(function (rt) { return ({ DefinitionID: rt.MappingDefinitionID, NetworkID: rt.NetworkID, Network: rt.Network, ProjectID: rt.ProjectID, Project: rt.Project, DataMartID: rt.DataMartID, DataMart: rt.DataMart, RequestTypeID: rt.RequestTypeID, RequestType: rt.RequestType }); });
                                //save the request, navigate to the request details page                        
                                Dns.WebApi.Requests.CreateRequest({
                                    Comment: null,
                                    Data: null,
                                    Routes: routes,
                                    DemandActivityResultID: null,
                                    Dto: request
                                }).done(function (res) {
                                    Global.Helpers.RedirectTo(res[0].Uri);
                                });
                            });
                        });
                    };
                }
                return ViewModel;
            }());
            DataSources_Grid.ViewModel = ViewModel;
            function init() {
                $.when(Users.GetSetting("CNDS.Search.DataSources.gDataSources.User:" + User.ID)).done(function (gridDataSourcesSettings, m) {
                    $(function () {
                        vm = new ViewModel();
                        var bindingControl = $('#Content');
                        ko.applyBindings(vm, bindingControl[0]);
                        try {
                            Global.Helpers.SetGridFromSettings($("#gDataSources").data("kendoGrid"), gridDataSourcesSettings);
                        }
                        catch (ex) {
                            //ignore the error
                        }
                        ;
                    });
                });
            }
            init();
        })(DataSources_Grid = Search.DataSources_Grid || (Search.DataSources_Grid = {}));
    })(Search = CNDS.Search || (CNDS.Search = {}));
})(CNDS || (CNDS = {}));
//# sourceMappingURL=NewRequest-grid.js.map