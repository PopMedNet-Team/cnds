﻿#pragma warning disable 1591
//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34014
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Lpp.Dns.HealthCare.ESPQueryBuilder.Views.ESPQueryBuilder.Terms
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
    using Lpp.Dns.HealthCare.Controllers;
    using Lpp.Dns.HealthCare.ESPQueryBuilder;
    using Lpp.Dns.HealthCare.ESPQueryBuilder.Models;
    using Lpp.Dns.HealthCare.ESPQueryBuilder.Views;
    using Lpp.Mvc;
    using Lpp.Mvc.Application;
    using Lpp.Mvc.Controls;
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/ESPQueryBuilder/Terms/Visits.cshtml")]
    public partial class Visits : System.Web.Mvc.WebViewPage<Lpp.Dns.HealthCare.ESPQueryBuilder.Models.ESPQueryBuilderModel>
    {
        public Visits()
        {
        }
        public override void Execute()
        {
            
            #line 2 "..\..\Views\ESPQueryBuilder\Terms\Visits.cshtml"
  
    Layout = null;

            
            #line default
            #line hidden
WriteLiteral("\r\n<div");

WriteLiteral(" class=\"VisitsTerm Term panel panel-default\"");

WriteLiteral(">\r\n    <input");

WriteLiteral(" name=\"TermName\"");

WriteLiteral(" value=");

WriteLiteral(" \"Visits\" hidden=\"hidden\" style=\"display:none\" />\r\n    <div");

WriteLiteral(" class=\"panel-heading\"");

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"ui-button-remove\"");

WriteLiteral("></div>\r\n        Visits\r\n    </div>\r\n    <div");

WriteLiteral(" class=\"Visits panel-body\"");

WriteLiteral(">\r\n        <div");

WriteLiteral(" class=\"form-group\"");

WriteLiteral(">\r\n            <label");

WriteLiteral(" for=\"MinVisits\"");

WriteLiteral(">Min visits</label>\r\n            <input");

WriteLiteral(" name=\"MinVisits\"");

WriteLiteral(" class=\"VisitsTextBox form-control\"");

WriteLiteral(" type=\"text\"");

WriteLiteral(" maxlength=\"3\"");

WriteAttribute("value", Tuple.Create(" value=\"", 562), Tuple.Create("\"", 586)
            
            #line 14 "..\..\Views\ESPQueryBuilder\Terms\Visits.cshtml"
                         , Tuple.Create(Tuple.Create("", 570), Tuple.Create<System.Object, System.Int32>(Model.MinVisits
            
            #line default
            #line hidden
, 570), false)
);

WriteLiteral(" />\r\n        </div>        \r\n    </div>\r\n</div>\r\n");

        }
    }
}
#pragma warning restore 1591