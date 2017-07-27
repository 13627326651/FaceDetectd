#ifndef REQUESTMANAGER_H
#define REQUESTMANAGER_H

#include <QObject>
#include <QNetworkReply>

class RequestData
{
public:
    enum Method{Get, Post, Put, Delete};
    QString requestType;
    QByteArray contentType;
    Method method;
    QMap<QString,QString> paraList;
    QByteArray requestBody;

};

class RequestManagerPrivate;

class RequestManager : public QObject
{
    Q_OBJECT
public:
    enum RequestWay{NoRequest, Detecte, CreateFaceList, AddFaceToList, FindSimilars, DeleteFaceList};
    RequestManager(QObject *parent = 0);
    void request(RequestWay way, const QString &data);
    ~RequestManager();
signals:
    void requested();
    void dataReady(int, QString);

private slots:
    void readData(QObject *reply);
    void onError(QNetworkReply::NetworkError e);
private:
    void start(const RequestData &rd);

    RequestWay m_rWay;
    RequestManagerPrivate *d;
};

#endif // REQUESTMANAGER_H
