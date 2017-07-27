import QtQuick 2.6
import QtQuick.Controls 2.2
Item{
    id: container;
    property string age;
    property string gender;
    property string glasses;
    Column{
        anchors.fill: parent;
        spacing: 10;
        Row{
            Text{
                width:contentWidth;
                height:contentHeight;
                font.pointSize: 12;
                color: "#1E1E27";
                text: "芳龄: "
                anchors.verticalCenter: parent.verticalCenter;
            }
            Text{
                width:contentWidth;
                height:contentHeight;
                font.pointSize: 12;
                color: "#1E1E27";
                text: container.age;
                anchors.verticalCenter: parent.verticalCenter;
            }

        }
        Row{
            spacing: 10;
            Text{
                width:contentWidth;
                height:contentHeight;
                font.pointSize: 12;
                color: "#1E1E27";
                text: "性别: "
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image{
                source: "images/female.png"
            }
            MyCheckBox{
                checked: container.gender == "female"
                anchors.verticalCenter: parent.verticalCenter;
            }

            Image{
                source: "images/male.png"

            }
            MyCheckBox{
                checked: container.gender == "male"
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
        Row{
            spacing: 3;
            Text{
                width:contentWidth;
                height:contentHeight;
                font.pointSize: 12;
                color: "#1E1E27";
                text: "眼镜: "
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image{
                source: "images/glasses.png"
                anchors.verticalCenter: parent.verticalCenter;
            }
            MyCheckBox{
                checked: container.glasses != "NoGlasses"
            }
        }
    }

}

