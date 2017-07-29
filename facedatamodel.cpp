#include "facedatamodel.h"
#include <QJsonDocument>
#include <QJsonArray>
#include <QJsonValue>
#include <QMap>
#include <QDebug>

FaceDataModel::FaceDataModel()
{

}

bool FaceDataModel::fromJsonData(const QByteArray &jsonData)
{
    qDebug() << jsonData;
    m_faceList.clear();

    QJsonDocument doc = QJsonDocument::fromJson(jsonData);
    if(doc.isArray()){
        QJsonArray array = doc.array();
        for(int i = 0; i < array.size(); i++)
        {
            QString record =  getOneRecord(array[i].toObject());
            m_faceList << record;
        }
    }

    if(m_faceList.size() > 0)
        return true;
    else
        return false;
}

QString FaceDataModel::format()
{
   return m_faceList.join(QChar('\n'));
}

QString FaceDataModel::getOneRecord(const QJsonObject &jsonObj)
{

    QJsonObject obj;
    if(jsonObj.contains(QLatin1Literal("faceId")))
        m_faceId = jsonObj.value(QLatin1Literal("faceId")).toString();

    if(jsonObj.contains(QLatin1Literal("faceRectangle")))
    {
        obj = jsonObj.value("faceRectangle").toObject();
        m_faceRectangle = QString("%1:%2:%3:%4")
                .arg(obj.value("left").toInt())
                .arg(obj.value("top").toInt())
                .arg(obj.value("width").toInt())
                .arg(obj.value("height").toInt());
    }

    if(jsonObj.contains(QLatin1Literal("faceAttributes")))
        obj = jsonObj.value(QLatin1String("faceAttributes")).toObject();

    if(obj.contains(QLatin1Literal("age"))){
        double age = obj.value(QLatin1Literal("age")).toDouble();
        m_age = QString::number(age);
    }

    if(obj.contains(QLatin1Literal("gender"))){

        QString gender = obj.value(QLatin1Literal("gender")).toString();

        m_gender = gender;
    }

    if(obj.contains(QLatin1Literal("smile"))){
        double smile = obj.value(QLatin1Literal("smile")).toDouble();

        m_smile = QString::number(smile);

    }

    if(obj.contains(QLatin1Literal("glasses"))){
        m_glasses = obj.value(QLatin1Literal("glasses")).toString();


    }

    if(obj.contains(QLatin1Literal("emotion"))){
        obj = obj.value(QLatin1Literal("emotion")).toObject();
        QMap<double, QString> emotions;
        if(obj.contains("anger"))
            emotions.insert(obj.value("anger").toDouble(), "anger2.png");
        if(obj.contains("contempt"))
            emotions.insert(obj.value("contempt").toDouble(), "contempt.png");
        if(obj.contains("disgust"))
            emotions.insert(obj.value("disgust").toDouble(), "disgust.jpg");
        if(obj.contains("fear"))
            emotions.insert(obj.value("fear").toDouble(), "fear.png");
        if(obj.contains("happiness"))
            emotions.insert(obj.value("happiness").toDouble(), "happiness.png");
        if(obj.contains("neutral"))
            emotions.insert(obj.value("neutral").toDouble(), "neutral.png");
        if(obj.contains("sadnesss"))
            emotions.insert(obj.value("sadnesss").toDouble(), "sadness.png");
        if(obj.contains("surprise"))
            emotions.insert(obj.value("surprise").toDouble(), "surprise.png");
        double max = 0;

        QMap<double, QString>::ConstIterator it = emotions.begin();
        for(; it != emotions.end(); it++)
        {
            if(it.key() > max)
            {
                max = it.key();
            }
        }
        m_emotion  = emotions.value(max);
    }

    return QString("%1,%2,%3,%4,%5,%6,%7")
            .arg(m_faceId)
            .arg(m_age)
            .arg(m_gender)
            .arg(m_smile)
            .arg(m_glasses)
            .arg(m_emotion)
            .arg(m_faceRectangle);
}
