//-----------------------------------------------------------------------------
// This file is a part of the milsymbol-qml software. Copyright 2019 Delia Stratégie.
//
// \file	AffiliationSelector.qml
// \author	benoit@destrat.io
// \date	2010 08 12
//-----------------------------------------------------------------------------

import QtQuick          2.11
import QtQuick.Layouts  1.3
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' as Milsymbol

ComboBox {
    id: affiliationSelector
    Layout.margins: 0
    padding: 0

    property string affiliationCode: 'F'
    onAffiliationCodeChanged: updateCurrentIndex()  // Update current index for new affiliationCode

    signal affiliationCodeSelected(var affiliationCode)

    ListModel {
        id: affiliationModel
        ListElement { name: "Pending";                  code: "P";   sidc: "SPGP" }
        ListElement { name: "Unknown";                  code: "U";   sidc: "SUGP" }
        ListElement { name: "Assumed Friend";           code: "A";   sidc: "SAGP" }
        ListElement { name: "Friend";                   code: "F";   sidc: "SFGP" }
        ListElement { name: "Neutral";                  code: "N";   sidc: "SNGP" }
        ListElement { name: "Suspect";                  code: "S";   sidc: "SSGP" }
        ListElement { name: "Hostile";                  code: "H";   sidc: "SHGP" }
        ListElement { name: "Exercise Pending";         code: "G";   sidc: "SGGP" }
        ListElement { name: "Exercise Unknown";         code: "W";   sidc: "SWGP" }
        ListElement { name: "Exercise Friend";          code: "D";   sidc: "SDGP" }
        ListElement { name: "Exercise Neutral";         code: "L";   sidc: "SLGP" }
        ListElement { name: "Exercise Assumed Friend";  code: "M";   sidc: "SMGP" }
        ListElement { name: "Joker";                    code: "J";   sidc: "SJGP" }
        ListElement { name: "Faker";                    code: "K";   sidc: "SKGP" }
        ListElement { name: "None Specified";           code: "O";   sidc: "SOGP" }
    }
    model : affiliationModel
    onModelChanged: updateCurrentIndex()    // Update current index for new model
    textRole: "name"
    editable: false

    function updateCurrentIndex() {
        if (model) {
            for (let u = 0; u < model.count; u++) {
                let unit = model.get(u)
                if (unit &&
                    unit.code === affiliationCode) {
                    currentIndex = u
                    break;
                }
            }
        }
    }  // updateCurrentIndex()

    delegate: ItemDelegate {
        width: parent.width
        property var symbol: new Milsymbol.Ms.Symbol(sidc + "--------", {size: 32, fill: true});
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
            rightPadding: affiliationSelector.indicator.width + affiliationSelector.spacing

            text: affiliationSelector.displayText
            font: affiliationSelector.font
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    } // contentItem: RowLayout
    onActivated: {
        if (index !== -1) {
            affiliationSelector.affiliationCode = model.get(index).code
            affiliationCodeSelected(affiliationSelector.affiliationCode)
        }
    }
    onCurrentIndexChanged: {
        if (currentIndex >= 0 ) {
            affiliationSelector.affiliationCode = model.get(currentIndex).code
        }
    }
} // ComboBox
