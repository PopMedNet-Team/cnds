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
    kendo.cultures["az-Cyrl-AZ"] = {
        name: "az-Cyrl-AZ",
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
                symbol: "ман."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["Базар","Базар ертәси","Чәршәнбә ахшамы","Чәршәнбә","Ҹүмә ахшамы","Ҹүмә","Шәнбә"],
                    namesAbbr: ["Б","Бе","Ча","Ч","Ҹа","Ҹ","Ш"],
                    namesShort: ["Б","Бе","Ча","Ч","Ҹа","Ҹ","Ш"]
                },
                months: {
                    names: ["Јанвар","Феврал","Март","Апрел","Мај","Ијун","Ијул","Август","Сентјабр","Октјабр","Нојабр","Декабр",""],
                    namesAbbr: ["Јан","Фев","Мар","Апр","Мај","Ијун","Ијул","Авг","Сен","Окт","Ноя","Дек",""]
                },
                AM: [""],
                PM: [""],
                patterns: {
                    d: "dd.MM.yyyy",
                    D: "d MMMM yyyy",
                    F: "d MMMM yyyy H:mm:ss",
                    g: "dd.MM.yyyy H:mm",
                    G: "dd.MM.yyyy H:mm:ss",
                    m: "d MMMM",
                    M: "d MMMM",
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