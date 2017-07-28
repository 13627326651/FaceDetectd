import QtQuick 2.6
import QtQuick.Window 2.2
import QtMultimedia 5.9
import QtQuick.Controls 2.2
import FaceDetecte 1.0
import Qt.labs.platform 1.0

Window {
    minimumHeight: 700;
    minimumWidth: 850;
    visible: true
    title: qsTr("人脸识别跟踪系统")
    property var imgList: new Array;
    property var idList: new Array;

    FaceDetecte{
        id: fd;
        onReadyRead: {
            // 如果是跟踪功能，进行判断

            switch(flag)
            {
            case 1:
            {        //detect
                var persons = msg.split('\n')
                //查找相似
                if(bt3.isRunning)
                {
                    fd.source = persons[0].split(',')[0];
                    fd.start(4);
                    break;
                }

                //清除以前的脸部矩形
                for(var i = 0; i < photoPreview_2.children.length; i++)
                    photoPreview_2.children[i].destroy();

                //添加新脸部矩形
                for(var i = 0; i < persons.length; i++)
                {
                    var pL = persons[i].split(',')
                    var com = Qt.createComponent("FaceRectangle.qml")
                    if(com.status == Component.Error)
                        console.log(com.errorString())

                    var o = com.createObject(photoPreview_2)
                    o.updateFaceRect(pL[6].split(':'), i)
                }

                faceImage.faces = persons;
                faceImage.currentIndex = 0;
                if(persons.length > 0)
                    faceImage.showPix(0)

                myIndicator.running = false;
                statusArea.msg = "Detecte success"
                break;
            }
            case 3:         //Addfacetolist
            {
                //入库时备份了一份路径到bt4.tempImg;
                imgList[imgList.length] = bt4.tempImg;
                idList[idList.length] = msg;
                statusArea.msg = "Add face to list success"
                myIndicator.running = false;
                break;
            }
            case 4:
            {    //Find a similar
                var faces = msg.split('\n');
                var max = -1;
                var faceId;
                for(var i = 0; i < faces.length;  i++)
                {
                    var con = faces[i].split(',')[1];
                    if(con > max){
                        max = con;
                        faceId = faces[i].split(',')[0];
                    }
                }

                for(var i = 0; i < idList.length; i++)
                {
                    if(idList[i] == faceId)
                    {
                        statusArea.msg = "Find similar face success"
                        matchedImg.source = imgList[i];
                        confidence.myText = Math.round(max* 10000)/100;
                        break;
                    }
                }
                //可能从服务器找到了匹配的faceid，但是数组中没有找到相同的faceid
                if(i == idList.length)
                    statusArea.msg = "No similar face found"
                bt3.isRunning = false;
                myIndicator.running = false;
                break;
            }
            default:
                statusArea.msg = msg;
                bt3.isRunning = false;
                myIndicator.running = false;
                break;
            }
        }
    }

    MediaPlayer{
        id: player;
        volume: 1;
        onError: {
            console.log("*******", errorString)
        }
    }

    Rectangle {
        id: leftArea;
        width: parent.width * 2 / 3;
        height: parent.height - 30;
        Camera {
            id: camera
            imageCapture {
                onImageCaptured: {
                    // Show the preview in an Image
                    photoPreview.source = preview;
                }
                onImageSaved: {
                    photoPreview.path = path;
                }
            }
        }
        Rectangle{
            id: textBar1;
            anchors.top: parent.top;
            anchors.left: parent.left;
            height: 40;
            width: parent.width;
            color:  Qt.rgba(0.02, 0.85, 0.98, 1.0)
            Text{
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                width: contentWidth;
                height: contentHeight;
                font.pointSize: 14;
                color: "#353637"
                text: "图 片 区"
            }
        }

        Image{
            id: back
            anchors.verticalCenter: output.verticalCenter;
            //            anchors.right: output.left;
            //            anchors.rightMargin: 4;
            x: (output.x - back.width) / 2
            width: 40;
            height: 40;
            source: "images/back.png"
            opacity: mArea.pressed ? 1 : 0.5;
            MouseArea{
                id: mArea;
                anchors.fill: parent;
                onClicked: {
                    optionsRect.visible = true;
                }
            }
        }

        VideoOutput {
            id: output;
            anchors.horizontalCenter: leftArea.horizontalCenter;
            anchors.top: parent.top;
            anchors.topMargin: 30;
            width: 450;
            height: 400;
            source: camera
            focus : visible // to receive focus and capture key events when visible
            Image {
                id: photoPreview
                width: 450;
                height: 340;
                fillMode: Image.PreserveAspectFit;
                anchors.centerIn: parent;
                property string path: "";
                property bool fromLocal: false
                MouseArea{
                    id: mouseArea0;
                    enabled: !optionsRect.visible && !photoPreview.fromLocal;
                    anchors.fill: parent;
                    onClicked: {
                        photoPreview.source = ""
                    }
                    onDoubleClicked:{
                        player.source = "sound/takephoto.wav"
                        player.play();
                        camera.imageCapture.capture();
                    }
                }
            }

            FileDialog{
                id: fileDialog
                nameFilters: ["image files (*.png *.jpg)"]
                onAccepted: {
                    photoPreview.source = file;
                    photoPreview.path = file;
                    photoPreview.fromLocal = true;
                    optionsRect.visible = false;

                }
            }

            Rectangle{
                id: optionsRect;
                anchors.centerIn: parent;
                width: 450;
                height: 340;
                border.width: 1;
                border.color: "darkgray"
                z: 10;
                Row{
                    anchors.centerIn: parent;
                    Text{
                        width: contentWidth;
                        height: contentHeight;
                        font.pointSize: 14;
                        color: mouseArea.containsMouse ? "blue" : "black"
                        text: "拍照"
                        MouseArea{
                            id: mouseArea;
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onClicked: {
                                photoPreview.source = "";
                                photoPreview.path = "";
                                photoPreview.fromLocal = false;
                                optionsRect.visible = false;

                            }
                        }
                    }
                    Text{
                        width: contentWidth;
                        height: contentHeight;
                        font.pointSize: 14;
                        text: " 或者 "
                    }
                    Text{
                        width: contentWidth;
                        height: contentHeight;
                        font.pointSize: 14;
                        color: mouseArea2.containsMouse ? "blue" : "black"
                        text: "本地图片"
                        MouseArea{
                            id: mouseArea2;
                            anchors.fill: parent;
                            hoverEnabled: true;
                            onClicked: {
                                fileDialog.open();

                            }
                        }

                    }
                }
            }
        }
        Rectangle{
            id: textBar2;
            anchors.top: output.bottom;
            anchors.left: parent.left;
            width: parent.width
            height: 40;
            color:  Qt.rgba(0.02, 0.85, 0.98, 1.0)
            Text{
                anchors.left: parent.left;
                anchors.leftMargin: 10;
                anchors.verticalCenter: parent.verticalCenter;
                verticalAlignment: Text.AlignVCenter;
                width: contentWidth;
                height: contentHeight;
                font.pointSize: 14;
                color: "#353637"
                text: "功 能 区"
            }
        }


        Row{
            id: buttonRow
            anchors.horizontalCenter: textBar2.horizontalCenter;
            anchors.top: textBar2.bottom
            anchors.topMargin: 40
            spacing: 10;
            MyButton{
                id: bt2;
                text: "识 别";
                onClicked: {
                    //注意要放在前面
                    myIndicator.running = true;
                    photoPreview_2.source = photoPreview.source;
                    control.currentIndex = 0;
                    fd.source = photoPreview.path;
                    fd.start(1);    //detecte
                }

            }
            MyButton{
                id: bt3;
                width: 80;
                text: "匹 配";
                property bool isRunning: false;
                property string tempImg: "";
                onClicked: {
                    control.currentIndex = 1;
                    if(photoPreview.path != ""){
                        myIndicator.running = true;
                        matchedImg.source = "";
                        isRunning = true;
                        tempImg = photoPreview.source.toString();
                        fd.source = photoPreview.path;
                        fd.start(1);
                    }
                }

            }

            MyButton{
                id: bt4;
                width: 80;
                text: "加入列表";
                property string tempImg: "";
                onClicked: {
                    if(photoPreview.source != ""){
                        myIndicator.running = true;
                        tempImg = photoPreview.source;
                        fd.source = photoPreview.path;
                        console.log(photoPreview.source, photoPreview.path)
                        fd.start(3);
                    }

                }

            }

            MyButton{
                id: bt5;
                width: 80;
                text: "更新列表";
                onClicked: {
                    control.currentIndex = 2;
                    for(var i = 0; i < imgLibrary.children.length; i++)
                        imgLibrary.children[i].destroy();
                    for(var i = 0; i < imgList.length; i++){
                        var com = Qt.createComponent("MyImage.qml");
                        var o = com.createObject(imgLibrary);
                        o.source = imgList[i];
                        o.text = "图 " + (i + 1);
                    }
                }
            }
        }
    }

    Rectangle{
        id: separator1;
        anchors.bottom: statusArea.top;
        width:parent.width;
        height: 1;
        color: "darkgray"
    }

    Text{
        id: statusArea;
        anchors.left: parent.left;
        anchors.leftMargin: 4;
        anchors.bottom: parent.bottom;
        width: parent.width;
        height: 29;
        verticalAlignment: Text.AlignVCenter;
        horizontalAlignment: Text.AlignLeft;
        font.pointSize: 10;
        property string msg;
        text: " 消息栏： " + statusArea.msg;
    }


    Rectangle{
        id: separator2;
        anchors.left: leftArea.right;
        height: parent.height - 30;
        width: 1;
        color: "darkgray"
    }

    Page{
        id: rightArea;
        anchors.left: leftArea.right;
        anchors.leftMargin: 1;
        width: parent.width - leftArea.width;
        height: parent.height - 26;
        header:TabBar{
            id: control
            currentIndex: swipview.currentIndex;
            background: Rectangle{color: Qt.rgba(0.02, 0.85, 0.98, 1.0)}
            MyTabButton{
                index: 0;
                text: "识 别"
                height: control.height;
                currentIndex: control.currentIndex
            }
            MyTabButton{
                index: 1;
                text: "匹 配"
                height: control.height;
                currentIndex: control.currentIndex
            }
            MyTabButton{
                index: 2;
                text: "列 表"
                height: control.height;
                currentIndex: control.currentIndex
            }
        }

        BusyIndicator{
            id: myIndicator;
            anchors.centerIn: parent;
            running: false
            z:10;
        }


        SwipeView {
            id: swipview;
            anchors.fill: parent;
            width: parent.width;
            currentIndex: control.currentIndex;
            clip: true
            Page{
                id: photoInfoPreview;


                Image {
                    id: photoPreview_2;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    width: 200;
                    height: 150;
                    onSourceChanged: {
                        //清除子item
                        for(var i = 0; i < photoPreview_2.children.length; i++)
                            photoPreview_2.children[i].destroy();
                    }
                    function updateFlag(index)
                    {
                        for(var i = 0; i < children.length; i++)
                            children[i].isChoosed = false;
                        children[index].isChoosed = true;

                    }
                }
                FaceImage{
                    id: faceImage;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: photoPreview_2.bottom;
                    anchors.topMargin: 30;
                    visible: false;
                }
                footer: TabBar{
                    id: tabBar;
                    MyTabButton{
                        text: "上一页"
                        index: 0;
                        currentIndex: tabBar.currentIndex;
                        onClicked: { faceImage.showPix(-1); }
                    }
                    MyTabButton{
                        text: "下一页"
                        index: 1;
                        currentIndex: tabBar.currentIndex;
                        onClicked: { faceImage.showPix(1); }
                    }
                }

            }
            Rectangle{
                id: matchPreview;

                MyImage{
                    id: photoPreview_3
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: parent.top;
                    anchors.topMargin: 10;
                    source: bt3.tempImg;
                    text: "原 图"
                }
                MyImage {
                    id: matchedImg;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: photoPreview_3.bottom;
                    anchors.topMargin: 10;
                    text:  "匹配图"
                }
                Text{
                    id: confidence;
                    anchors.horizontalCenter: parent.horizontalCenter;
                    anchors.top: matchedImg.bottom;
                    anchors.topMargin: 50;
                    width: parent.width;
                    height: 50;
                    font.pointSize: 18;
                    font.bold: true;
                    color:"#1E1E27"
                    horizontalAlignment: Text.AlignHCenter;
                    verticalAlignment: Text.AlignVCenter;
                    property string myText;
                    text: matchedImg.source == "" ? "" : "相似度: " + myText + "%";
                }
            }
            ScrollView{
                id: imgLibraryPreview;
                Column{
                    id: imgLibrary;
                    x: (swipview.width - 200) / 2;
                    y: 10;
                    spacing: 10;
                }
            }
        }
    }
}
