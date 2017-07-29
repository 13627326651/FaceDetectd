import QtQuick 2.6
import QtQuick.Controls 2.2


Canvas{
    id: canvas;
    anchors.fill: parent;
    property var faceLandmarks;

    function paint(faceLandmarks , ctx){
        for(var obj in faceLandmarks)
        {
            var destX = faceLandmarks[obj].x * parent.wRation;
            var destY = faceLandmarks[obj].y * parent.hRation;
            console.log(destX, destY)

            ctx.fillStyle = "red"
            ctx.beginPath();
            ctx.arc(destX, destY, 5, 0, 360)
            ctx.closePath()
            ctx.fill();
        }
    }

    onPaint: {
        var ctx = getContext("2d")
        canvas.paint(canvas.faceLandmarks, ctx);
    }
}
