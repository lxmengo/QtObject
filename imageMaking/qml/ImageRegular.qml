import Felgo 3.0
import QtQuick 2.0
import QtQuick.Dialogs 1.2


Item {
    property int imageType: 0
    property alias imageModel: imageModel

    function imagePath(){
        var time = Qt.formatDateTime(new Date(), "yyyyMMdd-hh-mm-ss-zzz");
        var path = "./" + time +".jpg";//使用当前时间作为图片的保存名
        console.log(path)
        return path
    }

    function updateImage(){//按照图片数量，对图片进行简简单单的排布
        var length = imageModel.count
        if(length === 1) {
            imgRepeater.itemAt(0).width = rec.width
            imgRepeater.itemAt(0).height = rec.height
        } else

            for(var i = 0; i < length; i++){
                if(imageType === 0 || imageType === 1){
                    if(i !== length-1){
                        if(imageType === 0){
                            imgRepeater.itemAt(i).width = rec.width/(length-1)
                            imgRepeater.itemAt(i).height = rec.height/2
                        }else{
                            imgRepeater.itemAt(i).width = rec.width/2
                            imgRepeater.itemAt(i).height = rec.height/(length-1)
                        }

                    } else {
                        if(imageType === 0){
                            imgRepeater.itemAt(i).width = rec.width
                            imgRepeater.itemAt(i).height = rec.height/2
                            imageFlow.flow = Flow.LeftToRight
                        } else {
                            imgRepeater.itemAt(i).width = rec.width/2
                            imgRepeater.itemAt(i).height = rec.height
                            imageFlow.flow = Flow.TopToBottom
                        }
                    }
                } else if(imageType === 2 || imageType === 3){
                    if(i === 0){
                        if(imageType === 2) {
                            imgRepeater.itemAt(i).width = rec.width
                            imgRepeater.itemAt(i).height = rec.height/2
                            imageFlow.flow = Flow.LeftToRight
                        }
                        else {
                            imgRepeater.itemAt(i).width = rec.width/2
                            imgRepeater.itemAt(i).height = rec.height
                            imageFlow.flow = Flow.TopToBottom
                        }
                    }else{
                        if(imageType === 2){
                            imgRepeater.itemAt(i).width = rec.width/(length-1)
                            imgRepeater.itemAt(i).height = rec.height/2
                        }else{
                            imgRepeater.itemAt(i).width = rec.width/2
                            imgRepeater.itemAt(i).height = rec.height/(length-1)
                        }
                    }
                }
            }
    }

    function typeClear(){
        var listRet
        for(var i = 0; i < imageModel.count; i++){
            listRet = imgRepeater.itemAt(i).children
            listRet[0].scale = 1
        }
        imgRepeater.currentIndex = -1//用来清除图片的状态，例如选择状态
    }

    function chooseImage(){
        if(arguments[0].length > 1){
            imageModel.clear()
            for(var i = 0; i < arguments[0].length; i++){
                imageModel.append({filePath: arguments[0][i]})
            }
        }
        typeClear()
        updateImage()
    }
    function addImage(){
        imageModel.append({filePath: arguments[0][0]})
        updateImage()
        typeClear()
    }

    function removeImage(){//移除图片
        if(imageModel.count > 2 && imgRepeater.currentIndex >= 0 && imgRepeater.currentIndex < imageModel.count){
            imageModel.remove(imgRepeater.currentIndex, 1)
            imgRepeater.currentIndex = -1
            updateImage()
            return true
        }
        typeClear()
    }

    function replaceImage(){//简易替换图片
        if(removeImage()) {
            dialogs.openAddDialog()
            typeClear()
            updateImage()
        }
        typeClear()
    }

    function up(){
        imageType = 0
        updateImage()
    }

    function left(){
        imageType = 1
        updateImage()
    }

    function down(){
        imageType = 2
        updateImage()
    }

    function right(){
        imageType = 3
        updateImage()
    }

    function saveImage(){
        typeClear()
        rec.grabToImage(function(result) {
            result.saveToFile(imagePath());
        });//利用捕捉组件的方式保存图片
    }
    ListModel{
        id: imageModel
    }

    Rectangle{
        id: rec
        anchors.fill: parent
        //anchors.horizontalCenter: parent.horizontalCente.

        Flow{
            id: imageFlow
            anchors.fill: parent
            Repeater{
                id: imgRepeater
                model: imageModel
                property int currentIndex: -1
                AppFlickable{
                    id: imageFlick
                    flickableDirection: Flickable.HorizontalAndVerticalFlick
                    boundsBehavior: "StopAtBounds"
                    onWidthChanged: {
                        img.width = width + 50
                        contentWidth = img.width
                    }
                    onHeightChanged: {
                        if(img.height < height) img.height = height + 50
                        contentHeight = img.height
                    }

                    clip: true
                    function getProportion(){
                        var proportion
                        proportion = img.sourceSize.height / img.sourceSize.width
                        return proportion //获取图片原比例
                    }
                    Image {
                        id: img
                        width: parent.width;
                        height: width/getProportion()
                        source: filePath
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var listRet
                            for(var i = 0; i < imageModel.count; i++){
                                listRet = imgRepeater.itemAt(i).children
                                if(imgRepeater.currentIndex === index){
                                    listRet[0].scale = 1
                                } else if(i === index){
                                    listRet[0].scale = 0.9
                                } else {
                                    listRet[0].scale = 1
                                } //选中状态的切换
                            }
                            imgRepeater.currentIndex = index
                        }
                    }
                }
            }
        }
    }
}


