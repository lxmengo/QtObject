import Felgo 3.0
import QtQuick 2.0
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.0



App {
    id:app
    onInitTheme: {
        Theme.navigationBar.titleColor ="white"
        Theme.navigationBar.backgroundColor="#FF8C00"
        Theme.colors.statusBarStyle = Theme.colors.statusBarStyleWhite    //设置顶部导航栏颜色属性
    }

    NavigationStack{
        id:mainStack
        Page{
            backgroundColor: "white"
            id:mypage
            navigationBarHidden: true
            Rectangle{
                id: marginRect
                anchors.top: parent.top
                height: parent.height/2 - grid.height    //软件标题
                Text {
                    text: qsTr("拼图酱")
                    font.pixelSize: 350
                    color: "orange"
                    anchors.horizontalCenter: app.horizontalCenter
                }
            }
            Carousel{
                id: carousel
                width: parent.width
                height: parent.height*0.5
                anchors.top: marginRect.bottom
            }
            Grid{
                id:grid                          //排布功能按钮
                width: parent.width
                height: parent.width*2/3
                columns: 3
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: carousel.bottom
                AppButton{
                    id:gridBtn
                    icon: IconType.th
                    text: "九格切图"
                    radius: 200                       //按钮圆滑度，为圆形
                    width: app.width/3
                    height: app.width/3
                    backgroundColor: "#FF8C00"             // 按钮背景颜色
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"              //点击时颜色
                    onClicked: {
                        mypage.navigationStack.push(pageCutaway)
                    }
                }
                AppButton{
                    icon: IconType.magic
                    text: "装饰美化"
                    radius: 200
                    width: app.width/3
                    height: app.width/3
                    backgroundColor: "#FF8C00"
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"
                    onClicked: {
                        mypage.navigationStack.push(pageDecorate)
                    }
                }
                AppButton{
                    icon: IconType.angellist
                    text: "形状切图"
                    width: app.width/3
                    height: app.width/3
                    radius: 200
                    backgroundColor: "#FF8C00"
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"
                    onClicked: {
                        mypage.navigationStack.push(pageshape)
                    }
                }
                AppButton{
                    icon: IconType.creditcard
                    text: "长图台词"
                    width: app.width/3
                    height: app.width/3
                    radius: 200
                    backgroundColor: "#FF8C00"
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"
                    onClicked: {
                        mypage.navigationStack.push(pageLong)
                    }
                }
                AppButton{
                    icon: IconType.image
                    text: "常规拼图"
                    width: app.width/3
                    height: app.width/3
                    radius: 200
                    backgroundColor: "#FF8C00"
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"
                    onClicked: {
                        mypage.navigationStack.push(pageRegular)
                    }
                }
                AppButton{
                    icon: IconType.delicious
                    text: "自由拼图"
                    width: app.width/3
                    height: app.width/3
                    radius: 200
                    backgroundColor: "#FF8C00"
                    textColor: "white"
                    backgroundColorPressed: "#FFA500"
                    onClicked: {
                        mypage.navigationStack.push(pageFree)
                    }
                }
            }
        }
    }




    Component{
        id:pageCutaway
        PageCutaway{
        }
    }
    Component{
        id:pageDecorate
        PageDecorate{

        }
    }

    Component{
        id:pageshape
        PageShape{

        }
    }
    Component{
        id:pageLong
        PageLong{

        }
    }Component{
        id:pageRegular
        PageRegular{

        }
    }
    Component{
        id:pageFree
        PageFree{

        }
    }
}
