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
    kendo.cultures["nl"] = {
        name: "nl",
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
                pattern: ["$ -n","$ n"],
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
                    names: ["zondag","maandag","dinsdag","woensdag","donderdag","vrijdag","zaterdag"],
                    namesAbbr: ["zo","ma","di","wo","do","vr","za"],
                    namesShort: ["zo","ma","di","wo","do","vr","za"]
                },
                months: {
                    names: ["januari","februari","maart","april","mei","juni","juli","augustus","september","oktober","november","december",""],
                    namesAbbr: ["jan","feb","mrt","apr","mei","jun","jul","aug","sep","okt","nov","dec",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "d-M-yyyy",
                    D: "dddd d MMMM yyyy",
                    F: "dddd d MMMM yyyy H:mm:ss",
                    g: "d-M-yyyy H:mm",
                    G: "d-M-yyyy H:mm:ss",
                    m: "dd MMMM",
                    M: "dd MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
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