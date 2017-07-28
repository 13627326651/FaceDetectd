import QtQuick 2.6
import QtQuick.Controls 2.2
Canvas{
    id: canvas;
    width: 40;
    height: 20;
    property var borderLength: width / 2;
    onPaint: {
        var ctx = getContext("2d");
        ctx.fillStyle = Qt.rgba(1, 0, 0, 1);
        ctx.lineWidth = 2;
        ctx.strokeStyle = Qt.rgba(0, 0, 1, 1);
        ctx.beginPath();
        ctx.moveTo( (parent.width - borderLength) / 2, 0);
        ctx.lineTo( (parent.width - borderLength) / 2 + borderLength, 0);
        ctx.lineTo( parent.width / 2, parent.height);
        ctx.lineTo( (parent.width - borderLength) / 2, 0);
        ctx.closePath();
        ctx.stroke();
        ctx.fill()
    }
    transform:Rotation{
        id: rotation;
        origin.x: width / 2; origin.y: height / 2;
        axis.x: 0; axis.y: 1; axis.z: 0;
        angle: 0;
    }
    states:State{
        id: "firstStat"
        when: m.pressed;
        PropertyChanges {
            target: rotation
            angle: 180;
        }
    }
    transitions: Transition{
        to: "firstStat"
        NumberAnimation{
            target: rotation;
            property:"angle"
            duration: 100;
        }
    }
    MouseArea{
        id: m
        anchors.fill: parent;
    }

}
