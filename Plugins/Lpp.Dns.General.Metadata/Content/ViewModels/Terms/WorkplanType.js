/// <reference path="../../../../../Lpp.Mvc.Composition/Lpp.Mvc.Boilerplate/jsBootstrap.d.ts" />
/// <reference path="../../Models/Terms.ts" />
/// <reference path="../../Models/Terms/WorkplanType.ts" />
/// <reference path="../../ViewModels/Terms.ts" />
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
var RequestCriteriaViewModels;
(function (RequestCriteriaViewModels) {
    var WorkplanTypeTerm = (function (_super) {
        __extends(WorkplanTypeTerm, _super);
        function WorkplanTypeTerm(workplanTypeData) {
            var _this = _super.call(this, RequestCriteriaModels.TermTypes.WorkplanTypeTerm) || this;
            _this.WorkplanType = ko.observable(workplanTypeData == undefined ? "00000000-0000-0000-0000-000000000000" : workplanTypeData.WorkplanTypeID);
            _super.prototype.subscribeObservables.call(_this);
            return _this;
        }
        WorkplanTypeTerm.prototype.toData = function () {
            var superdata = _super.prototype.toData.call(this);
            var workplanTypeData = {
                TermType: superdata.TermType,
                WorkplanTypeID: this.WorkplanType()
            };
            return workplanTypeData;
        };
        return WorkplanTypeTerm;
    }(RequestCriteriaViewModels.Term));
    RequestCriteriaViewModels.WorkplanTypeTerm = WorkplanTypeTerm;
})(RequestCriteriaViewModels || (RequestCriteriaViewModels = {}));
