import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Layouts

Window {
    id: root
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

    property ApplicationTheme mApplicationTheme : ApplicationTheme {}

    color: mApplicationTheme.main
    ColumnLayout{
        anchors.fill: parent
        PersianCalender{
            id: uPersianCalendar
            mApplicationTheme: root.mApplicationTheme
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            Layout.topMargin: 10

            onDateSelected:function(selectedDate) {
                fromDate=selectedDate
                toDate=selectedDate
                console.log("Selected date:", selectedDate.y + "/" + selectedDate.m + "/" + selectedDate.d)
            }

            onDateRangeSelected:function(rangeStartDate, rangeEndDate) {
                fromDate=rangeStartDate
                toDate=rangeEndDate
                console.log("Range selected from:", rangeStartDate.y + "/" + rangeStartDate.m + "/" + rangeStartDate.d)
                console.log("Range selected to:", rangeEndDate.y + "/" + rangeEndDate.m + "/" + rangeEndDate.d)
            }
        }
    }
}
