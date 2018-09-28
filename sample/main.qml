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

    property var mainSymbol: new Milsymbol.Ms.Symbol(symbolListView.symbol, {
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

        Control {  // Main milsymbol unit generation control
            Layout.fillWidth: false
            Layout.preferredWidth: 350
            Layout.fillHeight: true
            ColumnLayout {
                anchors.fill: parent
                Milsymbol.BattleDimensionSelector {
                    id: battleDimensionSelector
                    Layout.fillWidth: true; Layout.fillHeight: false
                }
                Milsymbol.SymbolListView {
                    id: symbolListView
                    Layout.fillWidth: true; Layout.fillHeight: true

                    spacing: 2
                    hilightColor: "lightblue"
                    hilightRadius: 3
                    hilightOpacity: 0.6
                }
            }
        } // Unit symbol generation main control
    } // Main RowLayout
} // Window
