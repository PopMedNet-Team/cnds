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

namespace Lpp.Dns.Portal.Views.Crud
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
    using Lpp.Dns;
    using Lpp.Dns.Data;
    using Lpp.Dns.Portal;
    using Lpp.Dns.Portal.Controllers;
    using Lpp.Dns.Portal.Models;
    using Lpp.Dns.Portal.Views;
    using Lpp.Mvc;
    using Lpp.Mvc.Application;
    using Lpp.Mvc.Controls;
    
    #line 2 "..\..\Views\Crud\ForSelectionList.cshtml"
    using Lpp.Utilities.Legacy;
    
    #line default
    #line hidden
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Crud/ForSelectionList.cshtml")]
    public partial class ForSelectionList : System.Web.Mvc.WebViewPage<EntitiesForSelectionModel>
    {
        public ForSelectionList()
        {
        }
        public override void Execute()
        {
            
            #line 3 "..\..\Views\Crud\ForSelectionList.cshtml"
   Layout = null;  
            
            #line default
            #line hidden
WriteLiteral("\r\n");

            
            #line 4 "..\..\Views\Crud\ForSelectionList.cshtml"
Write(Html.Render<IGrid>()
        .From( Model.Entities )
        .Id( g => g.ID )
        .ReloadUrl(Model.ReloadUrl(Url))
        .Column( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "<a");

WriteLiteralTo(__razor_template_writer, " href=\"#\"");

WriteLiteralTo(__razor_template_writer, " class=\"ChooseLink\"");

WriteLiteralTo(__razor_template_writer, " data-id=\"");

            
            #line 8 "..\..\Views\Crud\ForSelectionList.cshtml"
                          WriteTo(__razor_template_writer, item.ID);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "\"");

WriteLiteralTo(__razor_template_writer, " ");

            
            #line 8 "..\..\Views\Crud\ForSelectionList.cshtml"
                                    WriteTo(__razor_template_writer, Html.Raw( item.Attributes.EmptyIfNull().Any() ? ("data-props='" + Json.Encode(item.Attributes) + "'") : ""));

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ">");

            
            #line 8 "..\..\Views\Crud\ForSelectionList.cshtml"
                                                                                                                                                 WriteTo(__razor_template_writer, item.Name);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "</a>");

            
            #line 8 "..\..\Views\Crud\ForSelectionList.cshtml"
                                                                                                                                                                                             }), 
            c => c.Title("Choose").Class("ChooseLink"))
);

            
            #line default
            #line hidden
        }
    }
}
#pragma warning restore 1591
