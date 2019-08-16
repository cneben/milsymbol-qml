QT      += quick
CONFIG  += c++14

DEFINES += QT_DEPRECATED_WARNINGS

INCLUDEPATH +=  $$PWD
SOURCES     +=  $$PWD/msImageProvider.cpp
HEADERS     +=  $$PWD/msImageProvider.h


OTHER_FILES +=  $$PWD/BattleDimensionSelector.qml   \
                $$PWD/AffiliationSelector.qml       \
                $$PWD/Modifier2Selector.qml       \
                $$PWD/SymbolListView.qml

RESOURCES += $$PWD/milsymbol-qml.qrc
