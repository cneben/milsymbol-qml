QT      += quick
CONFIG  += c++11
DEFINES += QT_DEPRECATED_WARNINGS

include(../src/milsymbol-qml.pri)
SOURCES += main.cpp

OTHER_FILES += main.qml

RESOURCES += sample.qrc

