// Std headers
#include <memory>

// Qt headers
#include <QGuiApplication>
#include <QQmlApplicationEngine>

// Milsymbol-qml headers
#include "msImageProvider.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);
    QQmlApplicationEngine engine;
    std::unique_ptr<ms::ImageProvider> imageProvider = std::make_unique<ms::ImageProvider>();
    engine.addImageProvider(ms::ImageProvider::providerId(), imageProvider.get());
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
