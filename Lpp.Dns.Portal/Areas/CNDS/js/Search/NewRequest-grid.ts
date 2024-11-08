﻿/// <reference path="../../../../../Lpp.Dns.Api/Scripts/Lpp.CNDS.Interfaces.ts" />
/// <reference path="../../../../js/_layout.ts" />
/// <reference path="common.ts" />

module CNDS.Search.DataSources_Grid {
    var vm = null;

    export class ViewModel {
        public dsDataSources: kendo.data.DataSource;
        public SelectedDataSources: any;
        public onSelectRequestType: () => void;
        public NumberOfSelectedDataSources: KnockoutObservable<number>;

        public SelectedRequestTypeDetails: KnockoutObservable<Dns.Interfaces.ICNDSSourceRequestTypeDTO>;
        public SelectedRequestTypeName: KnockoutComputed<string>;
        public SelectedRequestTypeProjectName: KnockoutComputed<string>;
        public DisableNewRequestButton: KnockoutObservable<boolean>;

        constructor() {
            let self = this;  

            self.DisableNewRequestButton = ko.observable(false);
            self.SelectedDataSources = {};
            self.NumberOfSelectedDataSources = ko.observable(0);
            self.SelectedRequestTypeDetails = ko.observable(null);
            self.SelectedRequestTypeName = ko.pureComputed(() => {
                if (self.SelectedRequestTypeDetails() != null) {
                    return self.SelectedRequestTypeDetails().RequestType;
                }
                return "";
            });

            self.SelectedRequestTypeProjectName = ko.pureComputed(() => {
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

            let ids = <any>$.url().param("id");
            if (Array.isArray(ids) == false) {
                //if only one id is specified the result is only a string, need to convert to an array.
                ids = [ids];
            }
            let idFilter = ids.map(id => "ID eq " + id).join(' or ');

            Dns.WebApi.CNDSSearch.DataSources(idFilter).done((datasources) => {                
                self.dsDataSources.data(datasources);
            });
            
            let grid = $('#gDataSources').kendoGrid({
                dataSource: self.dsDataSources,
                pageable: false,
                sortable: true,
                height: 600,
                resizable: true,
                reorderable: true,
                scrollable: { virtual: false },
                filterable: true,
                columns: [
                    { template: "# if (AdapterSupported != '') {# <input id='#: ID #' type='checkbox' class='checkbox' /> #} #", width: 40, headerTemplate: "<input type='checkbox' class='header-checkbox' />", attributes: { 'style': "align:center;" }, filterable:true },
                    { field: 'Name', title: 'Data Source' },
                    { field: 'Acronym', title: 'Acronym' },
                    { field: 'Organization', title: 'Organization' },
                    { field: 'Network', title: 'Network' },
                    { field: 'AdapterSupported', title: 'Adapter' }
                ],
                columnMenu: true,
                dataBound: function (e) {
                    let id: any = $.url().param("id");
                    if (id != undefined && id != null) {
                        ko.utils.arrayForEach(id, (item) => {
                            $("#" + item).click();
                        });
                    }
                },
                columnMenuInit: (e) => {
                    let menu = e.container.find(".k-menu").data("kendoMenu");
                    menu.bind("close", () => {
                        try {
                            Users.SetSetting("CNDS.Search.DataSources.gDataSources.User:" + User.ID, Global.Helpers.GetGridSettings(grid));
                        } catch (ex) {
                            //ignore the error
                        };
                    });
                }
            }).data("kendoGrid");

            grid.table.on('click', '.checkbox', (data) => {
                let checked = (<any>data.target).checked;
                let row = $(data.target).closest("tr");
                let dataItem = grid.dataItem(row);

                if (checked) {
                    self.SelectedDataSources[dataItem.uid] = {
                        'checked': checked,
                        'item': dataItem
                    };

                    self.NumberOfSelectedDataSources(self.NumberOfSelectedDataSources() + 1);
                } else {
                    delete self.SelectedDataSources[dataItem.uid];
                    self.NumberOfSelectedDataSources(self.NumberOfSelectedDataSources() - 1);
                }

                if (checked) {
                    row.addClass("k-state-selected");
                } else {
                    row.removeClass("k-state-selected");
                }

                let headerCheckbox = $('.header-checkbox');
                if (self.NumberOfSelectedDataSources() > 0) {
                    headerCheckbox.prop('checked', true);
                } else {
                    headerCheckbox.removeProp('checked');
                }
                

            });

            grid.thead.on('click', '.header-checkbox', (data) => {
                let checked = (<any>data.target).checked;
                
                let rows = $(grid.tbody).children('tr:has(input[type=checkbox])');
                if (checked) {
                    rows.addClass('k-state-selected');
                } else {
                    rows.removeClass('k-state-selected');
                }

                let checkboxes = $(grid.table).find('.checkbox');
                checkboxes.prop('checked', checked);

                let items = {};
                if (checked) {
                    ko.utils.arrayForEach((<any>grid).dataItems(), (r: any) => {
                        if (r.AdapterSupportedID) {
                            items[r.uid] = { 'checked': checked, 'item': r };
                        }
                    });
                }
                self.SelectedDataSources = items;
                self.NumberOfSelectedDataSources(Object.keys(self.SelectedDataSources).length);
            });

            self.onSelectRequestType = () => {
                let selected = [];
                for (let key in self.SelectedDataSources) {
                    let ds = self.SelectedDataSources[key];
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

                Global.Helpers.ShowDialog('Select the Request Project and Type', '/CNDS/Search/SelectRequestType', [], 800, 700, { DataSources: selected }).done((result: Dns.Interfaces.ICNDSSourceRequestTypeDTO) => {
                    if (result == null) {
                        self.DisableNewRequestButton(false);
                        self.SelectedRequestTypeDetails(null);
                        return;
                    }

                    self.SelectedRequestTypeDetails(result);

                    Global.Helpers.ShowDialog('Request Form', '/cnds/search/createrequest', [], 800, 700, result).done((request: Dns.Interfaces.IRequestDTO) => {
                        if (!request) {
                            self.DisableNewRequestButton(false);
                            return;
                        }

                        Global.Helpers.ShowExecuting();

                        let routes = (self.SelectedRequestTypeDetails().LocalRoutes || []).concat((self.SelectedRequestTypeDetails().ExternalRoutes || [])).map(rt => <Dns.Interfaces.ICNDSNetworkProjectRequestTypeDataMartDTO>{ DefinitionID: rt.MappingDefinitionID, NetworkID: rt.NetworkID, Network: rt.Network, ProjectID: rt.ProjectID, Project: rt.Project, DataMartID: rt.DataMartID, DataMart: rt.DataMart, RequestTypeID: rt.RequestTypeID, RequestType: rt.RequestType });
                        
                        //save the request, navigate to the request details page                        
                        Dns.WebApi.Requests.CreateRequest(<Dns.Interfaces.ICreateCNDSRequestDetailsDTO>{
                            Comment: null,
                            Data: null,
                            Routes: routes,
                            DemandActivityResultID: null,
                            Dto: request
                        }).done((res: Dns.Interfaces.IRequestCompletionResponseDTO[]) => {
                            Global.Helpers.RedirectTo(res[0].Uri);
                        });                        

                    });
                });
            };

        }
    }

    function init() {
        $.when<any>(
            Users.GetSetting("CNDS.Search.DataSources.gDataSources.User:" + User.ID)
        ).done((gridDataSourcesSettings, m) => {
            $(() => {
                vm = new ViewModel();
                var bindingControl = $('#Content');
                ko.applyBindings(vm, bindingControl[0]);
                try {
                    Global.Helpers.SetGridFromSettings($("#gDataSources").data("kendoGrid"), gridDataSourcesSettings);
                } catch (ex) {
                    //ignore the error
                };
            });
        });
    }

    init();
    
}