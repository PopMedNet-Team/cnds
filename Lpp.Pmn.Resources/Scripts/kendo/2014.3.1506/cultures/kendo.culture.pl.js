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
    kendo.cultures["pl"] = {
        name: "pl",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": " ",
            ".": ",",
            groupSize: [3],
            percent: {
                pattern: ["-n%","n%"],
                decimals: 2,
                ",": " ",
                ".": ",",
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["-n $","n $"],
                decimals: 2,
                ",": " ",
                ".": ",",
                groupSize: [3],
                symbol: "zł"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["niedziela","poniedziałek","wtorek","środa","czwartek","piątek","sobota"],
                    namesAbbr: ["N","Pn","Wt","Śr","Cz","Pt","So"],
                    namesShort: ["N","Pn","Wt","Śr","Cz","Pt","So"]
                },
                months: {
                    names: ["styczeń","luty","marzec","kwiecień","maj","czerwiec","lipiec","sierpień","wrzesień","październik","listopad","grudzień",""],
                    namesAbbr: ["sty","lut","mar","kwi","maj","cze","lip","sie","wrz","paź","lis","gru",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "yyyy-MM-dd",
                    D: "d MMMM yyyy",
                    F: "d MMMM yyyy HH:mm:ss",
                    g: "yyyy-MM-dd HH:mm",
                    G: "yyyy-MM-dd HH:mm:ss",
                    m: "d MMMM",
                    M: "d MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "HH:mm",
                    T: "HH:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM yyyy",
                    Y: "MMMM yyyy"
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