#ifndef FACEDATAMODEL_H
#define FACEDATAMODEL_H
#include <QObject>
#include <QJsonObject>
class FaceDataModel
{
public:
    FaceDataModel();
    bool fromJsonData(const QByteArray &jsonData);
    QString format();

private:
    QString getOneRecord(const QJsonObject &jsonObj);
    QString m_faceRectangle;
    QString m_age;
    QString m_gender;
    QString m_smile;
    QString m_glasses;
    QString m_faceId;
    QString m_emotion;
    QStringList m_faceList;
};

#endif // FACEDATAMODEL_H
