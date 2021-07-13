import Felgo 3.0
import QtQuick 2.15
import QtQuick.Dialogs 1.2



Item {
    id: mainPage
    property alias imageModel: imageModel

    function imagePath(){
        var time = Qt.formatDateTime(new Date(), "yyyyMMdd_hh_mm_ss_zzz");
        var path = "./" + time +".jpg";//使用当前时间作为图片的保存名
        return path
    }

    function typeClear(){
        var listRet
        for(var i = 0; i < imageModel.count; i++){
            listRet = freeRepeater.itemAt(i).children//获取孩子列表
            freeRepeater.itemAt(i).width = listRet[1].width
            freeRepeater.itemAt(i).height = listRet[1].height
            listRet[0].visible = false
        }
        freeRepeater.currentIndex = -1 //用来清除图片的状态，例如选择状态
    }

    function chooseImage(){
        if(arguments[0].length > 1){
            imageModel.clear()
            for(var i = 0; i < arguments[0].length; i++){
                imageModel.append({filePath: arguments[0][i]})
            }
            typeClear()
        }
    }

    function addImage(){
        imageModel.append({filePath: arguments[0][0]})
        typeClear()
    }

    function removeImage(){
        if(imageFree.imageModel.count > 2){
            imageModel.remove(freeRepeater.currentIndex) //删除选择图片
            typeClear()
        }else {
            dialogs.tipDialog.text = "最少照片数：2!"
            dialogs.tipDialog.open()
        }
    }

    function replaceImage(){//简易替换图片
        dialogs.openAddDialog()
        removeImage()
        typeClear()
    }

    function rotationImage(){
        freeRepeater.itemAt(freeRepeater.currentIndex).rotation += 90
    }

    function enlargeImage(){
        var listRet
        listRet = freeRepeater.itemAt(freeRepeater.currentIndex).children
        listRet[1].width += 10

        //在放大图片时，同时改变坐标，使图片的中心位置保存不变
        freeRepeater.itemAt(freeRepeater.currentIndex).x -= 5
        freeRepeater.itemAt(freeRepeater.currentIndex).y -= 5 * listRet[1].sourceSize.height/listRet[1].sourceSize.width
    }

    function shrinkImage(){
        var listRet
        listRet = freeRepeater.itemAt(freeRepeater.currentIndex).children
        listRet[1].width -= 10

        //在缩小图片时，同时改变坐标，使图片的中心位置保存不变
        freeRepeater.itemAt(freeRepeater.currentIndex).x += 5
        freeRepeater.itemAt(freeRepeater.currentIndex).y += 5 * listRet[1].sourceSize.height/listRet[1].sourceSize.width
    }

    function saveImage(){//存储图片
        typeClear()
        ret.grabToImage(function(result) {
            result.saveToFile(imagePath());
        });//利用捕捉组件的方式保存图片
    }

    //            Rectangle{
    //                id: ret
    //                width: 600; height: 600
    //                color: "red"
    //                Canvas{
    //                    id: canvas
    //                    visible: true
    //                    width: 600; height: 600
    //                    onPaint: {
    //                        if(painting > 1){
    //                            console.log("painting")

    //                            var ctx = getContext("2d");
    //                            ctx.clearRect(0, 0, parent.width, parent.height)
    //                            //ctx.scale(2, 2)

    //                            ctx.fillStyle = "#FFFFFF"
    //                            ctx.fillRect(0, 0, 600, 600)

    //                            ctx.translate(100, 0)
    //                            ctx.rotate(90 * Math.PI / 180)

    //                            ctx.drawImage(img1, 0, 0, img1.width, img1.height)

    //                            ctx.rotate(-90 * Math.PI / 180)
    //                            ctx.translate(-100, 0)

    //                            ctx.drawImage(img2, img2.x, img2.y, img1.width, img1.height)
    //                            //save(imagePath())

    //                            console.log("no")
    //                        }
    //                    }
    //                }
    //            }
    //        }

    ListModel{
        id: imageModel
    }

    Rectangle{
        id: ret
        anchors.fill: parent
        color: "white"
        anchors.centerIn: parent
        clip: true
        Repeater{
            property int currentIndex: -1
            id: freeRepeater
            model: imageModel
            Rectangle{
                id: borderRet
                width: img.width
                height: img.height
                Rectangle{
                    id: deleteRet
                    width: 50
                    height: 50
                    radius: 25
                    visible: false
                    anchors.bottom: img.top
                    anchors.right: img.left
                    Image {
                        anchors.fill: parent
                        source: "qrc:/picture/关闭.png"
                    }
                }
                Image {
                    id: img
                    width: 400; height: width * img.sourceSize.height/img.sourceSize.width //按图片原比例显示图片
                    anchors.centerIn: parent
                    source: filePath
                    onWidthChanged: {
                        if(freeRepeater.currentIndex !== -1){
                            var listRet
                            listRet = freeRepeater.itemAt(freeRepeater.currentIndex).children
                            listRet[1].height = img.width * img.sourceSize.height/img.sourceSize.width
                            freeRepeater.itemAt(freeRepeater.currentIndex).width = img.width + 10
                            freeRepeater.itemAt(freeRepeater.currentIndex).height = img.height + 10
                        }
                    }
                }
                MouseArea{
                    anchors.fill: parent
                    drag.target: parent
                    onPressed: {
                        console.log(index)
                        var listRet
                        for(var i = 0; i < imageModel.count; i++){
                            listRet = freeRepeater.itemAt(i).children
                            if(i === index){
                                freeRepeater.itemAt(i).width = listRet[1].width + 10
                                freeRepeater.itemAt(i).height = listRet[1].height + 10
                                freeRepeater.itemAt(i).border.color = "red"
                                freeRepeater.itemAt(i).border.width = 10
                                listRet[0].visible = true //选择状态
                            } else {
                                freeRepeater.itemAt(i).width = listRet[1].width
                                freeRepeater.itemAt(i).height = listRet[1].height
                                freeRepeater.itemAt(i).border.color = "white"
                                listRet[0].visible = false
                                freeRepeater.itemAt(i).border.width = 0//清除未选中的图片的选中状态
                            }
                            freeRepeater.currentIndex = index
                        }
                    }
                }
                MouseArea{
                    anchors.fill: deleteRet
                    onClicked: {
                        removeImage()
                    }
                }
            }
        }
    }
}

