import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' 1.0
//import 'qrc:/milsymbol.js' as Ms

Window {
    id: window
    visible: true
    width: 900; height: 550
    title: qsTr("Milsymbol.js QML Demo")

    property var mainSymbol: new Ms.Symbol(symbolListView.symbol, {
        size: 100,
        fill: true
    });

    RowLayout {
        anchors.fill: parent
        Image {
            Layout.fillWidth: true
            Layout.fillHeight: true
            source: "data:image/svg+xml;utf8," + window.mainSymbol.asSVG();
            sourceSize: "400x400"
            fillMode: Image.PreserveAspectFit
        }

        // Main milsymbol unit generation control
        Control {
            Layout.fillWidth: false
            Layout.preferredWidth: 350
            Layout.fillHeight: true
            ColumnLayout {
                anchors.fill: parent
                ComboBox {
                    id: battleDimensionSelector
                    Layout.fillWidth: true; Layout.fillHeight: false
                    Layout.margins: 0
                    padding: 0

                    property string dimension: 'GRDTRK_UNT'
                    property string dimensionCode: 'GP'

                    textRole: "label"
                    ListModel {
                        id: warFightingModel
                        ListElement { label: "Ground Unit";               dimension: "GRDTRK_UNT"; rootSymbol: "SFGPU-------"; code: "GP" }
                        ListElement { label: "Space";                     dimension: "SPC";        rootSymbol: "SFPP--------"; code: "PP" }
                        ListElement { label: "Air";                       dimension: "AIRTRK";     rootSymbol: "SFAP--------"; code: "AP" }
                        ListElement { label: "Ground Equipment";          dimension: "GRDTRK_EQT"; rootSymbol: "SFGPE-------"; code: "GP" }
                        ListElement { label: "Ground Installation";       dimension: "GRDTRK_INS"; rootSymbol: "SFGPI-----H-"; code: "GP" }
                        ListElement { label: "Sea Surface";               dimension: "SSUF";       rootSymbol: "SFSP--------"; code: "SP" }
                        ListElement { label: "Subsurface";                dimension: "SBSUF";      rootSymbol: "SFUP--------"; code: "UP" }
                        ListElement { label: "Special Operations Forces"; dimension: "SOFUNT";     rootSymbol: "SFFP--------"; code: "FP" }
                    }
                    model : warFightingModel
                    delegate: ItemDelegate {
                        width: parent.width
                        property var symbol: new Ms.Symbol(warFightingModel.get(index).rootSymbol, {size: 32, fill: true});
                        RowLayout {
                            anchors.fill: parent
                            Image {
                                Layout.margins: 2
                                Layout.preferredWidth: 32
                                source: "data:image/svg+xml;utf8," + symbol.asSVG()
                                fillMode: Image.PreserveAspectFit
                            }
                            Text {
                                Layout.fillWidth: true
                                text: warFightingModel.get(index).label
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    onActivated: {
                        if (index !== -1) {
                            battleDimensionSelector.dimension = warFightingModel.get(index).dimension
                            battleDimensionSelector.dimensionCode = warFightingModel.get(index).code
                        }
                    }
                }
                ListView {
                    id: symbolListView
                    Layout.fillWidth: true; Layout.fillHeight: true; Layout.margins: 0
                    clip: true; spacing: 2

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

                    model: Ms.std2525c[codingScheme][battleDimension]['main icon']
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
                        property var    symbol: new Ms.Symbol(letterCode, {size: 30, fill: true});
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
            }
        } // Unit symbol generation main control
    } // Main RowLayout
}
