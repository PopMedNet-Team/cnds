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
    kendo.cultures["ba-RU"] = {
        name: "ba-RU",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": " ",
            ".": ",",
            groupSize: [3,0],
            percent: {
                pattern: ["-n%","n%"],
                decimals: 2,
                ",": " ",
                ".": ",",
                groupSize: [3,0],
                symbol: "%"
            },
            currency: {
                pattern: ["-n $","n $"],
                decimals: 2,
                ",": " ",
                ".": ",",
                groupSize: [3,0],
                symbol: "һ."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["Йәкшәмбе","Дүшәмбе","Шишәмбе","Шаршамбы","Кесаҙна","Йома","Шәмбе"],
                    namesAbbr: ["Йш","Дш","Шш","Шр","Кс","Йм","Шб"],
                    namesShort: ["Йш","Дш","Шш","Шр","Кс","Йм","Шб"]
                },
                months: {
                    names: ["ғинуар","февраль","март","апрель","май","июнь","июль","август","сентябрь","октябрь","ноябрь","декабрь",""],
                    namesAbbr: ["ғин","фев","мар","апр","май","июн","июл","авг","сен","окт","ноя","дек",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "dd.MM.yy",
                    D: "d MMMM yyyy 'й'",
                    F: "d MMMM yyyy 'й' H:mm:ss",
                    g: "dd.MM.yy H:mm",
                    G: "dd.MM.yy H:mm:ss",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM yyyy",
                    Y: "MMMM yyyy"
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