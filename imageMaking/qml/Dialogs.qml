import QtQuick 2.0
import Felgo 3.0
import QtQuick.Dialogs 1.2

//
Item {
    id: item
    property alias fileOpenDialog: fileOpen
    property alias addDialog: addDialog
    property alias tipDialog: tipDialog
    function openFileDialog() { fileOpenDialog.open(); }
    function openAddDialog(){ addDialog.open(); }

    //打开文件选择想要的图片
    FileDialog {
        id: fileOpen
        title: "Select some picture files"
        folder: shortcuts.pictures
        nameFilters: [ "Image files (*.png *.jpeg *.jpg)" ]
        onAccepted:  console.log(dialogs.fileOpenDialog.fileUrl)
    }
    FileDialog {
        id: addDialog
        nameFilters: ["Image(*.png *.jpg)"]
    }

    Dialog{
        id:tipDialog
        title: "提示"
        property alias text: message.text
        modality: Qt.ApplicationModal
        Text {
            id:message
            color: "orange"
            font.pixelSize: 50
        }
    }
}

