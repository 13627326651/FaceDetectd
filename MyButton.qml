import QtQuick 2.6
import QtQuick.Controls 2.2

Button{
    id: button;
    font.pointSize: 10;
    hoverEnabled: true;
    autoRepeat: false;
    contentItem: Text{
        height: button.height;
        color: "#353637"
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        font.pointSize: 15;
        text: button.text;
    }

    background: Rectangle{
        height: button.height;
        color:  button.down ?  "#D0C2EF" : "#F9E5E6";
        border.width: 1;
        border.color: "darkgray";
    }
}
