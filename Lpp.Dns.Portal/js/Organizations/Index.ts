﻿/// <reference path="../_rootlayout.ts" />

module Organizations.Index {
    var vm: ViewModel;

    export class ViewModel extends Global.PageViewModel {
        public ds: kendo.data.DataSource;

        public onColumnMenuInit: (e: any) => void;

        constructor(gOrganizationsSetting: string, bindingControl: JQuery, screenPermissions: any[]) {
            super(bindingControl, screenPermissions);
            var self = this;

            this.ds = new kendo.data.DataSource({
                type: "webapi",
                serverPaging: true,
                serverSorting: true,
                serverFiltering: true,
                transport: {
                    read: {
                        url: Global.Helpers.GetServiceUrl("/organizations/list"),
                    }
                },
                schema: {
                    model: kendo.data.Model.define(Dns.Interfaces.KendoModelDataMartDTO)
                },
                sort: { field: "Name", dir: "asc" },

            });
            Global.Helpers.SetDataSourceFromSettings(this.ds, gOrganizationsSetting); 

            this.onColumnMenuInit = (e) => {
                var menu = e.container.find(".k-menu").data("kendoMenu");
                menu.bind("close",(e) => {

                    self.Save();
                });
            };
        }
            
        public btnNewOrganization_Click() {
            window.location.href = '/organizations/details'
        }

        public OrganizationsGrid(): kendo.ui.Grid {
            return $("#gOrganizations").data("kendoGrid");
        }

        public Save() {
            Users.SetSetting("Organizations.Index.gOrganizations.User:" + User.ID, Global.Helpers.GetGridSettings(this.OrganizationsGrid()));
        }
    }

    export function NameAchor(dataItem: Dns.Interfaces.IOrganizationDTO): string {
        return "<a href=\"/organizations/details?ID=" + dataItem.ID + "\">" + dataItem.Name + "</a>";
    }
    export function ParentNameAchor(dataItem: Dns.Interfaces.IOrganizationDTO): string {
        if (dataItem.ParentOrganization != null) {
            return "<a href=\"/organizations/details?ID=" + dataItem.ParentOrganizationID + "\">" + dataItem.ParentOrganization + "</a>";
        }
        else {
            return ''
        }
        
    }

    function init() {
        $.when<any>(Users.GetSetting("Organizations.Index.gOrganizations.User:" + User.ID),
        Dns.WebApi.Users.GetGlobalPermission(Permissions.Portal.CreateOrganization)).done((gOrganizationsSetting, canAdd) => {
            $(() => {
                var bindingControl = $("#Content");
                vm = new ViewModel(gOrganizationsSetting, bindingControl, canAdd[0] ? [Permissions.Portal.CreateOrganization] : []);
                ko.applyBindings(vm, bindingControl[0]);
                $(window).unload(() => vm.Save());
                Global.Helpers.SetGridFromSettings(vm.OrganizationsGrid(), gOrganizationsSetting);
            });
        });
    }

    init();
} 