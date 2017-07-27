#ifndef FACEDETECTE_H
#define FACEDETECTE_H

#include <QObject>

class FaceList{
public:
    QString format();
    QString faceListId;
    QString faceListName;
    QString userData;
    QStringList persistedFaceIdList;
};

class RequestManager;
class FaceDetecte : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString source READ source WRITE setSource NOTIFY sourceChanged)
public:
    explicit FaceDetecte(QObject *parent = nullptr);
    ~FaceDetecte();
    Q_INVOKABLE void start(int flage);

    void setSource(const QString &val);
    QString source();

signals:
    void sourceChanged();
    void readyRead(int flag, QString msg);
public slots:
    void readData(int,QString);
private:
    RequestManager *m_rM;
    QString m_source;
    FaceList m_faceList;
};


#endif // FACEDETECTE_H
