#include "facedetecte.h"
#include "requestmanager.h"
#include "facedatamodel.h"

QString FaceList::format()
{
    return QString("%1,%2,%3")
            .arg(faceListId)
            .arg(faceListName)
            .arg(userData);
}


FaceDetecte::FaceDetecte(QObject *parent) :
    QObject(parent),
    m_rM(nullptr)
{
    m_rM = new RequestManager(this);
    connect(m_rM, SIGNAL(dataReady(int,QString)), this, SLOT(readData(int,QString)));

    m_faceList.faceListId = "hello-world3";
    m_faceList.userData = "userdata";
    m_faceList.faceListName = "name";
    m_rM->request(RequestManager::DeleteFaceList, m_faceList.faceListId);
}

FaceDetecte::~FaceDetecte()
{

}


void FaceDetecte::setSource(const QString &val)
{
    m_source = val;
}

QString FaceDetecte::source()
{
    return m_source;
}


void FaceDetecte::start(int flage)
{
    switch(flage){
    case 1:         //detecte
        m_rM->request(RequestManager::Detecte, m_source);
        break;
    case 3:         //addfacetolist
        m_rM->request(RequestManager::AddFaceToList,
                      QString("%1,%2")
                      .arg(m_faceList.faceListId)
                      .arg(m_source));
        break;
    case 4:
        m_rM->request(RequestManager::FindSimilars,
                      QString("%1,%2")
                      .arg(m_source)
                      .arg(m_faceList.faceListId));
        break;
    default:
        break;
    }
}


void FaceDetecte::readData(int rWay, QString data)
{

    emit readyRead(rWay, data);
   // 如果facelist已经存在，则删除
    if(rWay ==  -1)
    {
        QStringList errs = data.split(QChar('\t'), QString::SkipEmptyParts);
        if(errs.size() > 0 && errs[0] == "FaceListExists")
            m_rM->request(RequestManager::DeleteFaceList, m_faceList.faceListId);
        else if(errs.size() > 0 && errs[0] == "FaceListNotFound")
            m_rM->request(RequestManager::CreateFaceList, m_faceList.format());
    }
    //如果删除成功则重新创建
    if(rWay == RequestManager::DeleteFaceList)
    {
         m_rM->request(RequestManager::CreateFaceList, m_faceList.format());
    }

}

