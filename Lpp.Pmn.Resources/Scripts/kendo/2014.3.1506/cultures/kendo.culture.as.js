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
    kendo.cultures["as"] = {
        name: "as",
        numberFormat: {
            pattern: ["-n"],
            decimals: 2,
            ",": ",",
            ".": ".",
            groupSize: [3,2],
            percent: {
                pattern: ["-n%","n%"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "%"
            },
            currency: {
                pattern: ["$ -n","n$"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "ট"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["সোমবাৰ","মঙ্গলবাৰ","বুধবাৰ","বৃহস্পতিবাৰ","শুক্রবাৰ","শনিবাৰ","ৰবিবাৰ"],
                    namesAbbr: ["সোম.","মঙ্গল.","বুধ.","বৃহ.","শুক্র.","শনি.","ৰবি."],
                    namesShort: ["সো","ম","বু","বৃ","শু","শ","র"]
                },
                months: {
                    names: ["জানুৱাৰী","ফেব্রুৱাৰী","মার্চ","এপ্রিল","মে","জুন","জুলাই","আগষ্ট","চেপ্টেম্বর","অক্টোবর","নবেম্বর","ডিচেম্বর",""],
                    namesAbbr: ["জানু","ফেব্রু","মার্চ","এপ্রিল","মে","জুন","জুলাই","আগষ্ট","চেপ্টে","অক্টো","নবে","ডিচে",""]
                },
                AM: ["ৰাতিপু","ৰাতিপু","ৰাতিপু"],
                PM: ["আবেলি","আবেলি","আবেলি"],
                patterns: {
                    d: "dd-MM-yyyy",
                    D: "yyyy,MMMM dd, dddd",
                    F: "yyyy,MMMM dd, dddd tt h:mm:ss",
                    g: "dd-MM-yyyy tt h:mm",
                    G: "dd-MM-yyyy tt h:mm:ss",
                    m: "dd MMMM",
                    M: "dd MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "tt h:mm",
                    T: "tt h:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM,yy",
                    Y: "MMMM,yy"
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