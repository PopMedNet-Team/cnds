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
    kendo.cultures["tk-TM"] = {
        name: "tk-TM",
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
                pattern: ["-n$","n$"],
                decimals: 2,
                ",": " ",
                ".": ",",
                groupSize: [3],
                symbol: "m."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["Duşenbe","Sişenbe","Çarşenbe","Penşenbe","Anna","Şenbe","Ýekşenbe"],
                    namesAbbr: ["Db","Sb","Çb","Pb","An","Şb","Ýb"],
                    namesShort: ["D","S","Ç","P","A","Ş","Ý"]
                },
                months: {
                    names: ["Ýanwar","Fewral","Mart","Aprel","Maý","lýun","lýul","Awgust","Sentýabr","Oktýabr","Noýabr","Dekabr",""],
                    namesAbbr: ["Ýan","Few","Mart","Apr","Maý","lýun","lýul","Awg","Sen","Okt","Not","Dek",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "dd.MM.yy",
                    D: "yyyy 'ý.' MMMM d",
                    F: "yyyy 'ý.' MMMM d H:mm:ss",
                    g: "dd.MM.yy H:mm",
                    G: "dd.MM.yy H:mm:ss",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "yyyy 'ý.' MMMM",
                    Y: "yyyy 'ý.' MMMM"
                },
                "/": ".",
                ":": ":",
                firstDay: 1
            }
        }
    }
})(this);


return window.kendo;

}, typeof define == 'function' && define.amd ? define : function(_, f){ f(); });