import QtQuick 2.0

Item{
    id: item;
    property string pixName: "";
    property var faces;
    property int currentIndex: 0;

    function init(faces)
    {
        currentIndex = 0;
        item.faces = faces;
        showPix(0);
    }

    function showPix(offset)
    {
        if(faces.length > 0)
        {
            currentIndex = (currentIndex + offset + faces.length) % faces.length

            var faceAttributes = faces[currentIndex].faceAttributes;
            var max = 0;
            var myEmotion;
            for(var emotion in faceAttributes.emotion)
            {
                if(faceAttributes.emotion[emotion] > max)
                {
                    max = faceAttributes.emotion[emotion]
                    myEmotion = emotion;
                }
            }
            pixName = "images/" + myEmotion + ".png";
            descriptionText.age = faceAttributes.age;
            descriptionText.gender = faceAttributes.gender;
            descriptionText.glasses = faceAttributes.glasses;
            descriptionText.eyemakeup = faceAttributes.makeup.eyeMakeup;
            descriptionText.lipmakeup = faceAttributes.makeup.lipMakeup;

            photoPreview.currentIndex = currentIndex;

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
        onRunningChanged:{
            console.log("running " , running);
        }

        back: Image{
            id: backImage;
            anchors.fill:parent;
            source: pixName;
            width: 200;
            height: 200;
            fillMode: Image.PreserveAspectFit
        }
        front:   Rectangle{
            id: frontRect;
            anchors.fill: parent;
            border.width: 1;
            border.color: "darkgray"
            color:  "#CCC3EE"
            Text{
                anchors.centerIn: parent;
                width: contentWidth;
                height: contentHeight;
                font.pointSize: 14;
                text: "查看" + (item.currentIndex + 1 )+ "号人物"
                color: flipArea.containsMouse ? "blue" : "black";
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
         console.log(flipable.flipped, flipable.running)//false false, true false, true true, true false
//                switch(pixName)
//                {
//                case "images/anger2.png":
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
//                case "images/sadness.png":
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
}

