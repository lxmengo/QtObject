import QtQuick 2.15
import QtQuick.Controls 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Page{
    backgroundColor: "white"
    id: root

    Button{
        anchors.top: NavigationBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter             //顶部居中
        width: root.width/5
        height:root.height/20
        id:saveBtn
        display: "TextUnderIcon"
        text: "保存"
        icon.source:"qrc:/picture/保存.png"                         //保存按钮
        icon.width: saveBtn.width/2
        icon.height: saveBtn.height/2
        onPressed: imageRect.grabToImage(function(result) {
            result.saveToFile("something.png");
            console.log("save")
        });
    }

    Rectangle{
        id:vaguewindow                                       //弹出窗口
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
                fastBlur.radius = value
            }
            Text{
                anchors.right: parent.left
                text: "模糊"
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
            width:grid.width
            height:grid.height/9                      //间隔栏

        }

        Rectangle{
            id:imageRect
            width:grid.width
            height:grid.height-pop.height-bottomRect.height-topRect.height
            Button{
                id:imaegBtn
                anchors.fill: parent
                Text{
                    id:imgText
                    text: "请添加图片"                      //添加图片框
                    anchors.centerIn: parent
                }
                onPressed: {
                    dialogs.openFileDialog()
                    imageBtn.enabled = false
                    imgText.visible = false
                }
                Image {
                    id:image
                    smooth: true
                    anchors.fill: parent
                    asynchronous: true
                    antialiasing: true
                    source: dialogs.fileOpenDialog.fileUrl
                }
                FastBlur{
                    id:fastBlur
                    anchors.fill: image
                    source: image
                    radius: 0
                }
            }
        }
        Rectangle{
            id:pop
            width: grid.width
            height:root.height/6                //间隔栏
            opacity:0                           //纯透明
            color:"white"

        }

        Rectangle{
            id:bottomRect
            height:grid.height/6
            width: grid.width
            Flickable{
                flickableDirection: Flickable.HorizontalFlick      //可拖动
                width: root.width
                height: filter.height
                contentWidth: rowBtn.width
                contentHeight: rowBtn.height
                boundsBehavior: Flickable.StopAtBounds          //禁止拖出栏边界
                Row{
                    id:rowBtn

                    Button{
                        id:filter
                        width: root.width/5
                        height: bottomRect.height              //底部按钮栏
                        icon.source: "qrc:/picture/滤镜.png"
                        display: "TextUnderIcon"
                        text: "滤镜"
                        icon.width: filter.width/3
                        icon.height:filter.height/3
                    }


                    Button{
                        id:tailoring
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/剪裁.png"
                        display: "TextUnderIcon"
                        text: "裁剪"
                        icon.width: tailoring.width/3
                        icon.height:tailoring.height/3
                    }

                    Button
                    {
                        id:vague
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/模糊图标.png"
                        display: "TextUnderIcon"
                        text: "模糊"
                        icon.width: vague.width/3
                        icon.height:vague.height/3
                        onClicked: {                          //判断弹出窗口位置，进行对应弹出动画
                            if(vaguewindow.y ==root.height-bottomRect.height-root.height/10)
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
                        id: menuStartAnim
                        //属性动画
                        NumberAnimation{
                            target: vaguewindow
                            properties: "y"
                            from:root.height-bottomRect.height-root.height/10
                            to:root.height-bottomRect.height-root.height/10-root.height/8
                            //动画持续时间，毫秒
                            duration: 500
                            //动画渐变曲线
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target: vaguewindow
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
                            target: vaguewindow
                            properties: "y"
                            from: root.height-bottomRect.height-root.height/10-root.height/8
                            to:root.height-bottomRect.height-root.height/10
                            duration: 200;
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target:vaguewindow
                            properties: "opacity"
                            from: 0.8
                            to: 0.2
                            duration: 200;
                            easing.type: Easing.Linear
                        }
                    }

                    Button{
                        id:polygon
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/多边形.png"
                        display: "TextUnderIcon"
                        text: qsTr("多边形")
                        icon.width: polygon.width/3
                        icon.height:polygon.height/3
                    }
                    Button{
                        id:writeBtn
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/涂鸦.png"
                        display: "TextUnderIcon"
                        text: qsTr("涂鸦")
                        icon.width: writeBtn.width/3
                        icon.height:writeBtn.height/3
                    }

                    Button{
                        id:textBtn
                        width: root.width/5
                        height: bottomRect.height
                        icon.source: "qrc:/picture/文字.png"
                        display: "TextUnderIcon"
                        text: qsTr("文字")
                        icon.width: textBtn.width/3
                        icon.height:textBtn.height/3
                    }
                }
            }
        }
    }
    Dialogs{
        id:dialogs
    }
}
