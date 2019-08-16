import QtQuick          2.11
import QtQuick.Layouts  1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' as Milsymbol

/*! \brief Visual milsymbol selector.
 *
 * Symbol selector for part of 'SGGPUCI-----'
 *                             'ABCDEFGHIJKL'
 *  [Index]
 *  [0]    'A'     : 'code scheme'
 *  [1]    'B'     : 'affiliationCode'  (Ex: 'H'/Hostile, 'F'/Friend)
 *  [2,3]  'CD'    : 'battleDimensionCode'  (Ex: 'GP'/GRDTRK_UNT, 'FP'/SOFUNT)
 *  [4,9]  'EFGHIJ': unit code ('UCI---'/Infantry...)
 *  [10]   'K'     : modifier 1
 *  [11]   'L'     : modifier 2 ('-'/Unspecified, 'C'/Section)
 *
 * \note symbolSelected() signal is emitted when a symbol is double clicked.
 */
ListView {
    id: symbolListView
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 0
    clip: true
    spacing: 4

    property color  hilightColor: "lightblue"
    property real   hilightRadius: 2
    property real   hilightOpacity: 0.6

    ScrollBar.vertical: ScrollBar {
        active: true
    }

    signal symbolCodeSelected(var symbolCode)

    highlightFollowsCurrentItem: false
    highlight: Rectangle {
        id: hilightRectangle
        x: symbolListView.currentItem ? symbolListView.currentItem.x : 0
        y: symbolListView.currentItem ? symbolListView.currentItem.y : 0
        z: 12
        width: symbolListView.currentItem ? symbolListView.currentItem.width : 0
        height: symbolListView.currentItem ? symbolListView.currentItem.height : 0

        border.color: symbolListView.hilightColor
        border.width: 3.0
        color: Qt.rgba(0, 0, 0, 0)
        opacity: symbolListView.hilightOpacity
        radius: symbolListView.hilightRadius

        Behavior on x { SpringAnimation { duration: 150; spring: 1.8; damping: 0.12 } }
        Behavior on y { SpringAnimation { duration: 150; spring: 1.8; damping: 0.12 } }
    }
    property string codingScheme: 'WAR'

    property string battleDimension: 'GRDTRK_UNT'
    property string battleDimensionCode: 'GP'

    property string affiliationCode: 'F'
    onAffiliationCodeChanged: forceLayout()

    //! Actually selected symbol letter code (default to Infantry of course!).
    property string symbolCode: 'UCI---'
    onSymbolCodeChanged: updateCurrentIndex()
    /*{
        // Eventually update  battleDimenion and affiliationCode
        if (symbol.length === 12) {
            if (affiliationCode !== symbol[1])
                affiliationCode = symbol[1]
            if (battleDimensionCode !== symbol[2] + symbol[3])
                battleDimensionCode = symbol[2] + symbol[3]
            updateCurrentIndex()
        }
    }*/

    function updateCurrentIndex()
    {
        //console.error('updateCurrentIndex(): currentIndex=' + currentIndex + '   symbol=' + symbol)
        //console.error('  affiliationCode=' + affiliationCode)
        //console.error('  battleDimensionCode=' + battleDimensionCode)

        if (!model)
            return;
        if (!symbolCode ||
             symbolCode.length !== 6)
            return;

        // Fast exit: if currentIndex is already up to date, exit fast
        if (currentIndex >= 0) {
            let currentModelItem = model[currentIndex]
            //let currentCode = currentModelItem['code scheme'] + symbolListView.affiliationCode +
            //                                                    symbolListView.battleDimensionCode +
            //                                                    currentModelItem.code + "--"
            if (symbolCode === currentModelItem.code)
                return;
        }

        //let symbolCode = symbol[4] + symbol[5] + symbol[6] + symbol[7] + symbol[8] + symbol[9]
        // Otherwise, look for the correct index
        for (let s = 0; s < model.length; s++) {
            let code = model[s]
            if (code &&
                code.code === symbolCode) {
                currentIndex = s;
                break;
            }
        }
        //console.error('currentIndex=' + currentIndex)
    }

    model: Milsymbol.Ms.std2525c[codingScheme][battleDimension]['main icon']
    onModelChanged: {
        updateCurrentIndex()
    }
    delegate: Item {
        width: symbolListView.width
        height: 32
        property string symbol: modelData['code scheme'] + symbolListView.affiliationCode +
                                                           symbolListView.battleDimensionCode +
                                                           modelData.code + "--"
        property var    svgSymbol: new Milsymbol.Ms.Symbol(symbol, {size: 30, fill: true});
        Rectangle { // Hilight currently selected symbol
            anchors.fill: parent
            color: symbolListView.hilightColor
            opacity: symbolListView.hilightOpacity
            radius: symbolListView.hilightRadius
            visible: symbolListView.symbolCode === modelData.code
        }
        RowLayout {
            id: unitRow
            anchors.fill: parent
            anchors.margins: 2
            Image {
                Layout.fillWidth: false
                Layout.fillHeight: true
                source: "data:image/svg+xml;utf8," + svgSymbol.asSVG()
                fillMode: Image.PreserveAspectFit
            }
            Label {
                Layout.fillWidth: true
                text: modelData.hierarchy
                wrapMode: Text.WordWrap
                width: parent.width
            }
        }
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                symbolListView.currentIndex = index
            }
            onDoubleClicked: {
                symbolListView.currentIndex = index
                symbolListView.symbolCode = modelData.code
                symbolListView.symbolCodeSelected(modelData.code)
            }
        }
    } // Delegate item
} // ListView symbolListView
