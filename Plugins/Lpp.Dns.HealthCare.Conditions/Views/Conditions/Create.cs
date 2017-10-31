﻿//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34011
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Lpp.Dns.HealthCare.Conditions.Views.Conditions {
    using System;
    using System.Collections.Generic;
    using System.IO;
    using System.Linq;
    using System.Net;
    using System.Web;
    using System.Web.Helpers;
    using System.Web.Security;
    using System.Web.UI;
    using System.Web.WebPages;
    using System.Web.Mvc;
    using System.Web.Mvc.Ajax;
    using System.Web.Mvc.Html;
    using System.Web.Routing;
    using Lpp;
    using Lpp.Mvc;
    using Lpp.Mvc.Application;
    using Lpp.Mvc.Controls;
    using Lpp.Dns.HealthCare.Controllers;
    using Lpp.Dns.HealthCare.Conditions;
    using Lpp.Dns.HealthCare.Conditions.Models;
    
    
    public partial class Create : System.Web.Mvc.WebViewPage<Lpp.Dns.HealthCare.Conditions.Models.ConditionsModel> {
        
#line hidden

        
        public Create() {
        }
        
        protected System.Web.HttpApplication ApplicationInstance {
            get {
                return ((System.Web.HttpApplication)(Context.ApplicationInstance));
            }
        }
        
        public override void Execute() {


            
            #line 2 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
   this.Stylesheet("ESPQueryBuilder.css"); 

            
            #line default
            #line hidden
WriteLiteral(@"<div class=""MedicalRequest ui-form"">
    <div class=""ui-form"">
        <div class=""ReportType"">

                <div class=""ui-groupbox"">
                    <div class=""ui-groupbox-header"">
                        <span>Conditions</span></div>
                    <div class=""ui-form"">
                        <div>
                            <label class=""Selections"">
                                Condition</label></div>
                    </div>
                    <br />
                    ");


            
            #line 16 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
               Write(Html.DropDownListFor(m => m.Disease, Model.DiseaseSelections

                .Select(s => new SelectListItem { Text = s.Display, Value = s.Name })));

            
            #line default
            #line hidden
WriteLiteral(@"
                </div>

        </div>
        <br />
        <div class=""Parameters"">
            <div class=""LeftParamBlock"">
                <div class=""ui-groupbox"">
                    <div class=""ui-groupbox-header"">
                        <span>Observation Period Range</span></div>
                    <table>
                        <tr>
                            <td>
                                <div class=""ui-form"">
                                    <div>
                                        <label class=""Selections"">
                                            Start Period</label>
                                        <label style=""color: red; font-size: x-small;"">
                                            (MM/DD/YYYY)</label></div>
                                </div>
                            </td>
                            <td>
                                <div class=""ui-form"">
                                    <div>
                                        <label class=""Selections"">
                                            End Period</label><label style=""color: red; font-size: x-small;"">(MM/DD/YYYY)</label></div>
                                </div>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                ");


            
            #line 49 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                           Write(Html.TextBox("StartPeriod", Model.StartPeriodDate.ToString("MM/dd/yyyy"), new { id = "StartPeriod", maxlength = 10 }));

            
            #line default
            #line hidden
WriteLiteral(@"
                                <script type=""text/javascript"">
                                    $(""#StartPeriod"").datepicker({
                                        changeMonth: true,
                                        changeYear: true,
                                        defaultDate: +0,
                                        maxDate: '12/31/2299',
                                        minDate: '01/01/1900',
                                        showButtonPanel: true
                                    });

                                </script>
                            </td>
                            <td>
                                ");


            
            #line 63 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                           Write(Html.TextBox("EndPeriod", Model.EndPeriodDate.ToString("MM/dd/yyyy"), new { id = "EndPeriod", maxlength = 10 }));

            
            #line default
            #line hidden
WriteLiteral("\r\n                                <script type=\"text/javascript\">\r\n              " +
"                      var dateFlag = false;\r\n                                   " +
" $(\"#EndPeriod\").datepicker({\r\n                                        changeMon" +
"th: true,\r\n                                        changeYear: true,\r\n          " +
"                              defaultDate: +0,\r\n                                " +
"        maxDate: \'12/31/2299\',\r\n                                        minDate:" +
" \'01/01/1900\',\r\n                                        showButtonPanel: true\r\n " +
"                                   });\r\n                                    $(\"#" +
"StartPeriod\").change(function () {\r\n                                        if (" +
"!$(this).isValidDate($(this).val())) {\r\n                                        " +
"    alert(\'Please Enter Valid Date in MM/DD/YYYY Format\');\r\n                    " +
"                        $(this).datepicker(\"setDate\", new Date());\r\n            " +
"                                dateFlag = true;\r\n                              " +
"              return false;\r\n                                        }\r\n        " +
"                                else {\r\n                                        " +
"    if (new Date($(this).process($(this).val())).getTime() > new Date($(this).pr" +
"ocess($(\"#EndPeriod\").val())).getTime()) {\r\n                                    " +
"            alert(\'Start date must be less than End date.\');\r\n                  " +
"                              dateFlag = true;\r\n                                " +
"                $(this).datepicker(\"setDate\", new Date());\r\n                    " +
"                            return false;\r\n                                     " +
"       }\r\n                                        }\r\n                           " +
"         });\r\n\r\n                                    $.fn.process = function jQue" +
"ry$process(date) { var parts = date.split(\"/\"); return new Date(date); };\r\n     " +
"                               $(\"#EndPeriod\").change(function () {\r\n           " +
"                             if (!$(this).isValidDate($(this).val())) {\r\n       " +
"                                     alert(\'Please Enter Valid Date in MM/DD/YYY" +
"Y Format\'); $(this).datepicker(\"setDate\", new Date());\r\n                        " +
"                    dateFlag = true;\r\n                                          " +
"  return false;\r\n                                        }\r\n                    " +
"                    else {\r\n                                            if (new " +
"Date($(this).process($(this).val())).getTime() < new Date($(this).process($(\"#St" +
"artPeriod\").val())).getTime()) {\r\n                                              " +
"  alert(\'Start date must be less than End date.\');\r\n                            " +
"                    dateFlag = true;\r\n                                          " +
"      $(this).datepicker(\"setDate\", new Date());\r\n                              " +
"                  return false;\r\n                                            }\r\n" +
"                                        }\r\n                                    }" +
");\r\n\r\n                                    $(\"#StartPeriod,#EndPeriod\").keyup(fun" +
"ction (e) {\r\n                                        $(this).datepicker(\"hide\");" +
"\r\n                                        if (e.keyCode != 8) {\r\n               " +
"                             if ($(this).val().length == 2) {\r\n\r\n               " +
"                                 $(this).val($(this).val() + \"/\");\r\n\r\n          " +
"                                  }\r\n\r\n                                         " +
"   if ($(this).val().length == 5) {\r\n\r\n                                         " +
"       $(this).val($(this).val() + \"/\");\r\n\r\n                                    " +
"        }\r\n\r\n                                            if (dateFlag == false &" +
"& (!$(this).isValidDate($(this).val()))) {\r\n                                    " +
"            alert(\'Please Enter Valid date in MM/DD/YYYY Format\');\r\n            " +
"                                    $(this).datepicker(\"setDate\", $(this).datepi" +
"cker(\"getDate\"));\r\n                                                dateFlag = tr" +
"ue;\r\n                                                return false;\r\n\r\n          " +
"                                  }\r\n\r\n                                        }" +
"\r\n                                        dateFlag = true;\r\n                    " +
"                    return false;\r\n                                    });\r\n\r\n  " +
"                                  $(\"#StartPeriod,#EndPeriod\").keypress(function" +
" (e) {\r\n\r\n                                        var key;\r\n\r\n                  " +
"                      if (window.event)\r\n\r\n                                     " +
"       key = window.event.keyCode;     //IE\r\n\r\n                                 " +
"       else\r\n\r\n                                            key = e.which;     //" +
"firefox\r\n\r\n\r\n\r\n                                        if (key == 47) {\r\n\r\n     " +
"                                       return false;\r\n\r\n                        " +
"                }\r\n\r\n                                    });\r\n\r\n                " +
"                    $(function () {\r\n\r\n                                        $" +
".fn.isValidDate = function jQuery$isValidDate(date) {\r\n\r\n                       " +
"                     var reDate = /^(((((((0[13578])|(1[02]))[\\/]((0[1-9])|([12]" +
"\\d)|(3[01])))|(((0[469])|(11))[\\/]((0[1-9])|([12]\\d)|(30)))|((02)[\\/]((0[1-9])|(" +
"1\\d)|(2[0-8]))))[\\/](((19)|(20)|(21)|(22))([0-9][0-9]))))|((02)[\\/](29)[\\/](((19" +
")|(20)|(21)|(22))(([02468][048])|([13579][26])))))$/;\r\n                         " +
"                   return reDate.test(date);\r\n\r\n                                " +
"        };\r\n\r\n                                    });\r\n\r\n                       " +
"         </script>\r\n                            </td>\r\n                        <" +
"/tr>\r\n                    </table>\r\n                </div>\r\n                <br " +
"/>\r\n                <div>\r\n                    <div class=\"AgeBlock\">\r\n         " +
"               <div class=\"ui-groupbox\">\r\n                            <div class" +
"=\"ui-groupbox-header\">\r\n                                <span>Age Range</span></" +
"div>\r\n                            <table>\r\n                                <tr>\r" +
"\n                                    <td>\r\n                                     " +
"   <div class=\"ui-form\">\r\n                                            <div>\r\n   " +
"                                             <label class=\"Selections\">\r\n       " +
"                                             Min</label></div>\r\n                " +
"                        </div>\r\n                                    </td>\r\n     " +
"                               <td>\r\n                                        <di" +
"v class=\"ui-form\">\r\n                                            <div>\r\n         " +
"                                       <label class=\"Selections\">\r\n             " +
"                                       Max</label></div>\r\n                      " +
"                  </div>\r\n                                    </td>\r\n           " +
"                     </tr>\r\n                                <tr>\r\n              " +
"                      <td>");


            
            #line 198 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                   Write(Html.TextBoxFor(m => m.MinAge, new { @class = "AgeTextBox", id = "MinAge", maxlength = 3 }));

            
            #line default
            #line hidden
WriteLiteral("\r\n                                    </td>\r\n                                    " +
"<td>");


            
            #line 200 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                   Write(Html.TextBoxFor(m => m.MaxAge, new { @class = "AgeTextBox", id = "MaxAge", maxlength = 3 }));

            
            #line default
            #line hidden
WriteLiteral("\r\n                                    </td>\r\n                                </tr" +
">\r\n                                <script type=\"text/javascript\">              " +
"                      $(\"#MinAge,#MaxAge\").keypress(function (e) { if (e.which !" +
"= 8 && e.which != 0 && (e.which < 48 || e.which > 57)) { return false; } });\r\n\r\n" +
"                                    $(function () { $(\'input[id$=MinAge],input[i" +
"d$=MaxAge],input[id$=StartPeriod],input[id$=EndPeriod]\').bind(\'paste\', function " +
"(e) { e.preventDefault(); }); });\r\n\r\n                                </script>\r\n" +
"                            </table>\r\n                        </div>\r\n          " +
"          </div>\r\n                    <div class=\"SexBlock\">\r\n                  " +
"      <div class=\"ui-groupbox\">\r\n                            <div class=\"ui-grou" +
"pbox-header\">\r\n                                <span>Gender</span></div>\r\n      " +
"                      <table>\r\n                                <tr>\r\n           " +
"                         <td>\r\n                                        <div clas" +
"s=\"ui-form\">\r\n                                            <div>\r\n               " +
"                                 <label class=\"Selections\">\r\n                   " +
"                                 Sex</label></div>\r\n                            " +
"            </div>\r\n                                    </td>\r\n                 " +
"               </tr>\r\n                                <tr>\r\n                    " +
"                <td>\r\n                                        ");


            
            #line 227 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                   Write(Html.DropDownListFor(m => m.Sex, Model.SexSelections.Select(s => new SelectListItem { Text = s.CategoryText, Value = s.StratificationCategoryId.ToString() }), new { @class = "SexCheckBox" }));

            
            #line default
            #line hidden
WriteLiteral(@"
                                    </td>
                                </tr>
                            </table>
                        </div>
                    </div>
                    <br class=""clear"" />
                </div>
            </div>
            <div class=""RightParamBlock"">
                <div class=""ui-groupbox"">
                    <div class=""ui-groupbox-header"">
                        <span>Race Selector</span></div>
                    <div class=""Selections"">
                        ");


            
            #line 241 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                    Write(Html.Render<IGrid>().From(Model.RaceSelections).Id(r => r.StratificationCategoryId).CheckboxColumn("Race", "'0,1,2,3,4,5,6'").Column(i => i.CategoryText, "Race"));

            
            #line default
            #line hidden
WriteLiteral("\r\n                        <input type=\"hidden\" name=\"Race\" value=\"");


            
            #line 242 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                                           Write(Model.Race);

            
            #line default
            #line hidden
WriteLiteral(@"""/>
                    </div>
                </div>
            </div>

            <br class=""clear"" />
        </div>
        <div class=""Report"">
            <div class=""ui-groupbox"">
                <div class=""ui-groupbox-header"">
                    <span>Report Selector</span></div>
                <div class=""Selections"">
                    ");


            
            #line 254 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                Write(Html.Render<IGrid>()

                    .From(Model.ReportSelections)

                    .Id(r => r.Value)

                    .CheckboxColumn("Report", "'" + string.Join(",", Model.ReportSelections.Select(r => r.Value)) + "'")

                    .Column(i => i.Display, "Variable")

                    .Column(item => new System.Web.WebPages.HelperResult(__razor_template_writer => {

            
            #line default
            #line hidden

WriteLiteralTo(@__razor_template_writer, "\r\n");


            
            #line 265 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                     if (!item.SelectionList.NullOrEmpty())
                    {
            
            #line default
            #line hidden
WriteLiteralTo(@__razor_template_writer, "\r\n                        ");


            
            #line 267 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
WriteTo(@__razor_template_writer, Html.DropDownList(item.Name, item.SelectionList

                                        .Select(s => new SelectListItem { Text = s.CategoryText, Value = s.StratificationCategoryId.ToString() }), new { id = "ReportComboBoxes" }));

            
            #line default
            #line hidden
WriteLiteralTo(@__razor_template_writer, "\r\n                        ");


            
            #line 270 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                               }

            
            #line default
            #line hidden
WriteLiteralTo(@__razor_template_writer, "                    ");


            
            #line 271 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                         }), c => c.Title("Setting")

                    ));

            
            #line default
            #line hidden
WriteLiteral("\r\n                    <input type=\"hidden\" name=\"Report\" value=\"");


            
            #line 274 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                                         Write(Model.Report);

            
            #line default
            #line hidden
WriteLiteral("\"/>\r\n                    <input type=\"hidden\" name=\"AgeStratification\" value=\"");


            
            #line 275 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                                                    Write(Model.AgeStratification);

            
            #line default
            #line hidden
WriteLiteral("\"/>\r\n                    <input type=\"hidden\" name=\"PeriodStratification\" value=\"" +
"");


            
            #line 276 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                                                       Write(Model.PeriodStratification);

            
            #line default
            #line hidden
WriteLiteral("\"/>\r\n                    <input type=\"hidden\" name=\"ICD9Stratification\" value=\"");


            
            #line 277 "C:\Users\Daniel\Development\VSProjects\dns\trunk\Plugins\Lpp.Dns.HealthCare.Conditions\Views\Conditions\Create.cshtml"
                                                                     Write(Model.ICD9Stratification);

            
            #line default
            #line hidden
WriteLiteral("\"/>\r\n                </div>\r\n            </div>\r\n        </div>\r\n        <br clas" +
"s=\"clear\" />\r\n    </div>\r\n</div>\r\n\r\n\r\n");


        }
    }
}