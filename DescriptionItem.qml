import QtQuick 2.6
import QtQuick.Controls 2.2
Item{
    id: container;
    property string age;
    property string gender;
    property string glasses;
    property bool eyemakeup: false;
    property bool lipmakeup: false;
    Column{
        anchors.fill: parent;
        spacing: 10;
        Row{
            spacing: 20;
            Text{
                width:contentWidth;
                height:contentHeight;
                font.pointSize: 12;
                color: "#1E1E27";
                text: "年龄: "
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
            spacing: 18;
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
                anchors.verticalCenter: parent.verticalCenter;
            }
            MyCheckBox{
                checked: container.gender == "female"
                anchors.verticalCenter: parent.verticalCenter;
            }

            Image{
                source: "images/male.png"
                rotation: 180;
                anchors.verticalCenter: parent.verticalCenter;

            }
            MyCheckBox{
                checked: container.gender == "male"
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
        Row{
            spacing:11;
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
                text: "化妆: "
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image{
                source: "images/eyemakeup.png"
                anchors.verticalCenter: parent.verticalCenter;
            }
            MyCheckBox{
                checked: container.eyemakeup;
                anchors.verticalCenter: parent.verticalCenter;
            }
            Image{
                source: "images/lipmakeup.png"
                anchors.verticalCenter: parent.verticalCenter;
            }
            MyCheckBox{
                checked: container.lipmakeup;
                anchors.verticalCenter: parent.verticalCenter;
            }
        }
    }

}

