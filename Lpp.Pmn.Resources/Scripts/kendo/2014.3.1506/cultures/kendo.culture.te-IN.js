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
    kendo.cultures["te-IN"] = {
        name: "te-IN",
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
                pattern: ["$ -n","$ n"],
                decimals: 2,
                ",": ",",
                ".": ".",
                groupSize: [3,2],
                symbol: "రూ"
            }
        },
        calendars: {
            standard: {
                days: {
                    names: ["ఆదివారం","సోమవారం","మంగళవారం","బుధవారం","గురువారం","శుక్రవారం","శనివారం"],
                    namesAbbr: ["ఆది.","సోమ.","మంగళ.","బుధ.","గురు.","శుక్ర.","శని."],
                    namesShort: ["ఆ","సో","మం","బు","గు","శు","శ"]
                },
                months: {
                    names: ["జనవరి","ఫిబ్రవరి","మార్చి","ఏప్రిల్","మే","జూన్","జూలై","ఆగస్టు","సెప్టెంబర్","అక్టోబర్","నవంబర్","డిసెంబర్",""],
                    namesAbbr: ["జనవరి","ఫిబ్రవరి","మార్చి","ఏప్రిల్","మే","జూన్","జూలై","ఆగస్టు","సెప్టెంబర్","అక్టోబర్","నవంబర్","డిసెంబర్",""]
                },
                AM: ["పూర్వాహ్న","పూర్వాహ్న","పూర్వాహ్న"],
                PM: ["అపరాహ్న","అపరాహ్న","అపరాహ్న"],
                patterns: {
                    d: "dd-MM-yy",
                    D: "dd MMMM yyyy",
                    F: "dd MMMM yyyy HH:mm:ss",
                    g: "dd-MM-yy HH:mm",
                    G: "dd-MM-yy HH:mm:ss",
                    m: "dd MMMM",
                    M: "dd MMMM",
                    s: "yyyy'-'MM'-'dd'T'HH':'mm':'ss",
                    t: "HH:mm",
                    T: "HH:mm:ss",
                    u: "yyyy'-'MM'-'dd HH':'mm':'ss'Z'",
                    y: "MMMM, yyyy",
                    Y: "MMMM, yyyy"
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