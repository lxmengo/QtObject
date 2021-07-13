import QtQuick 2.9
import Felgo 3.0
import QtQuick.Layouts 1.12
import QtGraphicalEffects 1.12

Item {
    property alias canvas: canvas
    property bool painting: false
    function imagePath(){
        var time = Qt.formatDateTime(new Date(), "yyyyMMdd_hh_mm_ss_zzz");
        var path = "./" + time +".jpg";//使用当前时间作为图片的保存名
        return path
    }

    //九宫网格截图
    Canvas{
        width: 200
        height: 200
        id:canvas
        visible: false
        onPaint: {
            if(painting){
                var ctx = getContext("2d")
                var h = img.sourceSize.height/3
                var w = img.sourceSize.width/3
                for(var i = 0;i <3;i++){
                    for(var j = 0;j<3;j++){
                        ctx.drawImage(img,img.x+w*i,img.y+h*j,w,h,0,0,200,200)
                        console.log("saving")
                        canvas.save(imagePath())
                    }
                }
            }
        }
    }
    function save(){
        painting = 1
        canvas.requestPaint()
    }
}
