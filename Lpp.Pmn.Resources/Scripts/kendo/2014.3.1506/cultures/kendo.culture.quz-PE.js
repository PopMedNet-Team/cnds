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
    kendo.cultures["quz-PE"] = {
        name: "quz-PE",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ",",
            ".": ".",
            groupSize: [3],
            percent: {
                pattern: ["-%n","%n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "%"
            },
            currency: {
                pattern: ["$ -n","$ n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "S/."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["intichaw","killachaw","atipachaw","quyllurchaw","Ch\u0027 askachaw","Illapachaw","k\u0027uychichaw"],
                    namesAbbr: ["int","kil","ati","quy","Ch\u0027","Ill","k\u0027u"],
                    namesShort: ["d","k","a","m","h","b","k"]
                },
                months: {
                    names: ["Qulla puquy","Hatun puquy","Pauqar waray","ayriwa","Aymuray","Inti raymi","Anta Sitwa","Qhapaq Sitwa","Uma raymi","Kantaray","Ayamarq\u0027a","Kapaq Raymi",""],
                    namesAbbr: ["Qul","Hat","Pau","ayr","Aym","Int","Ant","Qha","Uma","Kan","Aya","Kap",""]
                },
                AM: ["a.m.","a.m.","A.M."],
                PM: ["p.m.","p.m.","P.M."],
                patterns: {
                    d: "dd/MM/yyyy",
                    D: "dddd, dd' de 'MMMM' de 'yyyy",
                    F: "dddd, dd' de 'MMMM' de 'yyyy hh:mm:ss tt",
                    g: "dd/MM/yyyy hh:mm tt",
                    G: "dd/MM/yyyy hh:mm:ss tt",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "hh:mm tt",
                    T: "hh:mm:ss tt",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM' de 'yyyy",
                    Y: "MMMM' de 'yyyy"
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