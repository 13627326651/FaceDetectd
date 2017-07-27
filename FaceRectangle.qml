import QtQuick 2.0

Item{
    id:faceRectangle;
    z: 10;
    property real wRation: 200 / parent.sourceSize.width;
    property real hRation: 150 / parent.sourceSize.height;
    Rectangle{x:0; y:0; width:parent.width; height:1; color:"red";}
    Rectangle{x:0; y:parent.height-1; width:parent.width; height:1; color:"red";}
    Rectangle{x:0; y:0; width: 1; height: parent.height; color: "red"}
    Rectangle{x:parent.width-1; y:0; width: 1; height: parent.height; color: "red"}
    Text{
        id: faceText;
        anchors.centerIn: parent;
        color: "red"
        width: contentWidth;
        height: contentHeight;
    }

    function updateFaceRect(frect, i)
    {
        x = Math.round(wRation * frect[0])
        y = Math.round(hRation * frect[1])
        width = Math.round(wRation * frect[2])
        height = Math.round(hRation * frect[3])
        faceText.text = i + 1;
    }
}
