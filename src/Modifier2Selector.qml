//-----------------------------------------------------------------------------
// This file is a part of the milsymbol-qml software. Copyright 2019 Delia Stratégie.
//
// \file	Modifier2Selector.qml
// \author	benoit@destrat.io
// \date	2019 08 15
//-----------------------------------------------------------------------------

import QtQuick          2.11
import QtQuick.Layouts  1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' as Milsymbol

/*! \brief Visual selection of modifier 2 for Ground and SOF units.
 *
 * Component should be connected to BattleDimensionSelector through \c dimensionCode
 * property to automatically disable control when a non modifiable unit is selected.
 */
ComboBox {
    id: modifierSelector
    Layout.margins: 0
    padding: 0

    property string dimensionCode: 'GP'
    onDimensionCodeChanged: {
        // Disable modifier selector control for non ground/SOF units
        if (dimensionCode === 'GP' ||       // GP == GRDTRK_UNT
            dimensionCode === 'FP') {       // FP == SOFUNT
            modifier2Selector.enabled = true
        } else {
            modifier2Code = '-'
            modifier2Selector.enabled = false
        }
        updateCurrentIndex()
    }

    property string modifier2Code: '-'
    onModifier2CodeChanged: updateCurrentIndex()  // Update current index for new modifier2Code

    signal modifier2CodeSelected(var modifier2Code)

    //    if (battledimension == "GRDTRK_UNT" || battledimension == "SOFUNT") {
    ListModel {
        // Note:
            // 'name': displayable label for modifier.
            // Copied from Milsymbol-generator javascript code,
                // https://github.com/spatialillusions/milsymbol-generator/blob/master/src/letter-sidc/modifier2.js
        id: modifierModel
        ListElement { code: "-"; name: "Unspecified";           sidc: "------------" }
        ListElement { code: "A"; name: "Team/Crew";             sidc: "SFGP-------A" }
        ListElement { code: "B"; name: "Squad";                 sidc: "SFGP-------B" }
        ListElement { code: "C"; name: "Section";               sidc: "SFGP-------C" }
        ListElement { code: "D"; name: "Platoon/Detachment";    sidc: "SFGP-------D" }
        ListElement { code: "E"; name: "Company/Battery/Troop"; sidc: "SFGP-------E" }
        ListElement { code: "F"; name: "Battalion/Squadron";    sidc: "SFGP-------F" }
        ListElement { code: "G"; name: "Regiment/Group";        sidc: "SFGP-------G" }
        ListElement { code: "H"; name: "Brigade";               sidc: "SFGP-------H" }
        ListElement { code: "I"; name: "Division";              sidc: "SFGP-------I" }
        ListElement { code: "J"; name: "Corps/Mef";             sidc: "SFGP-------J" }
        ListElement { code: "K"; name: "Army";                  sidc: "SFGP-------K" }
        ListElement { code: "L"; name: "Army Group/Front";      sidc: "SFGP-------L" }
        ListElement { code: "M"; name: "Region";                sidc: "SFGP-------M" }
        ListElement { code: "N"; name: "Command";               sidc: "SFGP-------N" }
    }
    model : modifierModel
    onModelChanged: updateCurrentIndex()    // Update current index for new model
    textRole: "name"
    editable: false

    function updateCurrentIndex() {
        if (model) {
            for (let u = 0; u < model.count; u++) {
                let unit = model.get(u)
                if (unit &&
                    unit.code === modifier2Code) {
                    currentIndex = u
                    break;
                }
            }
        }
    }  // updateCurrentIndex()

    delegate: ItemDelegate {
        width: parent.width
        property var symbol: new Milsymbol.Ms.Symbol(sidc , {size: 32, fill: true});
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
                text: name
                wrapMode: Text.WordWrap
            }
        }
    } // delegate: ItemDelegate
    contentItem: RowLayout {
        anchors.fill: parent
        property var symbolCode: {
            if (!model ||
                currentIndex < 0)
                return "SFGP--------"
            else
                return model.get(currentIndex).sidc + "--------"
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
            rightPadding: modifierSelector.indicator.width + modifierSelector.spacing

            text: modifierSelector.displayText
            font: modifierSelector.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    } // contentItem: RowLayout
    onActivated: {
        if (index !== -1) {
            modifierSelector.modifier2Code = model.get(index).code
            modifier2CodeSelected(modifierSelector.modifier2Code)
        }
    }
    onCurrentIndexChanged: {
        if (currentIndex >= 0 ) {
            modifierSelector.modifier2Code = model.get(currentIndex).code
        }
    }
} // ComboBox
