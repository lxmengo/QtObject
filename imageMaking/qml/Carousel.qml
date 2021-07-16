import QtQuick 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3

Item{
    id: item

    ListModel{
        id: changeModel

        ListElement {
            source: "qrc:/picture/04.jpg"
        }
        ListElement {
            source: "qrc:/picture/06.jpg"
        }
        ListElement {
            source: "qrc:/picture/13.jpg"
        }
        ListElement {
            source: "qrc:/picture/15.jpg"
        }
        ListElement {
            source: "qrc:/picture/18.jpg"
        }
        ListElement {
            source: "qrc:/picture/19.jpg"
        }
    }

    Rectangle{
        id: ret
        anchors.fill: parent
        clip: true
        anchors.horizontalCenter: parent.horizontalCenter
        Image {
            id: preImage
            width: parent.width
            height: parent.height - 70
            anchors.right: changeImage.left
            anchors.rightMargin: 0
            anchors.top: changeImage.top
            anchors.bottom: changeImage.bottom
            source: changeModel.get(0).source
            fillMode: Image.PreserveAspectCrop
        }
        Image {
            id: changeImage
            x: 0
            width: parent.width
            height: parent.height - 70
            source: changeModel.get(0).source
            anchors.verticalCenter: parent.verticalCenter
            fillMode: Image.PreserveAspectCrop
            NumberAnimation {
                id: anim
                target: changeImage
                properties: "x"
                from: ret.width-30
                to: 0
                duration: 2000
                easing.type: Easing.OutQuint
                easing.amplitude: 2.0
                easing.period: 1.5
                onStopped: {
                    preImage.source = changeImage.source
                }
            }
        }
        Row {
            id:pointsRow
            height: 30
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 10
            Repeater {
                id:points
                model: changeModel
                Rectangle {
                    width: 30
                    height: 30
                    radius: 15
                    color: "transparent"
                    border.width: 1
                    border.color: "orange"
                    MouseArea{
                        id: mouseArea
                        anchors.fill: parent
                        cursorShape:Qt.PointingHandCursor
                        onClicked: {
                            timer.stop()
                            if(timer.index !== index)
                            {
                                if(anim.running){
                                    anim.stop()
                                    points.itemAt(timer.index).color = "transparent"
                                    timer.index = index
                                    points.itemAt(index).color = "orange"
                                    changeImage.source = changeModel.get(index).source
                                    anim.start()
                                }
                            }
                            timer.start()
                        }
                    }
                }
            }
        }
    }

    Timer{
        property int index: 0
        id: timer
        interval: 4000;
        repeat: true
        onTriggered: {
            if(anim.running === false){
                points.itemAt(index).color = "transparent"
                index++
                index = index % changeModel.count
                points.itemAt(index).color = "orange"
                changeImage.source = changeModel.get(index).source
                anim.start()
            }
        }
    }
    Component.onCompleted: {
        points.itemAt(0).color = "orange"
        timer.start()
    }
}
