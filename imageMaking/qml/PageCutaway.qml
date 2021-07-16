import QtQuick 2.15
import QtQuick.Controls 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Page{
    backgroundColor: "white"
    id: root
    property alias img: image
    property bool gridrect: false
    property bool radiusrect: false
    property int imgmirro: 1
    property int imgmirro2: 1

    Button{
        anchors.top: NavigationBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter            //顶部居中
        width: root.width/5
        height:root.height/20
        id:saveBtn
        display: "TextUnderIcon"
        text: "保存"
        icon.source:"qrc:/picture/保存.png"                            //保存按钮
        icon.width: saveBtn.width/2
        icon.height: saveBtn.height/2
        onPressed: cutaway.save()
}


    Rectangle{
        id:roundwindow                                        //弹出窗口
        x:0
        y:root.height-bottomRect.height-root.height/10

        //visible: false
        width: grid.width
        height: root.height/8
        color: "lightblue"
        AppSlider{
            id:img_slider
            anchors.centerIn: parent
            from: 0
            to:imageBtn.width/6
            orientation:Qt.Horizontal
            onMoved: {
                for (var i = 0; i < rep.count; i++) {
                    rep.itemAt(i).radius = value
                }
            }
            Text{
                anchors.right: parent.left
                text: "圆角"
                font.pixelSize: 50

            }
        }
    }

    Column{
        id:grid
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height-saveBtn.height
        Rectangle{
            id: topRect
            width:grid.width                    //间隔栏
            height:grid.height/9
        }
        Rectangle{
            id:imageRect
            width:grid.width
            height:grid.height-pop.height-bottomRect.height-topRect.height
            Button{
                id:imageBtn
                anchors.fill: parent                           //添加图片框
                Text{
                    id:imgText
                    text: "请添加图片"
                    anchors.centerIn: parent
                }
                onPressed: {
                    dialogs.openFileDialog()
                    imageBtn.enabled = false
                    imgText.visible = false
                }
                Grid{
                    id:gridBrect
                    anchors.fill: parent
                    columns: 3
                    visible: false
                    Repeater{
                        id: rep
                        model: 9
                        Rectangle{
                            width: imageBtn.width/3
                            height: imageBtn.height/3
                            color: "white"
                            clip: true
                        }
                    }
                }
                Image {
                    id:image
                    smooth: true
                    visible: false
                    anchors.fill: parent
                    asynchronous: true
                    antialiasing: true
                    source: dialogs.fileOpenDialog.fileUrl
                }

                OpacityMask{
                    id:img_mask
                    anchors.fill: image
                    source: image
                    maskSource: gridBrect
                    visible: true
                    antialiasing: true
                }
            }
        }
        Rectangle{
            id:pop
            width: grid.width
            height:root.height/6                       //间隔栏
            opacity:0                                //纯透明
            color:"white"

        }

        Rectangle{
            id:bottomRect
            height:grid.height/6
            width: grid.width
            Flickable{
                flickableDirection: Flickable.HorizontalFlick      //可拖动
                width: root.width
                height: bottomRect.height
                contentWidth: rowBtn.width
                contentHeight: rowBtn.height
                boundsBehavior: Flickable.StopAtBounds           //禁止拖出栏边界

                Row{
                    id:rowBtn                                    //底部按钮栏

                    Button{
                        id:grid1
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/九格切图.png"
                        display: "TextUnderIcon"
                        text: "网格"
                        icon.width: grid1.width/3
                        icon.height:grid1.height/3
                    }

                    Button{
                        id:round
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/圆角.png"
                        display: "TextUnderIcon"
                        text: "圆角"
                        icon.width: round.width/3
                        icon.height:round.height/3
                        onClicked: {                            //判断弹出窗口位置，进行对应弹出动画
                            if(roundwindow.y ==root.height-bottomRect.height-root.height/10)
                            {
                                menuStartAnim.start()
                            }
                            else
                            {
                                menuStopAnim.start()

                            }
                        }
                    }
                    ParallelAnimation{
                        id:menuStartAnim
                        //属性动画
                        NumberAnimation{
                            target: roundwindow
                            properties: "y"
                            from:root.height-bottomRect.height-root.height/10
                            to:root.height-bottomRect.height-root.height/10-root.height/8
                            //动画持续时间，毫秒
                            duration: 500
                            //动画渐变曲线
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target: roundwindow
                            properties: "opacity"
                            from: 0.2
                            to: 0.8
                            duration: 500;
                            easing.type: Easing.Linear
                        }
                    }
                    ParallelAnimation{
                        id: menuStopAnim
                        NumberAnimation{
                            target: roundwindow
                            properties: "y"
                            from: root.height-bottomRect.height-root.height/10-root.height/8
                            to:root.height-bottomRect.height-root.height/10
                             //动画持续时间，毫秒
                            duration: 200;
                             //动画渐变曲线
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target:roundwindow
                            properties: "opacity"
                            from: 0.8
                            to: 0.2
                            duration: 200;
                            easing.type: Easing.Linear
                        }
                    }

                    Button
                    {
                        id:replace
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/替换.png"
                        display: "TextUnderIcon"
                        text: "替换"
                        icon.width: replace.width/3
                        icon.height:replace.height/3
                        onPressed: {
                            dialogs.openFileDialog()
                        }

                    }

                    Button{
                        id:rotating
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/旋转.png"
                        display: "TextUnderIcon"
                        text: qsTr("旋转")
                        icon.width: rotating.width/3
                        icon.height:rotating.height/3
                        onPressed: {
                            img_mask.rotation += 90
                        }
                    }

                    Button{
                        id:level
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/水平对齐.png"
                        display: "TextUnderIcon"
                        text: qsTr("水平")
                        icon.width: level.width/3
                        icon.height:level.height/3
                        onPressed: {
                            if(imgmirro === 1){
                                image.mirror = true
                                imgmirro=imgmirro+1
                            }else{
                                image.mirror = false
                                imgmirro=imgmirro-1
                            }
                        }
                    }

                    Button{
                        id:vertical
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/垂直居中.png"
                        display: "TextUnderIcon"
                        text: qsTr("垂直")
                        icon.width: vertical.width/3
                        icon.height:vertical.height/3
                        onPressed: {
                            if(imgmirro2 === 1){
                                img_mask.rotation = 180
                                imgmirro2=imgmirro2+1
                            }else{
                                img_mask.rotation = 0
                                imgmirro2=imgmirro2-1
                            }
                        }
                    }

                    Button{
                        id:amplification
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/放大.png"
                        display: "TextUnderIcon"
                        text: qsTr("放大")
                        icon.width: amplification.width/3
                        icon.height:amplification.height/3
                        onPressed: {
                            img_mask.scale += 0.1
                        }
                    }


                    Button{
                        id:narrow
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/缩小.png"
                        display: "TextUnderIcon"
                        text: qsTr("缩小")
                        icon.width: narrow.width/3
                        icon.height:narrow.height/3
                        onPressed: {
                            img_mask.scale -= 0.1
                            if(img_mask.scale<0){
                                img_mask.scale = 0
                            }
                        }
                    }
                }
            }
        }
    }

    ImageCutaway{
        id:cutaway
    }
    Dialogs{
        id:dialogs
        //        fileOpenDialog.selectMultiple: true
    }
}


