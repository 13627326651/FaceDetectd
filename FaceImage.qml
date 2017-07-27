import QtQuick 2.0

Item{
    id: item;
    property string age: ""
    property string gender: ""
    property string glasses: ""
    property string pixName: "";
    property var faces: new Array();
    property int currentIndex:0;
    function showPix(offset)
    {
        if(faces.length > 0)
        {
            currentIndex = (currentIndex + offset + faces.length) % faces.length

            var infos = faces[currentIndex].split(',')

            pixName = "images/" + infos[5]
            descriptionText.age = infos[1]
            descriptionText.gender = infos[2]
            descriptionText.glasses = infos[4]

            flipable.flipped = false;
            item.visible = true;

            ani_2.start()
        }
    }
    NumberAnimation{
        id: ani_2;
        target: item;
        properties: "scale"
        from: 0
        to: 1
    }

    Flipable {
        id: flipable
        width: 200
        height: 200
        anchors.horizontalCenter: parent.horizontalCenter;
        property bool flipped: false
        property bool running: transition.running;
        back: Image{
            id: frontImage;
            anchors.fill:parent;
            source: pixName;
            width: 200;
            height: 200;
            fillMode: Image.PreserveAspectFit
            onSourceChanged: {

                    //console.log("***************ready**********", source)
                    //                switch(pixName)
                    //                {
                    //                case "images/anger.jpg":
                    //                    player.source = "sound/anger.wav"
                    //                    player.play();
                    //                    break;
                    //                case "images/fear.png":
                    //                    player.source = "sound/fear.wav"
                    //                    player.play();
                    //                    break;
                    //                case "images/happiness.png":
                    //                    player.source = "sound/happiness.wav"
                    //                    player.play();
                    //                    break;
                    //                case "images/sadness.jpg":
                    //                    player.source = "sound/sadness.wav"
                    //                    player.play();
                    //                    break;
                    //                case "images/surprise.png":
                    //                    player.source = "sound/surprise.wav"
                    //                    player.play();
                    //                    break;
                    //                }

            }
        }
        front:   Rectangle{
            id: backImage;
            anchors.fill: parent;
            color: "lightgray"
            border.width: 1;
            border.color: "darkgray"
            Text{
                anchors.centerIn: parent;
                width: contentWidth;
                height: contentHeight;
                font.pointSize: 14;
                text: "查看" + (item.currentIndex + 1 )+ "号人物"
                color: flipArea.containsMouse ? "blue" : "black"
            }

        }

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        transitions: Transition {
            id: transition
            to: "back"
            NumberAnimation { target: rotation; property: "angle"; duration: 1000; }

        }

        MouseArea {
            id: flipArea
            anchors.fill: parent
            onClicked: flipable.flipped = true
        }
    }
    DescriptionItem{
        id: descriptionText;
        anchors.top: flipable.bottom;
        anchors.topMargin: 20;
        anchors.left: flipable.left;
        visible: flipable.flipped && !flipable.running
        onVisibleChanged: {
            if(visible){
                console.log("***************ready**********", source)
                switch(pixName)
                {
                case "images/anger.jpg":
                    player.source = "sound/anger.wav"
                    player.play();
                    break;
                case "images/fear.png":
                    player.source = "sound/fear.wav"
                    player.play();
                    break;
                case "images/happiness.png":
                    player.source = "sound/happiness.wav"
                    player.play();
                    break;
                case "images/sadness.jpg":
                    player.source = "sound/sadness.wav"
                    player.play();
                    break;
                case "images/surprise.png":
                    player.source = "sound/surprise.wav"
                    player.play();
                    break;
                }
            }
        }
    }
}

