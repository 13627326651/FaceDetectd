#include "requestmanager.h"
#include "facedatamodel.h"
#include <QTimer>
#include <QUrlQuery>
#include <QNetworkRequest>
#include <QSignalMapper>
#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>
#include <QFile>
#include <QMap>


class RequestManagerPrivate{
public:
    RequestManagerPrivate();
    QNetworkAccessManager *nam;
    QSignalMapper *mapper;
};

RequestManagerPrivate::RequestManagerPrivate():
    nam(NULL),
    mapper(NULL)
{


}


RequestManager::RequestManager(QObject *parent)
    : QObject(parent),
      d(new RequestManagerPrivate)
{
    d->mapper = new QSignalMapper(this);
    connect(d->mapper, SIGNAL(mapped(QObject*)), this, SLOT(readData(QObject*)));
    d->nam = new QNetworkAccessManager(this);

    m_rWay = NoRequest;

}

RequestManager::~RequestManager()
{
    delete d;
}


void RequestManager::readData(QObject *reply)
{

    int rWay = m_rWay;
    m_rWay = NoRequest;

    //检测可能的系统错误
    QNetworkReply *nReply = qobject_cast<QNetworkReply*>(reply);
    if(!nReply)
    {
        emit dataReady(-1, "QNetworkReply Error");
        return;
    }

    QByteArray data = nReply->readAll();
    if(data.isEmpty() && rWay != DeleteFaceList && rWay != CreateFaceList)
    {
        emit dataReady(-1, nReply->errorString());
        return;
    }

    //解析服务器错误
    QJsonDocument doc = QJsonDocument::fromJson(data);
    if(doc.isObject()){
        QJsonObject obj = doc.object();
        if(obj.contains(QLatin1Literal("error"))){
            obj = obj.value(QLatin1Literal("error")).toObject();
            emit dataReady(-1, obj.value(QLatin1Literal("code")).toString()
                           + "\t" +
                           obj.value(QLatin1Literal("message")).toString());
            return;
        }
    }

    //数据处理
    switch (rWay) {
    case Detecte:
    {
        FaceDataModel model;
        if(model.fromJsonData(data))
            emit dataReady(rWay, model.format());
        else
            emit dataReady(-1, "Can not find a face.");
        break;
    }
    case AddFaceToList:
    {
        if(doc.isObject())
        {
            QJsonObject obj = doc.object();
            if(obj.contains("persistedFaceId"))
            {
                emit dataReady(rWay,obj.value("persistedFaceId").toString());
                break;
            }
        }else{
            emit dataReady(-1, "Add face to list error");
        }
        break;
    }
    case FindSimilars:
    {
        QStringList similars;
        if(doc.isArray()){
            QJsonArray arr = doc.array();
            for(int i = 0; i < arr.size(); i++)
            {
                QJsonObject obj = arr[i].toObject();
                QString persistedFaceId = obj.value(QLatin1Literal("persistedFaceId")).toString();
                QString confidence = QString::number(obj.value(QLatin1Literal("confidence")).toDouble());
                similars << QString("%1,%2").arg(persistedFaceId).arg(confidence);
            }
        }
        if(similars.size() > 0)
            emit dataReady(FindSimilars, similars.join(QChar('\n')));
        else
            emit dataReady(-1 , "NO similar face found");
        break;

//        for(int i = 0; i < doc.array().size(); i++){
//            QJsonObject obj = doc.array().at(i).toObject();
//            QString persistedFaceId = obj.value(QLatin1Literal("persistedFaceId")).toString();
//            QString confidence = QString::number(obj.value(QLatin1Literal("confidence")).toDouble());
//            similars << QString("%1,%2").arg(persistedFaceId).arg(confidence);
//        }
//        if(similars.size() > 0)
//            emit dataReady(FindSimilars, similars.join(QChar('\n')));
//        else
//            emit dataReady(-1 , "NO similar face found");
//        break;
    }
    case CreateFaceList:
        emit dataReady(rWay, "Create face list success");
        break;
    case DeleteFaceList:
        emit dataReady(rWay, "Delete face list success");
        break;
    default:
        break;
    }
}

void RequestManager::request(RequestWay way, const QString &data)
{

    RequestData rd;
    switch(way){
    case Detecte:
        if(m_rWay == NoRequest){
            QFile file;
            if(data.startsWith("file://"))
            {
                QUrl url(data);
                file.setFileName(url.toLocalFile());
            }else
                file.setFileName(data);

            if(!file.open(QIODevice::ReadOnly)){
                qDebug() << file.errorString();
                emit dataReady(-1, file.errorString());
                return ;
            }
            m_rWay = Detecte;
            rd.requestType = "detect";
            rd.paraList["returnFaceId"] = "true";
            rd.paraList["returnFaceLandmarks"] = "false";
            //属性可以是：
            //age, gender, headPose, smile, facialHair,
            //glasses, emotion, hair, makeup, occlusion,
            //accessories, blur, exposure, noise
            rd.paraList["returnFaceAttributes"] = "age,gender,glasses,smile,emotion";
            rd.method = RequestData::Post;
            rd.contentType = "application/octet-stream";
            rd.requestBody = file.readAll();
            file.close();
            start(rd);
        }
        break;
    case CreateFaceList:
        if(m_rWay == NoRequest){
            m_rWay = CreateFaceList;
            QStringList paraList = data.split(QChar(','),QString::KeepEmptyParts);
            if(paraList.size() != 3)
            {
                emit dataReady(-1, "Error, create face list wrong for parameters");
                return;
            }
            rd.requestType = "facelists/" + paraList[0];
            rd.contentType = "application/json";
            rd.method = RequestData::Put;
            rd.requestBody = QString("{ \"name\":\"%1\", \"userData\":\"%2\" }")
                    .arg(paraList[1])
                    .arg(paraList[2])
                    .toLatin1();
            start(rd);
        }
        break;
    case AddFaceToList:
        if(m_rWay == NoRequest){
            m_rWay = AddFaceToList;
            QStringList paraList = data.split(QChar(','),QString::KeepEmptyParts);
            if(paraList.size() != 2)
            {
                emit dataReady(-1, "Error, add a face to list for wrong parameters");
                return;
            }
            rd.requestType = "facelists/" + paraList[0] + "/persistedFaces";
            rd.contentType = "application/octet-stream";
            rd.method = RequestData::Post;

            QFile file;
            if(paraList[1].startsWith("file://"))
            {
                QUrl url(paraList[1]);
                file.setFileName(url.toLocalFile());
            }else
                file.setFileName(paraList[1]);

            qDebug() << "AddFaceToList" << file.fileName();
            if(!file.open(QIODevice::ReadOnly)){
                qDebug() << file.errorString();
                emit dataReady(-1, file.errorString());
                return ;
            }
            rd.requestBody = file.readAll();
            file.close();
            start(rd);
        }
        break;
    case FindSimilars:
        if(m_rWay == NoRequest){
            m_rWay = FindSimilars;
            QStringList paraList = data.split(QChar(','),QString::KeepEmptyParts);
            if(paraList.size() != 2)
            {
                emit dataReady(-1, "Error, find a similar face to list for wrong parameters");
                return;
            }
            rd.requestType = "findsimilars";
            rd.contentType = "application/json";
            rd.method = RequestData::Post;
            rd.requestBody = tr("{\"faceId\":\"%1\","
                                "\"faceListId\":\"%2\","
                                "\"maxNumOfCandidatesReturned\":10,"
                                "\"mode\": \"matchPerson\"}")
                    .arg(paraList[0])
                    .arg(paraList[1])
                    .toLatin1();
            start(rd);
        }
        break;
    case DeleteFaceList:
        if(m_rWay == NoRequest){
            m_rWay = DeleteFaceList;
            rd.requestType = "facelists/" + data;
            rd.method = RequestData::Delete;
            start(rd);
        }
        break;
    default:
        break;
    }
}

void RequestManager::onError(QNetworkReply::NetworkError e)
{
    emit dataReady(-1, QString("RequestManager::onError: %1").arg(e));

}

void RequestManager::start(const RequestData &rd)
{


    QString urlString("https://westcentralus.api.cognitive.microsoft.com/face/v1.0/");
    urlString += rd.requestType;


    QUrlQuery query;
    //插入参数
    QMap<QString, QString>::const_iterator it = rd.paraList.constBegin();
    for(; it != rd.paraList.end(); it++){
        query.addQueryItem(it.key(), it.value());
    }

    QUrl url;
    url.setUrl(urlString);
    url.setQuery(query);
    QNetworkRequest nr(url);
    nr.setRawHeader(QByteArray("Content-Type"), rd.contentType);
    nr.setRawHeader(QByteArray("Ocp-Apim-Subscription-Key"),
                    QByteArray("469920816e284cdeab0bd063e02d7752"));
    //注册ssl
    QSslConfiguration conf = nr.sslConfiguration();
    conf.setPeerVerifyMode(QSslSocket::VerifyNone);
    conf.setProtocol(QSsl::TlsV1SslV3);
    nr.setSslConfiguration(conf);
    //使用不同的方法调用发送请求
    QNetworkReply *reply = 0;
    switch(rd.method){
    case RequestData::Get:
        reply = d->nam->get(nr);
        break;
    case RequestData::Post:
        reply = d->nam->post(nr, rd.requestBody);
        break;
    case RequestData::Put:
        reply = d->nam->put(nr, rd.requestBody);
        break;
    case RequestData::Delete:
        reply = d->nam->deleteResource(nr);
        break;
    default:
        break;
    }

    d->mapper->setMapping(reply, reply);
    connect(reply, SIGNAL(finished()),
            d->mapper, SLOT(map()));
    connect(reply, SIGNAL(error(QNetworkReply::NetworkError)),
            this, SLOT(onError(QNetworkReply::NetworkError)));

}

