import QtQuick          2.11
import QtQuick.Layouts  1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' as Milsymbol

ComboBox {
    id: battleDimensionSelector
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
        property var symbol: new Milsymbol.Ms.Symbol(warFightingModel.get(index).rootSymbol, {size: 32, fill: true});
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
} // ComboBox
