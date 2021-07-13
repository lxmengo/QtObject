import Felgo 3.0
import QtQuick 2.15
import QtQuick.Dialogs 1.2

Item {
    id: mainPage
    property bool painting: false
    property int direction: 0 //图片排布方向
    property int canvasH: 1000
    property int canvasW: 1000
    property int imageH: 500
    property int imageW: 500
    property alias imageModel: imageModel
    signal imgWidthChange()

    function imagePath(){
        var time = Qt.formatDateTime(new Date(), "yyyyMMdd_hh_mm_ss_zzz");
        var path = "./" + time +".jpg";//使用当前时间作为图片的保存名
        return path
    }

    function chooseImage(){
        imageModel.clear()
        for(var i = 0; i < arguments[0].length; i++){
            imageModel.append({filePath: arguments[0][i]})
            img.source = imageModel.get(i).filePath
        }
        imageView.currentIndex = -1
    }

    function addImage(){
        imageModel.append({filePath: arguments[0][0]})
    }

    function removeImage(){
        if(imageView.currentIndex >= 0 && imageModel.count > 0){
            imageModel.remove(imageView.currentIndex, 1)
            imageView.currentIndex = -1
            return true
        }
        imageView.currentIndex = -1
    }

    function replaceImage(){//简易替换图片
        if(removeImage())
            dialogs.openAddDialog()
        //imageModel.move(imageModel.count-1, imageView.currentIndex, 1)
        imageView.currentIndex = -1
    }

    function getCanvasSize(){
        var canvasWidth = 0
        var canvasHeight = 0
        var proportion = 1
        for(var i=0; i<imageModel.count; i++){
            img.source = imageModel.get(i).filePath
            proportion = img.sourceSize.height / img.sourceSize.width

            if(direction === 0){
                if(img.sourceSize.height < canvas.height)
                    canvasHeight += canvasH
                else canvasHeight += canvas.width*proportion
            }else if(direction === 1){
                if(img.sourceSize.width < canvas.width)
                    canvasWidth += canvasW
                else canvasWidth += canvas.height/proportion
            }//按图片原比例累加画布的高度，宽度
        }
        console.log(canvas.width)
        console.log("width = " + canvasWidth)
        console.log("height = " + canvasHeight)
        if(direction === 0){
            canvas.height = canvasHeight
        }else if(direction === 1){
            canvas.width = canvasWidth
        }

        console.log(canvas.width)
        console.log(canvas.height)
    }

    function clearCanvas(){
        canvas.width = canvasW;
        canvas.height = canvasH;//将画布清除为默认大小（1000, 1000）
    }

    function changeDirection(){ //改变图片排布的方向
        if(direction === 0){
            direction = 1
            imageView.orientation = ListView.Horizontal
        }else{
            direction = 0
            imageView.orientation = ListView.Vertical
        }
    }

    function saveImage(){
        if(imageModel.count > 0){
            clearCanvas()
            getCanvasSize()
            painting = true
            canvas.requestPaint() //以绘制画布的方式，保存长图
        }
    }

    Canvas{
        id: canvas
        visible: false
        width: canvasW; height: canvasH
        onPaint: {
            if(painting){ //绘制函数，并且不改变原来长宽比例
                var ctx = getContext("2d");
                var drawX = 0
                var drawY = 0
                var drawHeight = canvas.height
                var drawWidth = canvas.width
                var proportion = 1
                ctx.fillStyle = "#FFFFFF"
                ctx.fillRect(0, 0, drawWidth, drawHeight)
                for(var i=0; i<imageModel.count; i++){
                    img.source = imageModel.get(i).filePath
                    proportion = img.sourceSize.height / img.sourceSize.width

                    if(direction === 0){ //竖直方向的排布绘制
                        if(img.sourceSize.width < canvasW){//当图片宽度小于画布宽度，把图片画在画布宽度正中间
                            drawX = canvasW/2 - img.sourceSize.width/2
                            drawWidth = img.sourceSize.width
                            console.log("drawX = " + drawX)
                        } else {
                            drawX = 0
                            drawWidth = canvasW
                        }
                        if(img.sourceSize.height < canvasH){//当图片高度小于画布高度，把图片画在画布高度正中间
                            drawY += (canvasH/2 - img.sourceSize.height/2)
                            drawHeight = img.sourceSize.height
                            console.log("drawY = " + drawY)
                        } else{
                            drawHeight = drawWidth * proportion
                        }

                        ctx.drawImage(img, drawX, drawY, drawWidth, drawHeight) //绘制

                        if(img.sourceSize.width < canvasW || img.sourceSize.height < canvasH)
                            drawY += (canvasH/2 + img.sourceSize.height/2)
                        else
                            drawY += drawHeight //绘制坐标移动
                    } else if(direction === 1){ //水平方向绘制
                        if(img.sourceSize.height < canvasH){
                            drawY = (canvasH/2 - img.sourceSize.height/2)
                            drawHeight = img.sourceSize.height
                            console.log("drawY = " + drawY)
                        } else{
                            drawY = 0
                            drawHeight = canvasH
                        }

                        if(img.sourceSize.width < canvasW){
                            drawX += canvasW/2 - img.sourceSize.width/2
                            drawWidth = img.sourceSize.width
                            console.log("drawX = " + drawX)
                        } else {
                            drawWidth = drawHeight / proportion
                        }

                        ctx.drawImage(img, drawX, drawY, drawWidth, drawHeight)

                        if(img.sourceSize.width < canvasW || img.sourceSize.height < canvasH)
                            drawX += (canvasW/2 + img.sourceSize.width/2)
                        else
                            drawX += drawWidth
                    }
                }
                save(imagePath())
                console.log("painting")
            }
        }
    }

    Image {
        id: img
        visible: false
    }

    ListModel{
        id: imageModel
    }
    Component{
        id: imgDelegate
        Rectangle{
            id: imageRet
            width: imageW
            height: imageH
            border.color: "transparent"
            border.width: 10
            scale: ListView.isCurrentItem ? 0.9 : 1
            AppImage {
                anchors.centerIn: parent
                id: image
                source: filePath
                onStatusChanged: {
                    if (image.status === Image.Ready) {
                        if(image.sourceSize.width < imageW)
                            image.width = image.sourceSize.width
                        else image.width = parent.width
                        if(image.sourceSize.height < imageH)
                            image.height = image.sourceSize.height
                        else image.height = parent.height
                    }//图片加载完后，图片原利用比例切换显示状态
                }
                MouseArea{
                    id: imageArea
                    preventStealing: true
                    anchors.fill: image
                    onClicked: {
                        imageView.currentIndex = index
                    }
                    onPressed: {
                        imageView.currentIndex = -1
                        imageRet.border.color = "red"
                        image.width -= 10
                        image.height -= 10
                    }
                    onReleased: {
                        imageView.currentIndex = -1
                        imageRet.border.color = "transparent"
                        image.width += 10
                        image.height += 10
                    }
                    onPositionChanged: {
                        var another_index = imageView.indexAt(imageArea.mouseX + imageRet.x, imageArea.mouseY + imageRet.y)//利用鼠标获取替换的item
                        if(another_index !== -1){
                            if(imageView.currentIndex !== another_index)
                            {
                                imageModel.move(index, another_index, 1) //移动两个item
                            }
                        }
                    }
                }
            }
        }
    }

    Rectangle{
        id: marginRet
        color: "red"
        anchors.top: parent.top
        anchors.left: parent.left
        width: direction === 0 ? (mainPage.width - imageW) / 2 : 0
        height: direction === 0 ? 0 : (mainPage.height - imageH) / 2//利用该rectangle实现imageView的居中显示
    }

    AppListView{
        id: imageView
        visible: true
        anchors.top: marginRet.bottom
        anchors.left: marginRet.right
        model: imageModel
        move: Transition {
            NumberAnimation {
                property: "x"
                duration: 500
            }
            NumberAnimation {
                property: "y"
                duration: 500
            }

        }
        moveDisplaced: Transition{
            NumberAnimation {
                property: "x"
                duration: 500
            }
            NumberAnimation {
                property: "y"
                duration: 500
            }
        }
        add: Transition{
            NumberAnimation {
                property: "x"
                duration: 500
            }
            NumberAnimation {
                property: "y"
                duration: 500
            }
        }
        remove:  Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; to: 0; duration: 1000 }
                NumberAnimation { properties: "x,y"; to: 100; duration: 1000 }
            }
        }
        populate: Transition{
            NumberAnimation {
                property: "x"
                duration: 500
            }
            NumberAnimation {
                property: "y"
                duration: 500
            }
        }

        delegate: imgDelegate
    }
}
