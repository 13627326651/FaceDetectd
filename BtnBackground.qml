import QtQuick 2.6
import QtQuick.Controls 2.2
CheckBox{
    checked: true;
    enabled: false;

    indicator: Rectangle
    {
        implicitHeight: 40;
        implicitWidth: 40;
        border.width: 1;
        border.color: "green"
        radius: 2;
        Rectangle{
            width: 26;
            height:26;
            x:7;
            y:7;
            color: "green"
            radius: 4;
        }
    }
}
