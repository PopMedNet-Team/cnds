﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.0
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Lpp.Dns.General.CriteriaGroup.Views.CriteriaGroup.Terms
{
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Text;
    using System.Web;
    using System.Web.Helpers;
    using System.Web.Mvc;
    using System.Web.Mvc.Ajax;
    using System.Web.Mvc.Html;
    using System.Web.Routing;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.WebPages;
    using Lpp;
    using Lpp.Dns.General.CriteriaGroup;
    using Lpp.Dns.General.CriteriaGroup.Models;
    using Lpp.Mvc;
    using Lpp.Mvc.Application;
    using Lpp.Mvc.Controls;
    using Lpp.Utilities.Legacy;
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/CriteriaGroup/Terms/ObservationPeriod.cshtml")]
    public partial class ObservationPeriod : System.Web.Mvc.WebViewPage<Lpp.Dns.General.CriteriaGroup.Models.ObservationPeriodModel>
    {
        public ObservationPeriod()
        {
        }
        public override void Execute()
        {
            
            #line 2 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
   this.Stylesheet("CriteriaGroup.min.css"); 
            
            #line default
            #line hidden
WriteLiteral("\r\n");

            
            #line 3 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
  
    var id = Html.UniqueId().TrimStart('_');

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n<div");

WriteLiteral(" class=\"panel panel-default ObservationPeriodTerm Term\"");

WriteLiteral(">\r\n    <div");

WriteLiteral(" class=\"panel-heading\"");

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"ui-button-remove\"");

WriteLiteral("></div>\r\n        <span>Observation Period Range<img");

WriteLiteral(" src=\"/Content/img/icons/help16.gif\"");

WriteLiteral(" class=\"helptip\"");

WriteLiteral(" title=\"Dates may differ by network and are based on encounter dates.\"");

WriteLiteral(" /></span>\r\n    </div>\r\n    <div");

WriteLiteral(" class=\"panel-body\"");

WriteLiteral(">\r\n    <input");

WriteLiteral(" name=\"TermName\"");

WriteLiteral(" value=");

WriteLiteral(" \"ObservationPeriod\" hidden=\"hidden\" style=\"display:none\" />\r\n    <div");

WriteLiteral(" class=\"ObservationPeriod\"");

WriteAttribute("id", Tuple.Create(" id=\"", 659), Tuple.Create("\"", 685)
, Tuple.Create(Tuple.Create("", 664), Tuple.Create("ObservationPeriod_", 664), true)
            
            #line 14 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
, Tuple.Create(Tuple.Create("", 682), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 682), false)
);

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"ObservationPeriodInput ui-form\"");

WriteLiteral(">\r\n            <div>\r\n                <label");

WriteLiteral(" class=\"Selections\"");

WriteLiteral(">Start Period</label>\r\n                <label");

WriteLiteral(" style=\"color: red; font-size: x-small;\"");

WriteLiteral(">(MM/DD/YYYY)</label>\r\n            </div>\r\n            <div>\r\n                <sp" +
"an");

WriteLiteral(" class=\"k-invalid-msg\"");

WriteLiteral(" data-for=\"StartPeriod\"");

WriteLiteral("></span>\r\n                <input");

WriteLiteral(" name=\"StartPeriod\"");

WriteAttribute("id", Tuple.Create(" id=\"", 1067), Tuple.Create("\"", 1087)
, Tuple.Create(Tuple.Create("", 1072), Tuple.Create("StartPeriod_", 1072), true)
            
            #line 22 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
, Tuple.Create(Tuple.Create("", 1084), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 1084), false)
);

WriteLiteral(" type=\"date\"");

WriteAttribute("value", Tuple.Create(" value=\"", 1100), Tuple.Create("\"", 1190)
            
            #line 22 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
   , Tuple.Create(Tuple.Create("", 1108), Tuple.Create<System.Object, System.Int32>(Model.StartPeriod == null ? "" : Model.StartPeriod.Value.ToString("MM/dd/yyyy")
            
            #line default
            #line hidden
, 1108), false)
);

WriteLiteral(" maxlength=\"10\"");

WriteLiteral(" data-datepicker=\"datepicker\"");

WriteLiteral(" data-format=\"MM/dd/yyyy\"");

WriteLiteral(" />\r\n            </div>\r\n        </div>\r\n        <div");

WriteLiteral(" class=\"ObservationPeriodInput ui-form\"");

WriteLiteral(">\r\n            <div>\r\n                <label");

WriteLiteral(" class=\"Selections\"");

WriteLiteral(">End Period</label>\r\n                <label");

WriteLiteral(" style=\"color: red; font-size: x-small;\"");

WriteLiteral(">(MM/DD/YYYY)</label>\r\n            </div>\r\n            <div>\r\n                <sp" +
"an");

WriteLiteral(" class=\"k-invalid-msg\"");

WriteLiteral(" data-for=\"EndPeriod\"");

WriteLiteral("></span>\r\n                <input");

WriteLiteral(" name=\"EndPeriod\"");

WriteAttribute("id", Tuple.Create(" id=\"", 1673), Tuple.Create("\"", 1691)
, Tuple.Create(Tuple.Create("", 1678), Tuple.Create("EndPeriod_", 1678), true)
            
            #line 32 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
, Tuple.Create(Tuple.Create("", 1688), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 1688), false)
);

WriteLiteral(" type=\"date\"");

WriteAttribute("value", Tuple.Create(" value=\"", 1704), Tuple.Create("\"", 1790)
            
            #line 32 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
, Tuple.Create(Tuple.Create("", 1712), Tuple.Create<System.Object, System.Int32>(Model.EndPeriod == null ? "" : Model.EndPeriod.Value.ToString("MM/dd/yyyy")
            
            #line default
            #line hidden
, 1712), false)
);

WriteLiteral(" maxlength=\"10\"");

WriteLiteral(" data-datepicker=\"datepicker\"");

WriteLiteral(" data-format=\"MM/dd/yyyy\"");

WriteLiteral(@"/>
            </div>
        </div>
        </div>
    </div>
    <script>
    $(function () {
        $('.trackChanges').kendoValidator({
            rules: {
                dateValidation: function (input) {
                    if ((input.is('[id=""StartPeriod_");

            
            #line 42 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
                                               Write(id);

            
            #line default
            #line hidden
WriteLiteral("\"]\') || input.is(\'[id=\"EndPeriod_");

            
            #line 42 "..\..\Views\CriteriaGroup\Terms\ObservationPeriod.cshtml"
                                                                                   Write(id);

            
            #line default
            #line hidden
WriteLiteral(@"""]')) && input.val() != """") {
                        return kendo.parseDate(input.val()) != null;
                    }
                    return true;
                }
            },
            messages: {
                dateValidation: """"
            },
            validateOnBlur: true
        });
    });
    </script>
</div>
");

        }
    }
}
#pragma warning restore 1591
