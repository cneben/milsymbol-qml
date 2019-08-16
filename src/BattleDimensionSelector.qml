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
    onDimensionCodeChanged: updateCurrentIndex()  // Update current index for new affiliationCode
    signal dimensionCodeSelected(var dimensionCode)

    editable: false
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
    onModelChanged: updateCurrentIndex()    // Update current index for new model
    function updateCurrentIndex() {
        if (model) {
            for (let u = 0; u < model.count; u++) {
                let unit = model.get(u)
                if (unit &&
                    unit.code === dimensionCode) {
                    currentIndex = u
                    break;
                }
            }
        }
    }  // updateCurrentIndex()

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
    contentItem: RowLayout {
        anchors.fill: parent
        property var symbolCode: {
            if (!model ||
                currentIndex < 0)
                return "SFGPU-------"
            else
                return model.get(currentIndex).rootSymbol
        }
        property var symbol: new Milsymbol.Ms.Symbol(symbolCode, {size: 32, fill: true});
        Image {
            Layout.margins: 2
            Layout.preferredWidth: 32
            source: "data:image/svg+xml;utf8," + parent.symbol.asSVG()
            fillMode: Image.PreserveAspectFit
        }
        Label {
            Layout.fillWidth: true
            leftPadding: 0
            rightPadding: battleDimensionSelector.indicator.width + battleDimensionSelector.spacing

            text: battleDimensionSelector.displayText
            font: battleDimensionSelector.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    } // contentItem: RowLayout
    onActivated: {
        if (index !== -1) {
            battleDimensionSelector.dimension = warFightingModel.get(index).dimension
            battleDimensionSelector.dimensionCode = warFightingModel.get(index).code
            dimensionCodeSelected(battleDimensionSelector.dimensionCode)
        }
    }
    onCurrentIndexChanged: {
        if (currentIndex >= 0 ) {
            battleDimensionSelector.dimension = warFightingModel.get(currentIndex).dimension
            battleDimensionSelector.dimensionCode = model.get(currentIndex).code
        }
    }
} // ComboBox
