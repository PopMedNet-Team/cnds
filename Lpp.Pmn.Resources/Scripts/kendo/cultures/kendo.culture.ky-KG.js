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
    kendo.cultures["ky-KG"] = {
        name: "ky-KG",
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
                ".": "-",
                groupSize: [3],
                symbol: "сом"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["Жекшемби","Дүйшөмбү","Шейшемби","Шаршемби","Бейшемби","Жума","Ишемби"],
                    namesAbbr: ["Жш","Дш","Шш","Шр","Бш","Жм","Иш"],
                    namesShort: ["Жш","Дш","Шш","Шр","Бш","Жм","Иш"]
                },
                months: {
                    names: ["Январь","Февраль","Март","Апрель","Май","Июнь","Июль","Август","Сентябрь","Октябрь","Ноябрь","Декабрь",""],
                    namesAbbr: ["Янв","Фев","Мар","Апр","Май","Июн","Июл","Авг","Сен","Окт","Ноя","Дек",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "dd.MM.yy",
                    D: "d'-'MMMM yyyy'-ж.'",
                    F: "d'-'MMMM yyyy'-ж.' H:mm:ss",
                    g: "dd.MM.yy H:mm",
                    G: "dd.MM.yy H:mm:ss",
                    m: "d MMMM",
                    M: "d MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM yyyy'-ж.'",
                    Y: "MMMM yyyy'-ж.'"
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