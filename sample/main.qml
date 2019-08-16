import QtQuick 2.11
import QtQuick.Window 2.11
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' 1.0 as Milsymbol

Window {
    id: window
    visible: true
    width: 900; height: 550
    title: qsTr("Milsymbol.js QML Demo")

    function updateSymbol(affiliationCode,
                          dimensionCode,
                          symbolCode,
                          modifier2Code) {
        symbol = Milsymbol.Ms.generateSymbol(affiliationCode,
                                               dimensionCode,
                                               symbolCode,
                                               modifier2Code)
    }

    property var symbol: 'SFGPUCI-----'
    onSymbolChanged: {
        if (symbol.length === 12) {       // Update the visual selectors
            affiliationSelector.affiliationCode     = symbol[1]
            battleDimensionSelector.dimensionCode   = symbol[2] + symbol[3]
            symbolListView.symbolCode = symbol[4] + symbol[5] +
                                        symbol[6] + symbol[7] +
                                        symbol[8] + symbol[9]
            modifier2Selector.modifier2Code = symbol[11]
        }
    }
    property var msSymbol: new Milsymbol.Ms.Symbol(symbol,
                                                     {
                                                         size: 100,
                                                         fill: true
                                                     });
    RowLayout {
        anchors.fill: parent
        ColumnLayout {
            ComboBox {
                model: ["None",
                        "SFGPUCAAAW--",
                        "SHAPMF------",
                        "SNSPXFDF----"]
                editable: false
                onActivated: {
                    if (currentIndex > 0) {
                        symbol = model[currentIndex]
                    }
                }
            }
            Image {
                Layout.fillWidth: true
                Layout.fillHeight: true
                source: "data:image/svg+xml;utf8," + window.msSymbol.asSVG();
                sourceSize: "400x400"
                fillMode: Image.PreserveAspectFit
                Label {
                    anchors.right: parent.right
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 4
                    text: window.symbol
                    font.bold: true
                }
            }
        }

        Control {  // Main milsymbol unit generation control
            Layout.fillWidth: false
            Layout.preferredWidth: 350
            Layout.fillHeight: true
            ColumnLayout {
                anchors.fill: parent
                Milsymbol.BattleDimensionSelector {
                    id: battleDimensionSelector
                    Layout.fillWidth: true; Layout.fillHeight: false
                    onDimensionCodeSelected: {
                        updateSymbol(affiliationSelector.affiliationCode,
                                     dimensionCode,
                                     symbolListView.symbolCode,
                                     modifier2Selector.modifier2Code)
                    }
                }
                Milsymbol.AffiliationSelector {
                    id: affiliationSelector
                    Layout.fillWidth: true; Layout.fillHeight: false
                    onAffiliationCodeSelected: {
                        updateSymbol(affiliationCode,
                                     battleDimensionSelector.dimensionCode,
                                     symbolListView.symbolCode,
                                     modifier2Selector.modifier2Code)
                    }
                }
                Milsymbol.Modifier2Selector {
                    id: modifier2Selector
                    Layout.fillWidth: true; Layout.fillHeight: false
                    dimensionCode: battleDimensionSelector.dimensionCode
                    onModifier2CodeSelected: {
                        updateSymbol(affiliationSelector.affiliationCode,
                                     battleDimensionSelector.dimensionCode,
                                     symbolListView.symbolCode,
                                     modifier2Code)
                    }
                }
                Milsymbol.SymbolListView {
                    id: symbolListView
                    Layout.fillWidth: true; Layout.fillHeight: true

                    battleDimension: battleDimensionSelector.dimension
                    battleDimensionCode: battleDimensionSelector.dimensionCode
                    affiliationCode: affiliationSelector.affiliationCode

                    spacing: 2
                    hilightColor: "lightblue"
                    hilightRadius: 3
                    hilightOpacity: 0.6

                    onSymbolCodeSelected: {
                        updateSymbol(affiliationSelector.affiliationCode,
                                     battleDimensionSelector.dimensionCode,
                                     symbolCode,
                                     modifier2Selector.modifier2Code)
                    }
                }
            }
        } // Unit symbol generation main control
    } // Main RowLayout
} // Window
