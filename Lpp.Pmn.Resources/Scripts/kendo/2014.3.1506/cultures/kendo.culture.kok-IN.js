/*
* Kendo UI v2014.3.1506 (http://www.telerik.com/kendo-ui)
* Copyright 2015 Telerik AD. All rights reserved.
*
* Kendo UI commercial licenses may be obtained at
* http://www.telerik.com/purchase/license-agreement/kendo-ui-complete
* If you do not own a commercial license, this file shall be governed by the trial license terms.
*/
(function(f, define){
    define([], f);
})(function(){

(function( window, undefined ) {
    var kendo = window.kendo || (window.kendo = { cultures: {} });
    kendo.cultures["kok-IN"] = {
        name: "kok-IN",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ",",
            ".": ".",
            groupSize: [3,2],
            percent: {
                pattern: ["-n %","n %"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "%"
            },
            currency: {
                pattern: ["$ -n","$ n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "रु"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["आयतार","सोमार","मंगळार","बुधवार","बिरेस्तार","सुक्रार","शेनवार"],
                    namesAbbr: ["आय.","सोम.","मंगळ.","बुध.","बिरे.","सुक्र.","शेन."],
                    namesShort: ["आ","स","म","ब","ब","स","श"]
                },
                months: {
                    names: ["जानेवारी","फेब्रुवारी","मार्च","एप्रिल","मे","जून","जुलै","ऑगस्ट","सप्टेंबर","ऑक्टोबर","नोवेम्बर","डिसेंबर",""],
                    namesAbbr: ["जानेवारी","फेब्रुवारी","मार्च","एप्रिल","मे","जून","जुलै","ऑगस्ट","सप्टेंबर","ऑक्टोबर","नोवेम्बर","डिसेंबर",""]
                },
                AM: ["म.पू.","म.पू.","म.पू."],
                PM: ["म.नं.","म.नं.","म.नं."],
                patterns: {
                    d: "dd-MM-yyyy",
                    D: "dd MMMM yyyy",
                    F: "dd MMMM yyyy HH:mm:ss",
                    g: "dd-MM-yyyy HH:mm",
                    G: "dd-MM-yyyy HH:mm:ss",
                    m: "dd MMMM",
                    M: "dd MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "HH:mm",
                    T: "HH:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM, yyyy",
                    Y: "MMMM, yyyy"
                },
                "/": "-",
                ":": ":",
                firstDay: 1
            }
        }
    }
})(this);


return window.kendo;

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });