import QtQuick 2.6
import QtQuick.Controls 2.2
CheckBox{
    id: checkBox;
    checked: true;
    enabled: false;
    indicator: Rectangle
    {
        implicitHeight: 20;
        implicitWidth: 20;
        border.width: 1;
        border.color: "green"
        radius: 2;
        Rectangle{
            width: 10;
            height:10;
            x:5;
            y:5;
            color: "green"
            radius: 5;
            visible: checkBox.checked;
        }
    }
}
