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
    kendo.cultures["ug-CN"] = {
        name: "ug-CN",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ",",
            ".": ".",
            groupSize: [3],
            percent: {
                pattern: ["-n%","n%"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["$-n","$n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "¥"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["يەكشەنبە","دۈشەنبە","سەيشەنبە","چارشەنبە","پەيشەنبە","جۈمە","شەنبە"],
                    namesAbbr: ["يە","دۈ","سە","چا","پە","جۈ","شە"],
                    namesShort: ["ي","د","س","چ","پ","ج","ش"]
                },
                months: {
                    names: ["1-ئاي","2-ئاي","3-ئاي","4-ئاي","5-ئاي","6-ئاي","7-ئاي","8-ئاي","9-ئاي","10-ئاي","11-ئاي","12-ئاي",""],
                    namesAbbr: ["1-ئاي","2-ئاي","3-ئاي","4-ئاي","5-ئاي","6-ئاي","7-ئاي","8-ئاي","9-ئاي","10-ئاي","11-ئاي","12-ئاي",""]
                },
                AM: ["چۈشتىن بۇرۇن","چۈشتىن بۇرۇن","چۈشتىن بۇرۇن"],
                PM: ["چۈشتىن كېيىن","چۈشتىن كېيىن","چۈشتىن كېيىن"],
                patterns: {
                    d: "yyyy-M-d",
                    D: "yyyy-'يىلى' MMMM d-'كۈنى،'",
                    F: "yyyy-'يىلى' MMMM d-'كۈنى،' H:mm:ss",
                    g: "yyyy-M-d H:mm",
                    G: "yyyy-M-d H:mm:ss",
                    m: "MMMM d'-كۈنى'",
                    M: "MMMM d'-كۈنى'",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "yyyy-'يىلى' MMMM",
                    Y: "yyyy-'يىلى' MMMM"
                },
                "/": "-",
                ":": ":",
                firstDay: 0
            }
        }
    }
})(this);


return window.kendo;

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });