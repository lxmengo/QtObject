import QtQuick 2.15
import QtQuick.Controls 2.15
import Felgo 3.0
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0
//形状切图，可以用各种图形截取想要的图片
Page{
    //通过时间来保存图片
    function imagePath(){
        var time = Qt.formatDateTime(new Date(), "yyyyMMdd_hh_mm_ss_zzz");
        var path = "./" + time +".jpg";//使用当前时间作为图片的保存名
        return path
    }

    property int imgmirro: 1
    property int imgmirro2: 1
    backgroundColor: "white"
    id: root
    Button{
        anchors.top: NavigationBar.bottom
        anchors.horizontalCenter: parent.horizontalCenter          //顶部居中
        width: root.width/5
        height:root.height/20
        id:saveBtn
        display: "TextUnderIcon"
        text: "保存"
        icon.source:"qrc:/picture/保存.png"                     //保存按钮
        icon.width: saveBtn.width/2
        icon.height: saveBtn.height/2
        onPressed: {
            imageBtn.grabToImage(function(result) {
                result.saveToFile(imagePath());           //通过保存一个组件来保存上面的图片
            });
        }
    }

    Rectangle{
        id:imgBtnwindow                                            //弹出窗口
        x:0
        y:root.height-bottomRect.height-root.height/10

        //visible: false
        width: root.width
        height: root.height/8
        color: "lightgrey"
        Row{
            height: parent.height
            Button{
                id:no1                                        //四种形状按钮
                height:parent.height
                width: root.width/4
                icon.source: "qrc:/picture/小熊.png"
                icon.width: no1.width/2                  //按钮大小设置
                icon.height:no1.height/2
                onPressed: {
                    star.source = "qrc:/picture/小熊.png"
                }
            }
            Button{
                id:no2
                height: parent.height
                width: root.width/4
                icon.source: "qrc:/picture/猫爪.png"
                icon.width: no2.width/2
                icon.height:no2.height/2
                onPressed: {
                    star.source = "qrc:/picture/猫爪.png"
                }
            }
            Button{
                id:no3
                height: parent.height
                width: root.width/4
                icon.source: "qrc:/picture/蝴蝶.png"
                icon.width: no3.width/2
                icon.height:no3.height/2
                onPressed: {
                    star.source = "qrc:/picture/蝴蝶.png"
                }
            }
            Button{
                id:no4
                height: parent.height
                width: root.width/4
                icon.source: "qrc:/picture/star.png"
                icon.width: no4.width/2
                icon.height:no4.height/2
                onPressed: {
                    star.source = "qrc:/picture/star.png"
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
            height:grid.height/9                         //间隔栏
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
                    text: "请添加图片"                    //添加图片框
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
                Image{
                    id:star
                    anchors.fill: parent
                    source: "qrc:/picture/star.png"
                    sourceSize: Qt.size(parent.width,parent.height)
                    smooth: true
                    visible: false
                }
                OpacityMask{
                    id:img_mask
                    anchors.fill: image
                    source: image
                    maskSource: star
                    visible: true
                    antialiasing: true
                }
            }
        }
        Rectangle{
            id:pop
            width: grid.width
            height:root.height/6                    //间隔栏
            opacity:0                               //纯透明
            color:"white"

        }

        Rectangle{
            id:bottomRect
            height:grid.height/6
            width: grid.width
            Flickable{
                flickableDirection: Flickable.HorizontalFlick          //可拖动
                width: root.width
                height:bottomRect.height
                contentWidth: rowBtn.width
                contentHeight: rowBtn.height
                boundsBehavior: Flickable.StopAtBounds              //禁止拖出栏边界
                Row{
                    id:rowBtn

                    Button{
                        id:imgBtn
                        width: root.width/5                           //底部按钮栏
                        height: bottomRect.height
                        icon.source: "qrc:/picture/形状.png"
                        display: "TextUnderIcon"
                        text: "形状"
                        icon.width: imgBtn.width/3
                        icon.height:imgBtn.height/3
                        onPressed:  {
                            image.visible=false                  //判断弹出窗口位置，进行对应弹出动画
                            if(imgBtnwindow.y ==root.height-bottomRect.height-root.height/10)
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
                            target: imgBtnwindow
                            properties: "y"
                            from:root.height-bottomRect.height-root.height/10
                            to:root.height-bottomRect.height-root.height/10-root.height/8
                            //动画持续时间，毫秒
                            duration: 500
                            //动画渐变曲线
                            easing.type: Easing.Linear
                        }
                        NumberAnimation{
                            target: imgBtnwindow
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
                            target: imgBtnwindow
                            properties: "y"
                            from: root.height-bottomRect.height-root.height/10-root.height/8
                            to:root.height-bottomRect.height-root.height/10
                            duration: 200;
                            easing.type: Easing.Linear

                        }
                        NumberAnimation{
                            target: imgBtnwindow
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
    Dialogs{
        id:dialogs
    }
}

