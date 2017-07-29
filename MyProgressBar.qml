import QtQuick 2.6
import QtQuick.Controls 2.2

ProgressBar {
     id: control
     value: 0.9932
     padding: 2

     background: Rectangle {
         implicitWidth: 200
         implicitHeight: 20
         color: "#EEEEEE"
         radius: 3
     }

     contentItem: Item {
         implicitWidth: 200
         implicitHeight: 18
         Rectangle {
             width: control.visualPosition * parent.width
             height: parent.height
             radius: 2
             color: "#53B8C0"
             Text{
                 anchors.centerIn: parent;
                 width: contentWidth;
                 height: contentHeight;
                 font.pointSize: 12;
                 font.bold: true;
                 text: "相似度：" + Math.round(control.value * 10000) / 100 + "%"
             }
         }
     }
 }
