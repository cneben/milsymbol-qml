Milsymbol sample in Qt QML
==========================

![](https://github.com/cneben/milsymbol-qml/blob/master/screenshot.jpeg)

Demonstration of milsymbol javascript library integration in a Qt/QML application (will eventually grow to an ORBAT editor).


## Using

Include `src/milsymbol-qml.pri` in your main `.pro` project file:


```
# yourpoject.pro QMake configuration
QT      += quick
include(../src/milsymbol-qml.pri)
```

```js
// yourmain.qml
import QtQuick 2.11
import QtQuick.Controls 2.4

import 'qrc:/Milsymbol' 1.0

// Then use Ms. module as you would with regular milsymbol library:

Window {
    id: window
    visible: true
    width: 900; height: 550
    title: qsTr("Milsymbol.js QML Demo")

    property var symbol: new Ms.Symbol('sfgpewrh--mt', {
            size: 35,
            quantity: 200,
            staffComments: "for reinforcements".toUpperCase(),
            additionalInformation: "added support for JJ".toUpperCase(),
            direction: (750*360/6400),
            type: "machine gun".toUpperCase(),
            dtg: "30140000ZSEP97",
            location: "0900000.0E570306.0N"})

    Image {
        anchors.fill: parent
        source: 'data:image/svg+xml;utf8,' + window.symbol.asSVG();
        // Do not forget to configure sourceSize: "400x400"
        fillMode: Image.PreserveAspectFit   
    }
}
```



## Building

milsymbol-qml is distributed with pre-built Milsymbol javascript library 'milsymbol.developement.js' and 'milstd.js'. Theses files could be regenerated with the following commands:

```sh
# Building milsymbol.js
$ git clone https://github.com/spatialillusions/milsymbol
$ cd milsymbol
$ npm install
$ npm run bundle
# target milsymbol.development.js is in ./dist directory, replace the file in milsymbol-qml/src

# Building milstd.js
$ git clone https://github.com/spatialillusions/milsymbol
$ cd milsymbol
$ npm install
$ npm run build
# target milstd.js is in current directory, replace the file in milsymbol-qml/src

```

Refer to sample/milsymbol-qml-sample.pro for an example of integration with QMake.


Milsymbol is (c) 2017 spatialillusions.com

Inspiration for UI components:
https://spatialillusions.com/unitgenerator/

Licence: MIT
