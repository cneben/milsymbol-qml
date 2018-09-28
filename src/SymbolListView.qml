import QtQuick          2.11
import QtQuick.Layouts  1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' as Milsymbol

ListView {
    id: symbolListView
    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.margins: 0
    clip: true
    spacing: 2

    property color  hilightColor: "lightblue"
    property real   hilightRadius: 2
    property real   hilightOpacity: 0.6

    highlightFollowsCurrentItem: false
    highlight: Rectangle {
        id: hilightRectangle
        x: symbolListView.currentItem ? symbolListView.currentItem.x : 0
        y: symbolListView.currentItem ? symbolListView.currentItem.y : 0
        width: symbolListView.currentItem ? symbolListView.currentItem.width : 0
        height: symbolListView.currentItem ? symbolListView.currentItem.height : 0

        color: symbolListView.hilightColor
        opacity: symbolListView.hilightOpacity
        radius: symbolListView.hilightRadius

        Behavior on x { SpringAnimation { duration: 150; spring: 1.8; damping: 0.12 } }
        Behavior on y { SpringAnimation { duration: 150; spring: 1.8; damping: 0.12 } }
    }
    property string codingScheme: 'WAR'
    property string battleDimension: battleDimensionSelector.dimension
    //! Actually selected symbol letter code (default to Infantry of course!).
    property string symbol: 'SFGPUCI-----'

    model: Milsymbol.Ms.std2525c[codingScheme][battleDimension]['main icon']
    delegate: Item {
        width: symbolListView.width
        height: 32
        MouseArea {
            anchors.fill: parent;
            onClicked: {
                symbolListView.currentIndex = index
                symbolListView.symbol = letterCode
            }
        }
        property string letterCode: modelData['code scheme'] + 'F' + battleDimensionSelector.dimensionCode + modelData.code + "--"
        property var    symbol: new Milsymbol.Ms.Symbol(letterCode, {size: 30, fill: true});
        RowLayout {
            id: unitRow
            anchors.fill: parent
            Image {
                source: "data:image/svg+xml;utf8," + symbol.asSVG()
                fillMode: Image.PreserveAspectFit
            }
            Text {
                Layout.fillWidth: true
                text: modelData.hierarchy
                wrapMode: Text.WordWrap
                width: parent.width
                color: index % 2 == 0 ? "darkgreen" : "brown"
            }
        }
    } // Delegate item
} // ListView symbolListView
