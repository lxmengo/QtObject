import QtQuick 2.15
import QtQuick.Controls 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3


Page{
    backgroundColor: "white"
    id: root
    Button{
        anchors.top: NavigationBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter         //顶部居中
        width: root.width/5
        height:root.height/20
        id:saveBtn
        display: "TextUnderIcon"
        text: "保存"
        icon.source:"qrc:/picture/保存.png"                    //保存按钮
        icon.width: saveBtn.width/2
        icon.height: saveBtn.height/2
        onPressed: {
            imageRegular.saveImage()
        }
    }

    //tanchuchuangkou
    Rectangle{
        id:layoutwindow                                  //弹出窗口
        x:0
        y:root.height-bottomRect.height-root.height/10

        //visible: false
        width: root.width
        height: root.height/8
        color: "lightgrey"
        Row{
            height: parent.height                        //四种方向按钮
            width:parent.width
            Button{
                id:no1
                height: parent.height
                width: parent.width/4
                icon.source: "qrc:/picture/上箭头.png"
                icon.width: no1.width/2
                icon.height:no1.height/2
                onPressed: {
                    imageRegular.up()
                }
            }
            Button{
                id:no2
                height: parent.height
                width: parent.width/4
                icon.source: "qrc:/picture/下箭头.png"
                icon.width: no2.width/2
                icon.height:no2.height/2
                onPressed: {
                    imageRegular.down()
                }
            }
            Button{
                id:no3
                height: parent.height
                width: parent.width/4
                icon.source: "qrc:/picture/左箭头.png"
                icon.width: no3.width/2
                icon.height:no3.height/2
                onPressed: {
                    imageRegular.left()
                }
            }
            Button{
                id:no4
                height: parent.height
                width: parent.width/4
                icon.source: "qrc:/picture/右箭头.png"
                icon.width: no4.width/2
                icon.height:no4.height/2
                onPressed: {
                    imageRegular.right()
                }
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
            height:grid.height/9                          //间隔栏
        }

        Rectangle{
            id:imageRect
            width:grid.width
            height:grid.height-pop.height-bottomRect.height-topRect.height
            Button{
                id:imgeBtn
                anchors.fill: parent
                Text{
                    id:imgText
                    text: "请添加图片"                       //添加图片框
                    anchors.centerIn: parent
                }
                onPressed: {
                    dialogs.openFileDialog()
                }
            }
        }
        ImageRegular{
            id: imageRegular
            visible: false
            anchors.fill: parent
            anchors.topMargin: root.height/13
            anchors.bottomMargin: root.height/3
        }
        Rectangle{
            id:pop
            width: grid.width
            height:root.height/6                  //间隔栏
            opacity:0                            //纯透明
            color:"white"
        }

        Rectangle{
            id:bottomRect
            height:grid.height/6
            width: grid.width
            Flickable{
                flickableDirection: Flickable.HorizontalFlick        //可拖动
                width: root.width
                height: bottomRect.height
                contentWidth: rowBtn.width
                contentHeight: rowBtn.height
                boundsBehavior: Flickable.StopAtBounds           //禁止拖出栏边界
                Row{
                    id:rowBtn
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
                            if(imageRegular.imageModel.count >= 2){
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
                            if(imageRegular.imageModel.count > 2){
                                imageRegular.removeImage()
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
                            if(imageRegular.imageModel.count > 2){
                                imageRegular.replaceImage()
                            }else{
                                dialogs.tipDialog.text = "最少照片数：3!"
                                dialogs.tipDialog.open()
                            }
                        }
                    }
                    Button{
                        id:layout
                        width: root.width/4
                        height: bottomRect.height
                        icon.source: "qrc:/picture/布局.png"
                        display: "TextUnderIcon"
                        icon.width: layout.width/3
                        icon.height:layout.height/3
                        text: "布局"
                        onClicked: {                            //判断弹出窗口位置，进行对应弹出动画
                            if(layoutwindow.y ==root.height-bottomRect.height-root.height/10)
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
                            target: layoutwindow
                            properties: "y"
                            from:root.height-bottomRect.height-root.height/10
                            to:root.height-bottomRect.height-root.height/10-root.height/8
                            //动画持续时间，毫秒
                            duration: 500
                            //动画渐变曲线
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target: layoutwindow
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
                            target: layoutwindow
                            properties: "y"
                            from: root.height-bottomRect.height-root.height/10-root.height/8
                            to:root.height-bottomRect.height-root.height/10
                            duration: 200;
                            easing.type: Easing.Linear

                        }
                        NumberAnimation{
                            target: layoutwindow
                            properties: "opacity"
                            from: 0.8
                            to: 0.2
                            duration: 200;
                            easing.type: Easing.Linear
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
                imageRegular.chooseImage(fileOpenDialog.fileUrls)
                imageRegular.visible = true
            }else {
                tipDialog.text = "请选择至少两张图片!"
                tipDialog.open()
            }
        }
        addDialog.onAccepted: imageRegular.addImage(addDialog.fileUrls)
    }
}
