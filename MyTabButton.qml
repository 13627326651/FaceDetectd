import QtQuick 2.6
import QtQuick.Controls 2.2

TabButton{
    id: tabButton;
    font.pointSize: 15;
    property var index;
    property var currentIndex;
    contentItem: Text{
        height: tabButton.height;
        color: "#353637"
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        font.pointSize: 15;
        text: tabButton.text;
    }

    background: Rectangle{
        height: tabButton.height;
        color:  tabButton.currentIndex == tabButton.index ?   "#D0C2EF" : "#F9E5E6";
        border.width: 1;
        border.color: "darkgray"
    }
}
