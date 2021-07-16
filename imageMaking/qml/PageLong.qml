import QtQuick 2.15
import QtQuick.Controls 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3


Page{
    backgroundColor: "white"
    id: root

    Button{
        anchors.top: NavigationBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter           //顶部居中
        width: root.width/5
        height:root.height/20
        id:saveBtn
        display: "TextUnderIcon"
        text: "保存"
        icon.source:"qrc:/picture/保存.png"                  //保存按钮
        icon.width: saveBtn.width/2
        icon.height: saveBtn.height/2
        onPressed: {
            imageLong.saveImage()
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
            height:grid.height/9                               //间隔栏

        }
        Rectangle{
            id:imageRect
            width:grid.width
            height:grid.height-pop.height-bottomRect.height-topRect.height
            Button{
                id:imageBtn
                anchors.fill: parent
                Text{
                    id:imgText
                    text: "请添加图片"                         //添加图片框
                    anchors.centerIn: parent
                }
                onPressed: {
                    dialogs.openFileDialog()
                }
            }
        }
        ImageLong{
            id:imageLong
            visible: false
            anchors.fill: parent
            anchors.topMargin: root.height/13
            anchors.bottomMargin: root.height/4
        }
        Rectangle{
            id:pop
            width: grid.width
            height:root.height/6                           //间隔栏
            opacity:0                                      //纯透明
            color:"white"

        }

        Rectangle{
            id:bottomRect
            height:grid.height/6
            width: grid.width
            Flickable{
                flickableDirection: Flickable.HorizontalFlick          //可拖动
                width: root.width
                height: bottomRect.height
                contentWidth: rowBtn.width
                contentHeight: rowBtn.height
                boundsBehavior: Flickable.StopAtBounds             //禁止拖出栏边界
                Row{
                    id:rowBtn
                    Button{
                        id:imgBtn
                        width: root.width/4
                        height: bottomRect.height
                        icon.source: "qrc:/picture/方向.png"
                        display: "TextUnderIcon"
                        text: "方向"
                        icon.width: imgBtn.width/3
                        icon.height:imgBtn.height/3
                        onPressed: {
                            if(imageLong.imageModel.count >= 2){
                                imageLong.changeDirection()
                            }else{
                                dialogs.tipDialog.text = "请先选择照片!"
                                dialogs.tipDialog.open()
                            }
                        }
                    }

                    Button{
                        id:adding
                        width: root.width/4
                        height: bottomRect.height
                        icon.source: "qrc:/picture/添加.png"
                        display: "TextUnderIcon"
                        text: qsTr("添加")
                        icon.width: adding.width/3
                        icon.height:adding.height/3
                        onPressed: {
                            if(imageLong.imageModel.count >= 2){
                                dialogs.addDialog.open()
                            }else{
                                dialogs.tipDialog.text = "请先选择照片!"
                                dialogs.tipDialog.open()
                            }
                        }
                    }

                    Button{
                        id:delete1
                        width: root.width/4
                        height: bottomRect.height
                        icon.source: "qrc:/picture/删 除.png"
                        display: "TextUnderIcon"
                        text: qsTr("删除")
                        icon.width: delete1.width/3
                        icon.height:delete1.height/3
                        onPressed: {
                            if(imageLong.imageModel.count > 2){
                                imageLong.removeImage()
                            }else{
                                dialogs.tipDialog.text = "最少照片数：2!"
                                dialogs.tipDialog.open()
                            }
                        }
                    }

                    Button
                    {
                        id:replace
                        width: root.width/4
                        height: bottomRect.height
                        icon.source: "qrc:/picture/替换.png"
                        display: "TextUnderIcon"
                        text: "替换"
                        icon.width: replace.width/3
                        icon.height:replace.height/3
                        onPressed: {
                            if(imageLong.imageModel.count > 2){
                                imageLong.replaceImage()
                            }else{
                                dialogs.tipDialog.text = "最少照片数：3!"
                                dialogs.tipDialog.open()
                            }
                        }
                    }
                }
            }
        }
    }
    Dialogs{
        id:dialogs
        fileOpenDialog.selectMultiple: true
        fileOpenDialog.onAccepted: {
            if(fileOpenDialog.fileUrls.length >= 2){
                imageRect.visible = false
                imageLong.visible = true
                imageLong.chooseImage(fileOpenDialog.fileUrls)
            } else {
                tipDialog.text = "请选择至少两张图片!"
                tipDialog.open()
            }
        }
        addDialog.onAccepted: imageLong.addImage(addDialog.fileUrls)
    }
}
