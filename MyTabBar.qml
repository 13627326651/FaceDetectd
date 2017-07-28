import QtQuick 2.6
import QtQuick.Controls 2.2
TabBar{
    id: tabBar;
    background: Rectangle{color: Qt.rgba(0.02, 0.85, 0.98, 1.0)}
    currentIndex: 0;
    MyTabButton{
        index: 0;
        text: "识 别"
        height: tabBar.height;
        currentIndex: tabBar.currentIndex
    }
    MyTabButton{
        index: 1;
        text: "匹 配"
        height: tabBar.height;
        currentIndex: tabBar.currentIndex
    }
    MyTabButton{
        index: 2;
        text: "列 表"
        height: tabBar.height;
        currentIndex: tabBar.currentIndex
    }
}


