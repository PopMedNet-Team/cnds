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
    kendo.cultures["si"] = {
        name: "si",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ",",
            ".": ".",
            groupSize: [3,2],
            percent: {
                pattern: ["-n %","n %"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "%"
            },
            currency: {
                pattern: ["($ n)","$ n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3],
                symbol: "රු."
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["ඉරිදා","සඳුදා","අඟහරුවාදා","බදාදා","බ්‍රහස්පතින්දා","සිකුරාදා","සෙනසුරාදා"],
                    namesAbbr: ["ඉරිදා","සඳුදා","කුජදා","බුදදා","ගුරුදා","කිවිදා","ශනිදා"],
                    namesShort: ["ඉ","ස","අ","බ","බ්‍ර","සි","සෙ"]
                },
                months: {
                    names: ["ජනවාරි","පෙබරවාරි","මාර්තු","අ‌ප්‍රේල්","මැයි","ජූනි","ජූලි","අ‌ගෝස්තු","සැප්තැම්බර්","ඔක්තෝබර්","නොවැම්බර්","දෙසැම්බර්",""],
                    namesAbbr: ["ජන.","පෙබ.","මාර්තු.","අප්‍රේල්.","මැයි.","ජූනි.","ජූලි.","අගෝ.","සැප්.","ඔක්.","නොවැ.","දෙසැ.",""]
                },
                AM: ["පෙ.ව.","පෙ.ව.","පෙ.ව."],
                PM: ["ප.ව.","ප.ව.","ප.ව."],
                patterns: {
                    d: "yyyy-MM-dd",
                    D: "yyyy MMMM' මස 'dd' වැනිදා 'dddd",
                    F: "yyyy MMMM' මස 'dd' වැනිදා 'dddd h:mm:ss tt",
                    g: "yyyy-MM-dd h:mm tt",
                    G: "yyyy-MM-dd h:mm:ss tt",
                    m: "MMMM dd",
                    M: "MMMM dd",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "h:mm tt",
                    T: "h:mm:ss tt",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "yyyy MMMM",
                    Y: "yyyy MMMM"
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