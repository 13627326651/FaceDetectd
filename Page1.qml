import QtQuick 2.0
import QtQuick.Controls 2.2

Page{
    id: rootPage
    background: Rectangle{
        color: "#E4E4E4"
    }
    property var faces: new Array;
    property var detectedPhoto: photoPreview_2;
    property var source;
    function showPix(offset)
    {
        if(rootPage.faces.length > 0)
        {

            currentIndex = (currentIndex + offset + rootPage.faces.length) % rootPage.faces.length

            var infos = rootPage.faces[currentIndex].split(',')

            faceImage.pixName = infos[5]
            faceImage.age = infos[1]
            faceImage.gender = infos[2]
            faceImage.glasses = infos[4]

            ani_2.start()
        }
    }

    Image {
        id: photoPreview_2;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        anchors.topMargin: 10;
        width: 200;
        height: 150;
        source: rootPage.source;
        onSourceChanged: {
            for(var i = 0; i < photoPreview_2.children.length; i++)
                photoPreview_2.children[i].destroy();

            for(var i = 0; i < faceImages.children.length; i++)
                faceImages.children[i].destroy();
        }
    }
    FaceImage{
        id: faceImage;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: photoPreview_2.bottom;
        anchors.topMargin: 30;
        property int currentIndex:0;


        NumberAnimation{
            id: ani_2;
            target: faceImage;
            properties: "scale"
            from: 0
            to: 1
        }
    }

    footer: TabBar{
        TabButton{
            text: "上一页"
            font.pointSize: 12
            onClicked: faceImage.showPix(-1)
        }
        TabButton{
            text: "下一页"
            font.pointSize: 12
            onClicked: faceImage.showPix(1)
        }
    }

}
