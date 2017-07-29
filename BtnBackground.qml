
import QtQuick 2.6;
Item{
    width:200;
    height:190;
    property string source;
    property string text;
    Image{
        id: img;
        anchors.horizontalCenter: parent.horizontalCenter;
        anchors.top: parent.top;
        width: parent.width;
        height: 150;
        //source: parent.source;
        source: "images/fear.png"
        MouseArea{
            onClicked: {

            }
        }
    }
    Text{
        anchors.horizontalCenter: img.horizontalCenter;
        anchors.top: img.bottom;
        anchors.bottomMargin: 10;
        width:parent.width;
        height: 30;
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignBottom;
        font.pointSize: 14;
        color: "#353637"
        clip:true;
        elide:Text.ElideRight;
        text: img.source == "" ? "" : parent.text;
    }
}
