#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "facedetecte.h"
#include <QTextCodec>
int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    qmlRegisterType<FaceDetecte>("FaceDetecte", 1, 0, "FaceDetecte");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
