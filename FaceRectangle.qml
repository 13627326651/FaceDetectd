import QtQuick 2.0

Item{
    id:faceRectangleItem;
    z: 10;
    property color borderColor: Qt.rgba(Math.random(), Math.random(), Math.random());
    property int index: 0;
    property int currentIndex: parent.currentIndex;
    onCurrentIndexChanged: {
        if(faceRectangleItem.currentIndex == -1){
            console.log("facerectangle destroy....")
            faceRectangleItem.destroy();
        }
    }

    function updateFaceRect(faceRectangle, i)
    {
        x = Math.round(parent.wRation * faceRectangle.left)
        y = Math.round(parent.hRation * faceRectangle.top) - canvas.height;
        width = Math.round(parent.wRation * faceRectangle.width)
        height = Math.round(parent.hRation * faceRectangle.height) + canvas.height
        faceText.text = i + 1;
    }


    Canvas{
        id: canvas;
        width: parent.width;
        height: 50;
        anchors.bottom: faceRect.top;
        anchors.left: parent.left;
        visible: parent.index == parent.currentIndex;
        antialiasing: true;

        property var borderLength: 30;
        property var spacing: 20;

        onPaint: {
            var ctx = getContext("2d");
            ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
            ctx.lineWidth = 1;
            ctx.strokeStyle = Qt.rgba(0, 0, 1, 1);
            ctx.beginPath();
            ctx.moveTo( (parent.width - borderLength) / 2, 2);
            ctx.lineTo( (parent.width - borderLength) / 2 + borderLength, 2);
            ctx.lineTo( parent.width / 2, height - spacing);
            ctx.lineTo( (parent.width - borderLength) / 2, 2);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
        }
    }

    Item{
        id: faceRect;
        anchors.bottom: parent.bottom;
        anchors.left: parent.left;
        width: parent.width;
        height: parent.height - canvas.height;
        Rectangle{x:0; y:0; width:parent.width; height:2; color:borderColor;}
        Rectangle{x:0; y:parent.height-2; width:parent.width; height:2; color:borderColor;}
        Rectangle{x:0; y:0; width: 2; height: parent.height; color: borderColor}
        Rectangle{x:parent.width-2; y:0; width: 2; height: parent.height; color: borderColor}
        Text{
            id: faceText;
            anchors.centerIn: parent;
            color: faceRectangleItem.borderColor
            width: contentWidth;
            height: contentHeight;
            font.pointSize: 20;
        }
    }
}
