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

namespace Lpp.Dns.Portal.Views.Request
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
    
    #line 2 "..\..\Views\Request\ListBody.cshtml"
    using Lpp.Utilities.Legacy;
    
    #line default
    #line hidden
    
    [System.CodeDom.Compiler.GeneratedCodeAttribute("RazorGenerator", "2.0.0.0")]
    [System.Web.WebPages.PageVirtualPathAttribute("~/Views/Request/ListBody.cshtml")]
    public partial class ListBody : System.Web.Mvc.WebViewPage<RequestListModel>
    {

#line 131 "..\..\Views\Request\ListBody.cshtml"
public System.Web.WebPages.HelperResult Description( RequestStatusFilter f )
{
#line default
#line hidden
return new System.Web.WebPages.HelperResult(__razor_helper_writer => {

#line 132 "..\..\Views\Request\ListBody.cshtml"
 
    var da = f.GetType().GetMember( f.ToString() ).First().GetCustomAttributes( typeof( System.ComponentModel.DescriptionAttribute ), true ).FirstOrDefault() as System.ComponentModel.DescriptionAttribute;
    

#line default
#line hidden

#line 134 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_helper_writer, da == null ? null : da.Description);


#line default
#line hidden

#line 134 "..\..\Views\Request\ListBody.cshtml"
                                         


#line default
#line hidden
});

#line 135 "..\..\Views\Request\ListBody.cshtml"
}
#line default
#line hidden

#line 137 "..\..\Views\Request\ListBody.cshtml"
public System.Web.WebPages.HelperResult StatusName( RequestListRowModel item )
{
#line default
#line hidden
return new System.Web.WebPages.HelperResult(__razor_helper_writer => {

#line 138 "..\..\Views\Request\ListBody.cshtml"
 
    

#line default
#line hidden

#line 139 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_helper_writer, 
        item.Request.Scheduled                            ? "Scheduled" :
        !item.Request.SubmittedOn.HasValue                    ? "Draft" :        
        ( item.RejectedRoutings || item.RejectedResults )   ? "Rejected" :
        ( item.UnapprovedRoutings || item.UnapprovedResults )? "Approval" :
        item.CompletedDataMarts == 0                        ? "Submitted" :
        item.CompletedDataMarts == item.TotalDataMarts      ? "Completed" :
        item.CompletedDataMarts + "/" + item.TotalDataMarts + " completed"
    );


#line default
#line hidden

#line 147 "..\..\Views\Request\ListBody.cshtml"
     


#line default
#line hidden
});

#line 148 "..\..\Views\Request\ListBody.cshtml"
}
#line default
#line hidden

#line 150 "..\..\Views\Request\ListBody.cshtml"
public System.Web.WebPages.HelperResult StatusFilter()
{
#line default
#line hidden
return new System.Web.WebPages.HelperResult(__razor_helper_writer => {

#line 151 "..\..\Views\Request\ListBody.cshtml"
 
    if ( Model.List.OriginalRequest.HideStatusFilter ?? false ) { return; }
    


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "    <div");

WriteAttributeTo(__razor_helper_writer, "class", Tuple.Create(" class=\"", 7888), Tuple.Create("\"", 8005)
, Tuple.Create(Tuple.Create("", 7896), Tuple.Create("ui-dropdown-button", 7896), true)
, Tuple.Create(Tuple.Create(" ", 7914), Tuple.Create("ui-has-hint", 7915), true)
, Tuple.Create(Tuple.Create(" ", 7926), Tuple.Create("FilterButton", 7927), true)

#line 154 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 7939), Tuple.Create<System.Object, System.Int32>( Model.StatusFilter == RequestStatusFilter.All ? "" : " Active"

#line default
#line hidden
, 7939), false)
);

WriteAttributeTo(__razor_helper_writer, "hint-text", Tuple.Create(" \r\n         hint-text=\"", 8006), Tuple.Create("\"", 8071)
, Tuple.Create(Tuple.Create("", 8029), Tuple.Create("Showing", 8029), true)

#line 155 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create(" ", 8036), Tuple.Create<System.Object, System.Int32>(Description( Model.StatusFilter )

#line default
#line hidden
, 8037), false)
);

WriteLiteralTo(__razor_helper_writer, ">&nbsp;</div>\r\n");

WriteLiteralTo(__razor_helper_writer, "    <div");

WriteLiteralTo(__razor_helper_writer, " class=\"ui-dropdown FilterOptions\"");

WriteLiteralTo(__razor_helper_writer, " style=\"display: none\"");

WriteLiteralTo(__razor_helper_writer, ">\r\n");


#line 157 "..\..\Views\Request\ListBody.cshtml"
        

#line default
#line hidden

#line 157 "..\..\Views\Request\ListBody.cshtml"
         foreach ( RequestStatusFilter f in Enum.GetValues( typeof( RequestStatusFilter ) ) )
        {
            var desc = Description( f ).ToHtmlString();
            if ( desc.NullOrEmpty() ) { continue; }
            
            var m = Model.List.OriginalRequest;
            m.StatusFilter = f;
            


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "            <a");

WriteAttributeTo(__razor_helper_writer, "href", Tuple.Create(" href=\"", 8494), Tuple.Create("\"", 8559)

#line 165 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 8501), Tuple.Create<System.Object, System.Int32>(Url.Action<RequestController>( rc => rc.ListBody( m ) )

#line default
#line hidden
, 8501), false)
);

WriteAttributeTo(__razor_helper_writer, "class", Tuple.Create(" \r\n                class=\"", 8560), Tuple.Create("\"", 8646)
, Tuple.Create(Tuple.Create("", 8586), Tuple.Create("GridReloadLink", 8586), true)

#line 166 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 8600), Tuple.Create<System.Object, System.Int32>( f == Model.StatusFilter ? " Selected" : ""

#line default
#line hidden
, 8600), false)
);

WriteLiteralTo(__razor_helper_writer, ">");


#line 166 "..\..\Views\Request\ListBody.cshtml"
                                                       WriteTo(__razor_helper_writer, Html.Raw( desc ));


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "</a>\r\n");


#line 167 "..\..\Views\Request\ListBody.cshtml"
        }


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "    </div>\r\n");


#line 169 "..\..\Views\Request\ListBody.cshtml"
   


#line default
#line hidden
});

#line 170 "..\..\Views\Request\ListBody.cshtml"
}
#line default
#line hidden

#line 172 "..\..\Views\Request\ListBody.cshtml"
public System.Web.WebPages.HelperResult DateFilter()
{
#line default
#line hidden
return new System.Web.WebPages.HelperResult(__razor_helper_writer => {

#line 173 "..\..\Views\Request\ListBody.cshtml"
 
    if ( Model.List.OriginalRequest.HideDateFilter ?? false ) { return; }

    var from = Model.List.OriginalRequest.FromDateFilter;
    var to = Model.List.OriginalRequest.ToDateFilter;
    var openUpperBound = to == null || to >= DateTime.Today;
    var active = from != null || to != null;
    var possibleValues = new[] { 30, 60, 180 }.Select( daysBack => new { daysBack, fromDate = DateTime.Today.AddDays( -daysBack ) } );
    var currentFilterStr = 
        (from != null && openUpperBound) ? 
        possibleValues.Where( x => x.fromDate == from.Value ).Select( x => "Showing last " + x.daysBack + " days" ).FirstOrDefault() :
        "Filter by date";
    var m = Model.List.OriginalRequest;
    m.FromDateFilter = m.ToDateFilter = null;
    var matchingPeriodFound = false;
    


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "    <div");

WriteAttributeTo(__razor_helper_writer, "class", Tuple.Create(" class=\"", 9541), Tuple.Create("\"", 9633)
, Tuple.Create(Tuple.Create("", 9549), Tuple.Create("ui-dropdown-button", 9549), true)
, Tuple.Create(Tuple.Create(" ", 9567), Tuple.Create("ui-has-hint", 9568), true)
, Tuple.Create(Tuple.Create(" ", 9579), Tuple.Create("ui-has-header", 9580), true)
, Tuple.Create(Tuple.Create(" ", 9593), Tuple.Create("FilterButton", 9594), true)

#line 189 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 9606), Tuple.Create<System.Object, System.Int32>( active ? " Active" : ""

#line default
#line hidden
, 9606), false)
);

WriteAttributeTo(__razor_helper_writer, "hint-text", Tuple.Create(" hint-text=\"", 9634), Tuple.Create("\"", 9663)

#line 189 "..\..\Views\Request\ListBody.cshtml"
                                 , Tuple.Create(Tuple.Create("", 9646), Tuple.Create<System.Object, System.Int32>(currentFilterStr

#line default
#line hidden
, 9646), false)
);

WriteLiteralTo(__razor_helper_writer, ">&nbsp;</div>\r\n");

WriteLiteralTo(__razor_helper_writer, "    <div");

WriteLiteralTo(__razor_helper_writer, " class=\"ui-dropdown FilterOptions\"");

WriteLiteralTo(__razor_helper_writer, " style=\"display: none\"");

WriteLiteralTo(__razor_helper_writer, ">\r\n        <a");

WriteAttributeTo(__razor_helper_writer, "href", Tuple.Create(" href=\"", 9756), Tuple.Create("\"", 9821)

#line 191 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 9763), Tuple.Create<System.Object, System.Int32>(Url.Action<RequestController>( rc => rc.ListBody( m ) )

#line default
#line hidden
, 9763), false)
);

WriteAttributeTo(__razor_helper_writer, "class", Tuple.Create(" class=\"", 9822), Tuple.Create("\"", 9874)
, Tuple.Create(Tuple.Create("", 9830), Tuple.Create("GridReloadLink", 9830), true)

#line 191 "..\..\Views\Request\ListBody.cshtml"
                   , Tuple.Create(Tuple.Create("", 9844), Tuple.Create<System.Object, System.Int32>( !active ? " Selected" : ""

#line default
#line hidden
, 9844), false)
);

WriteLiteralTo(__razor_helper_writer, ">All requests</a>\r\n");


#line 192 "..\..\Views\Request\ListBody.cshtml"
        

#line default
#line hidden

#line 192 "..\..\Views\Request\ListBody.cshtml"
         foreach ( var x in possibleValues )
        {
            m.FromDateFilter = x.fromDate;
            var matching = from == x.fromDate && openUpperBound;
            matchingPeriodFound |= matching;


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "            <a");

WriteAttributeTo(__razor_helper_writer, "href", Tuple.Create(" href=\"", 10121), Tuple.Create("\"", 10186)

#line 197 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 10128), Tuple.Create<System.Object, System.Int32>(Url.Action<RequestController>( rc => rc.ListBody( m ) )

#line default
#line hidden
, 10128), false)
);

WriteAttributeTo(__razor_helper_writer, "class", Tuple.Create(" \r\n               class=\"", 10187), Tuple.Create("\"", 10257)
, Tuple.Create(Tuple.Create("", 10212), Tuple.Create("GridReloadLink", 10212), true)

#line 198 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 10226), Tuple.Create<System.Object, System.Int32>( matching ? " Selected" : ""

#line default
#line hidden
, 10226), false)
);

WriteLiteralTo(__razor_helper_writer, ">Last ");


#line 198 "..\..\Views\Request\ListBody.cshtml"
                                            WriteTo(__razor_helper_writer, x.daysBack);


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, " days</a>\r\n");


#line 199 "..\..\Views\Request\ListBody.cshtml"
        }


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "        ");


#line 200 "..\..\Views\Request\ListBody.cshtml"
         if ( !matchingPeriodFound && active )
        {


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "            <a");

WriteAttributeTo(__razor_helper_writer, "href", Tuple.Create(" href=\"", 10370), Tuple.Create("\"", 10452)

#line 202 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 10377), Tuple.Create<System.Object, System.Int32>(Url.ForList<RequestController>().WithModel( Model.List.OriginalRequest )

#line default
#line hidden
, 10377), false)
);

WriteLiteralTo(__razor_helper_writer, " class=\"GridReloadLink Selected\"");

WriteLiteralTo(__razor_helper_writer, ">Custom period</a>\r\n");


#line 203 "..\..\Views\Request\ListBody.cshtml"
        }


#line default
#line hidden
WriteLiteralTo(__razor_helper_writer, "    </div>\r\n");


#line 205 "..\..\Views\Request\ListBody.cshtml"


#line default
#line hidden
});

#line 205 "..\..\Views\Request\ListBody.cshtml"
}
#line default
#line hidden

        public ListBody()
        {
        }
        public override void Execute()
        {
WriteLiteral("\r\n");

            
            #line 4 "..\..\Views\Request\ListBody.cshtml"
   
    Layout = null;  
    this.Stylesheet( "Request.min.css" );
    var id = Html.UniqueId();
    Func<RequestListGetModel, string> reloadUrl = m => Url.Action( ( RequestController cr ) => cr.ListBody( m ) );

            
            #line default
            #line hidden
WriteLiteral(" \r\n\r\n");

            
            #line 11 "..\..\Views\Request\ListBody.cshtml"
Write(Html.Render<IGrid>()
    .From( Model.List )
    .Attributes( new { @class = "Grid RequestsGrid " + id } )
    .ReloadUrl( Url.ForList<RequestController>().ForReload( Model.List ) )
    .Id( r => r.Request.ID )
    
    .Column( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "<a");

WriteAttributeTo(__razor_template_writer, "href", Tuple.Create(" href=\"", 519), Tuple.Create("\"", 613)
            
            #line 17 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 526), Tuple.Create<System.Object, System.Int32>(Url.Action<RequestController>( c => c.RequestView( item.Request.ID, Model.Folder ) )
            
            #line default
            #line hidden
, 526), false)
);

WriteAttributeTo(__razor_template_writer, "title", Tuple.Create(" title=\"", 614), Tuple.Create("\"", 640)
            
            #line 17 "..\..\Views\Request\ListBody.cshtml"
                                        , Tuple.Create(Tuple.Create("", 622), Tuple.Create<System.Object, System.Int32>(item.Request.Name
            
            #line default
            #line hidden
, 622), false)
);

WriteLiteralTo(__razor_template_writer, ">");

            
            #line 17 "..\..\Views\Request\ListBody.cshtml"
                                                                                                           WriteTo(__razor_template_writer, item.Request.Name);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "</a>");

            
            #line 17 "..\..\Views\Request\ListBody.cshtml"
                                                                                                                                                               }),
             c => c.Title( "Name" ).Sortable( "Name" ).Class( "Name" ) )

    .Column( r => r.Request.ID, o => o.Title( "Id" ).Sortable("ID").Class( "Id" ) )

    .Column(r => ((DateTime)r.Request.UpdatedOn).ToString("MM/dd/yyyy hh:mm tt"),
             c => c.Title( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "Date ");

            
            #line 23 "..\..\Views\Request\ListBody.cshtml"
       WriteTo(__razor_template_writer, DateFilter());

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, " ");

            
            #line 23 "..\..\Views\Request\ListBody.cshtml"
                                                          })).Sortable( "Date" ).Class( "Date" ) )

    //.Column( r => r.Request.CreatedBy.UserName, o => o = o.Title( "User" ).Sortable( "UserName" ).Class( "User" ).CellAttribute( "title", r => r.Request.CreatedBy.UserName ) )

    .Column( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
            
            #line 27 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, StatusName( item ));

            
            #line default
            #line hidden
            
            #line 27 "..\..\Views\Request\ListBody.cshtml"
                                            }),
             c => c.Title( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "Status ");

            
            #line 28 "..\..\Views\Request\ListBody.cshtml"
         WriteTo(__razor_template_writer, StatusFilter());

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, " ");

            
            #line 28 "..\..\Views\Request\ListBody.cshtml"
                                                              })).Sortable( "Status" ).Class( "Status" ) )

    .Column( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
            
            #line 30 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, RequestHelpers.RequestTypeName(Model, item));

            
            #line default
            #line hidden
            
            #line 30 "..\..\Views\Request\ListBody.cshtml"
                                                                     }),
             c => c.Title( item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "Type ");

            
            #line 31 "..\..\Views\Request\ListBody.cshtml"
       WriteTo(__razor_template_writer, RequestHelpers.RequestTypeFilter(Html, Model, reloadUrl));

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, " ");

            
            #line 31 "..\..\Views\Request\ListBody.cshtml"
                                                                                                      }))
                    .Sortable( "Type" ).Class( "Type" ) )

    .If( Model.Project == null, g => g
        .Column( r => Maybe.Value( r.Request.Project ).Select( p => p.Name ),
                 c => c.Title( "Project" ).Sortable( "Project" ).Class( "Project" ) )
    )

                     .FooterSuffix(_ => RequestHelpers.PageSizeSelector(Html, Model, reloadUrl))
    .FooterPrefix(
        item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "<div");

WriteLiteralTo(__razor_template_writer, " class=\"ActionButtons\"");

WriteLiteralTo(__razor_template_writer, ">\r\n");

            
            #line 42 "..\..\Views\Request\ListBody.cshtml"
            
            
            #line default
            #line hidden
            
            #line 42 "..\..\Views\Request\ListBody.cshtml"
             if ( Model.GrantedRequestTypes.Any() )
            {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                <button");

WriteAttributeTo(__razor_template_writer, "id", Tuple.Create(" id=\"", 2059), Tuple.Create("\"", 2088)
            
            #line 44 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 2064), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 2064), false)
, Tuple.Create(Tuple.Create("", 2069), Tuple.Create("CreateRequestButton", 2069), true)
);

WriteLiteralTo(__razor_template_writer, " class=\"ui-standard-button ui-short-button\"");

WriteLiteralTo(__razor_template_writer, ">New</button>\r\n");

WriteLiteralTo(__razor_template_writer, "                <div");

WriteAttributeTo(__razor_template_writer, "class", Tuple.Create(" class=\"", 2167), Tuple.Create("\"", 2200)
            
            #line 45 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 2175), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 2175), false)
, Tuple.Create(Tuple.Create(" ", 2180), Tuple.Create("CreateRequestDialog", 2181), true)
);

WriteLiteralTo(__razor_template_writer, " style=\"display: none\"");

WriteLiteralTo(__razor_template_writer, ">\r\n                    <div");

WriteLiteralTo(__razor_template_writer, " class=\"Prompt\"");

WriteLiteralTo(__razor_template_writer, ">Please choose a model, then click a request type to create a request</div>\r\n");

            
            #line 47 "..\..\Views\Request\ListBody.cshtml"
                    
            
            #line default
            #line hidden
            
            #line 47 "..\..\Views\Request\ListBody.cshtml"
                       var models = Model.GrantedRequestTypes.Values.OrderBy( r => r.Model.Name ).ToLookup( r => r.Model.ID ); 
            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "\r\n");

WriteTo(__razor_template_writer, 
            
            #line 48 "..\..\Views\Request\ListBody.cshtml"
                    
            
            #line default
            #line hidden
            
            #line 48 "..\..\Views\Request\ListBody.cshtml"
                     Html.DropDownList( "Model",
                        models
                        .Select( mdl => new SelectListItem { Value = mdl.Key.ToString(), Text = mdl.First().Model.Name, Selected = models.Count() == 1 } )
                        .If( models.Count() > 1, ii => ii.StartWith( new SelectListItem { Value = "", Text = "Select Model" } ) ),
                        new { @class = "NewModelDropDown " + id }
                    ));

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "\r\n                \r\n                    <div");

WriteLiteralTo(__razor_template_writer, " class=\"RequestTypesContainer\"");

WriteLiteralTo(__razor_template_writer, ">\r\n");

            
            #line 56 "..\..\Views\Request\ListBody.cshtml"
                        
            
            #line default
            #line hidden
            
            #line 56 "..\..\Views\Request\ListBody.cshtml"
                         foreach ( var mdl in models )
                        {

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                            <div");

WriteAttributeTo(__razor_template_writer, "class", Tuple.Create(" class=\"", 3122), Tuple.Create("\"", 3162)
, Tuple.Create(Tuple.Create("", 3130), Tuple.Create("RequestTypes", 3130), true)
            
            #line 58 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create(" ", 3142), Tuple.Create<System.Object, System.Int32>(id
            
            #line default
            #line hidden
, 3143), false)
, Tuple.Create(Tuple.Create(" ", 3148), Tuple.Create("RTS", 3149), true)
            
            #line 58 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 3152), Tuple.Create<System.Object, System.Int32>(mdl.Key
            
            #line default
            #line hidden
, 3152), false)
);

            
            #line 58 "..\..\Views\Request\ListBody.cshtml"
                                         WriteTo(__razor_template_writer, Html.Raw( models.Count() == 1 ? " style=\"display: block;\"" : "" ));

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ">\r\n");

            
            #line 59 "..\..\Views\Request\ListBody.cshtml"
                            
            
            #line default
            #line hidden
            
            #line 59 "..\..\Views\Request\ListBody.cshtml"
                             foreach ( var r in mdl.OrderBy( r => r.RequestType.Name ) )
                            { 

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                                <a");

WriteLiteralTo(__razor_template_writer, " class=\"RequestTypeLink\"");

WriteAttributeTo(__razor_template_writer, "href", Tuple.Create(" href=\"", 3414), Tuple.Create("\"", 3507)
            
            #line 61 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 3421), Tuple.Create<System.Object, System.Int32>(Url.Action<RequestController>( c => c.Create( Model.ProjectID, r.RequestType.ID ) )
            
            #line default
            #line hidden
, 3421), false)
);

WriteLiteralTo(__razor_template_writer, ">");

            
            #line 61 "..\..\Views\Request\ListBody.cshtml"
                                                                                                                         WriteTo(__razor_template_writer, r.RequestType.Name);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "</a>\r\n");

            
            #line 62 "..\..\Views\Request\ListBody.cshtml"
                            }

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                            </div>\r\n");

            
            #line 64 "..\..\Views\Request\ListBody.cshtml"
                        }

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                    </div>\r\n                </div>\r\n");

WriteLiteralTo(__razor_template_writer, "                <script");

WriteLiteralTo(__razor_template_writer, " type=\"text/javascript\"");

WriteLiteralTo(__razor_template_writer, ">\r\n                    $(function($){\r\n                        $(\"#");

            
            #line 69 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "CreateRequestButton\").click(function () {\r\n                            $(\".");

            
            #line 70 "..\..\Views\Request\ListBody.cshtml"
 WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, @".CreateRequestDialog"").dialog({ modal: true, width: 700, height: 500, title: ""Choose Request Type"",
                                buttons: [{ text: ""Cancel"", click: function () { $(this).dialog(""close""); }, 'class': ""ui-standard-button"" }]
                            });
                            return false;
                        });

                        var allRequestTypeGroups = $("".");

            
            #line 76 "..\..\Views\Request\ListBody.cshtml"
                        WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".CreateRequestDialog .RequestTypesContainer .RequestTypes\");\r\n                   " +
"     $(\".");

            
            #line 77 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".NewModelDropDown\").bind(\"change keydown keypress\", function () {\r\n              " +
"              setTimeout(function () {\r\n                                var targ" +
"etGroup = $(\".");

            
            #line 79 "..\..\Views\Request\ListBody.cshtml"
                       WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".RTS\" + $(\".");

            
            #line 79 "..\..\Views\Request\ListBody.cshtml"
                                        WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, @".NewModelDropDown"").val());
                                if (targetGroup.is("":visible"")) return;
                                allRequestTypeGroups.slideUp(100);
                                targetGroup.slideDown(100);

                                var firstOption = $("".");

            
            #line 84 "..\..\Views\Request\ListBody.cshtml"
                       WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".NewModelDropDown > option\").eq(0);\r\n                                if (!firstOp" +
"tion.val()) firstOption.remove();\r\n                            }, 50);\r\n        " +
"                });\r\n\r\n                        $(\".");

            
            #line 89 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".CreateRequestDialog .RequestTypeLink\").click(function () {\r\n                    " +
"        window.location.href = $(this).attr(\"href\");\r\n                          " +
"  $(\".");

            
            #line 91 "..\..\Views\Request\ListBody.cshtml"
 WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, ".CreateRequestDialog\").dialog(\"destroy\");\r\n                            return fal" +
"se;\r\n                        });\r\n\r\n                        //setTimeout(functio" +
"n () { $(\".");

            
            #line 95 "..\..\Views\Request\ListBody.cshtml"
                        WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "\").gridReload(); }, 30000);\r\n                    });\r\n                </script>\r\n" +
"");

            
            #line 98 "..\..\Views\Request\ListBody.cshtml"
            }

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "    \r\n            <script");

WriteLiteralTo(__razor_template_writer, " src=\"/__r/lpp.mvc.controls/dropdown.js\"");

WriteLiteralTo(__razor_template_writer, "></script>\r\n            <script>\r\n                $(function ($) {\r\n             " +
"       $(\".Grid.");

            
            #line 103 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, " th .ui-dropdown-button\").dropdown();\r\n\r\n                    $(\".Grid.");

            
            #line 105 "..\..\Views\Request\ListBody.cshtml"
WriteTo(__razor_template_writer, id);

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, @" td.Name > a"").draggable({
                        helper: ""clone"",
                        appendTo: ""body"",
                        revert: true,
                        revertDuration: 100,
                        scope: ""Request"",
                        zIndex: 500,
                        opacity: 0.7
                    });
                });
            </script>

");

            
            #line 117 "..\..\Views\Request\ListBody.cshtml"
            
            
            #line default
            #line hidden
            
            #line 117 "..\..\Views\Request\ListBody.cshtml"
             if ( Model.AllProjects != null )
            {
                var m = Model.List.ModelForReload();
                foreach( var p in Model.AllProjects.StartWith( (Project) null ) ) {
                    m.ProjectID = p == null ? new Guid?() : p.ID;

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "                    <a");

WriteLiteralTo(__razor_template_writer, " style=\"display: none\"");

WriteAttributeTo(__razor_template_writer, "class", Tuple.Create("\r\n                        class=\"", 6477), Tuple.Create("\"", 6584)
, Tuple.Create(Tuple.Create("", 6510), Tuple.Create("ProjectFilterLink", 6510), true)
, Tuple.Create(Tuple.Create(" ", 6527), Tuple.Create("GridReloadLink", 6528), true)
            
            #line 123 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 6542), Tuple.Create<System.Object, System.Int32>( p == Model.Project ? " Selected" : "" 
            
            #line default
            #line hidden
, 6542), false)
);

WriteAttributeTo(__razor_template_writer, "href", Tuple.Create("\r\n                        href=\"", 6585), Tuple.Create("\"", 6672)
            
            #line 124 "..\..\Views\Request\ListBody.cshtml"
, Tuple.Create(Tuple.Create("", 6617), Tuple.Create<System.Object, System.Int32>(Url.Action( (RequestController c) => c.ListBody( m ) )
            
            #line default
            #line hidden
, 6617), false)
);

WriteLiteralTo(__razor_template_writer, "\r\n                        data-project=\"");

            
            #line 125 "..\..\Views\Request\ListBody.cshtml"
       WriteTo(__razor_template_writer,  p == null ? "" : p.ID.ToString() );

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "\"");

WriteLiteralTo(__razor_template_writer, ">");

            
            #line 125 "..\..\Views\Request\ListBody.cshtml"
                                              WriteTo(__razor_template_writer,  p == null ? "All Projects" : p.Name );

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "</a>\r\n");

            
            #line 126 "..\..\Views\Request\ListBody.cshtml"
                }
            }

            
            #line default
            #line hidden
WriteLiteralTo(__razor_template_writer, "        </div> ");

            
            #line 128 "..\..\Views\Request\ListBody.cshtml"
             }))
);

            
            #line default
            #line hidden
WriteLiteral("\r\n\r\n");

WriteLiteral("\r\n");

WriteLiteral("\r\n");

WriteLiteral("\r\n");

        }
    }
}
#pragma warning restore 1591