import QtQuick 2.6
import QtQuick.Controls 2.2

TabButton{
    id: tabButton;
    font.pointSize: 15;
    property var index;
    property var currentIndex;
    contentItem: Text{
        height: tabButton.height;
        color: Qt.rgba(1, 1, 1, 1);
        horizontalAlignment: Text.AlignHCenter;
        verticalAlignment: Text.AlignVCenter;
        font.pointSize: 15;
        text: tabButton.text;
    }

    background: Rectangle{
        height: tabButton.height;
        color:  tabButton.currentIndex == tabButton.index ?  Qt.rgba(0.03, 0.58, 1, 1) : Qt.rgba(0.02, 0.85, 0.98, 1.0);
        border.width: 1;
        border.color: Qt.rgba(0.03, 0.58, 1, 1);
    }
}
