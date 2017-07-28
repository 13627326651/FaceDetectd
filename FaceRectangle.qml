import QtQuick 2.0

Item{
    id:faceRectangle;
    z: 10;
    property real wRation: 200 / parent.sourceSize.width;
    property real hRation: 150 / parent.sourceSize.height;
    property color borderColor: Qt.rgba(Math.random(), Math.random(), Math.random());
    property bool isChoosed: false;

    function updateFaceRect(frect, i)
    {
        x = Math.round(wRation * frect[0])
        y = Math.round(hRation * frect[1]) - canvas.height;
        width = Math.round(wRation * frect[2])
        height = Math.round(hRation * frect[3]) + canvas.height
        faceText.text = i + 1;
    }

    Canvas{
        id: canvas;
        width: parent.width;
        height: 30;
        anchors.bottom: faceRect.top;
        anchors.left: parent.left;
        visible: parent.isChoosed;
        antialiasing: true;

        property var borderLength: width / 2;
        property var spacing: 10;

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
            color: faceRectangle.borderColor
            width: contentWidth;
            height: contentHeight;
            font.pointSize: 12;
        }
    }
}
