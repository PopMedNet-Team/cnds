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
    kendo.cultures["sah-RU"] = {
        name: "sah-RU",
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
                symbol: "с."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["баскыһыанньа","бэнидиэнньик","оптуорунньук","сэрэдэ","чэппиэр","бээтинсэ","субуота"],
                    namesAbbr: ["Бс","Бн","Оп","Ср","Чп","Бт","Сб"],
                    namesShort: ["Бс","Бн","Оп","Ср","Чп","Бт","Сб"]
                },
                months: {
                    names: ["Тохсунньу","Олунньу","Кулун тутар","Муус устар","Ыам ыйа","Бэс ыйа","От ыйа","Атырдьах ыйа","Балаҕан ыйа","Алтынньы","Сэтинньи","Ахсынньы",""],
                    namesAbbr: ["тхс","олн","кул","мст","ыам","бэс","отй","атр","блҕ","алт","стн","ахс",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "MM.dd.yyyy",
                    D: "MMMM d yyyy 'с.'",
                    F: "MMMM d yyyy 'с.' H:mm:ss",
                    g: "MM.dd.yyyy H:mm",
                    G: "MM.dd.yyyy H:mm:ss",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "H:mm",
                    T: "H:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM yyyy 'с.'",
                    Y: "MMMM yyyy 'с.'"
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