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
    kendo.cultures["zh-SG"] = {
        name: "zh-SG",
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
                pattern: ["($n)","$n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "$"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["星期日","星期一","星期二","星期三","星期四","星期五","星期六"],
                    namesAbbr: ["周日","周一","周二","周三","周四","周五","周六"],
                    namesShort: ["日","一","二","三","四","五","六"]
                },
                months: {
                    names: ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月",""],
                    namesAbbr: ["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月",""]
                },
                AM: ["AM","am","AM"],
                PM: ["PM","pm","PM"],
                patterns: {
                    d: "d/M/yyyy",
                    D: "yyyy'年'M'月'd'日'",
                    F: "yyyy'年'M'月'd'日' tt h:mm:ss",
                    g: "d/M/yyyy tt h:mm",
                    G: "d/M/yyyy tt h:mm:ss",
                    m: "M'月'd'日'",
                    M: "M'月'd'日'",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "tt h:mm",
                    T: "tt h:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "yyyy'年'M'月'",
                    Y: "yyyy'年'M'月'"
                },
                "/": "/",
                ":": ":",
                firstDay: 0
            }
        }
    }
})(this);


return window.kendo;

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });