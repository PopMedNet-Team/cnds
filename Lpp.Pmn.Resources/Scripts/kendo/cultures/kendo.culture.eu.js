/*
* Kendo UI v2014.2.718 (http://www.telerik.com/kendo-ui)
* Copyright 2014 Telerik AD. All rights reserved.
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
    kendo.cultures["eu"] = {
        name: "eu",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ".",
            ".": ",",
            groupSize: [3],
            percent: {
                pattern: ["-n %","n %"],
                decimals: 2,
                ",": ".",
                ".": ",",
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["-n $","n $"],
                decimals: 2,
                ",": ".",
                ".": ",",
                groupSize: [3],
                symbol: "€"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["igandea","astelehena","asteartea","asteazkena","osteguna","ostirala","larunbata"],
                    namesAbbr: ["ig.","al.","as.","az.","og.","or.","lr."],
                    namesShort: ["ig","al","as","az","og","or","lr"]
                },
                months: {
                    names: ["urtarrila","otsaila","martxoa","apirila","maiatza","ekaina","uztaila","abuztua","iraila","urria","azaroa","abendua",""],
                    namesAbbr: ["urt.","ots.","mar.","api.","mai.","eka.","uzt.","abu.","ira.","urr.","aza.","abe.",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "yyyy/MM/dd",
                    D: "dddd, yyyy.'eko' MMMM'k 'd",
                    F: "dddd, yyyy.'eko' MMMM'k 'd H:mm:ss",
                    g: "yyyy/MM/dd HH:mm",
                    G: "yyyy/MM/dd H:mm:ss",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "HH:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "yyyy.'eko' MMMM",
                    Y: "yyyy.'eko' MMMM"
                },
                "/": "/",
                ":": ":",
                firstDay: 1
            }
        }
    }
})(this);


return window.kendo;

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });