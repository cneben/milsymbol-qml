.pragma library
Qt.include("qrc:/Milsymbol/milsymbol.development.js")
Qt.include("qrc:/Milsymbol/milstd.js")


var std2525c = milstd.ms2525c
var ms = this.ms
var addIcons = this.ms.addIcons
var Symbol = this.ms.Symbol


/*! Return a symbol code for \c symbolCode with \symbol2Modifier applied (ie modifier applied at symbol letter 12)
 *
 *  [Index]
 *  [0]    'A'     : 'code scheme' (fixed to S/Warfighting in milsymbol-qml...)
 *  [1]    'B'     : 'affiliationCode'  (Ex: 'H'/Hostile, 'F'/Friend)
 *  [2,3]  'CD'    : 'battleDimensionCode'  (Ex: 'GP'/GRDTRK_UNT, 'FP'/SOFUNT)
 *  [4,9]  'EFGHIJ': unit code ('UCI---'/Infantry...)
 *  [10]   'K'     : modifier 1
 *  [11]   'L'     : modifier 2 ('-'/Unspecified, 'C'/Section)
 */
function generateSymbol(affiliationCode,
                        battleDimensionCode,
                        symbolCode,
                        modifier2Code) {
    // Note: warning string are immutable in JS, do not use mystr[index] to replace characters...
    //console.error('generateSymbol():' )
    //console.error('    affiliationCode=' + affiliationCode)
    //console.error('    dimensionCode=  ' + battleDimensionCode)
    //console.error('    symbolCode=     ' + symbolCode)
    //console.error('    modifier2Code=  ' + modifier2Code)

    var codeScheme = 'S'    // Fixed to 'S'
    var symbol = 'S-----------'

    if (codeScheme.length !== 1             &&
        affiliationCode.length !== 1        &&
        battleDimensionCode.length !== 2    &&
        symbolCode.length !== 6             &&
        modifier2Code.length !== 1)
        return symbol;

    symbol = codeScheme[0]          +   // [0]
             affiliationCode[0]     +   // [1]
             battleDimensionCode[0] +   // [2]
             battleDimensionCode[1] +   // [3]
             symbolCode[0]          +   // [4]
             symbolCode[1]          +   // [5]
             symbolCode[2]          +   // [6]
             symbolCode[3]          +   // [7]
             symbolCode[4]          +   // [8]
             symbolCode[5]          +   // [9]
             '-'                    +   // [10]
             modifier2Code[0]           // [11]

    //console.error('    (return) symbol=' + symbol)
    return symbol
}
