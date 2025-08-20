import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15

import "date-conversion.js" as DateConversion

/**
 * JalaliDatePickerDialog - A Persian/Jalali calendar date picker dialog
 *
 * Features:
 * - Single date selection
 * - Date range selection with highlighting
 * - Optimized performance with proper state management
 * - User-friendly range selection interface
 */

ComboBox {
    id: mItem
    /** Theme provider */
    property ApplicationTheme mApplicationTheme


    padding: 0

    Component.onCompleted: {


        lastSelectionMode =selectionMode

        rangeEndDate= currentDate
        rangeEndDateLastSelected =rangeEndDate
        var d = new Date();
        rangeStartDate=  DateConversion.gregorian_to_jalali(d.getFullYear(), d.getMonth(), d.getDate())
        rangeStartDateLastSelected=rangeStartDate
        refreshCalendar()
    }

    /** Color properties for different calendar elements */
    property color yearRectColor: "transparent"
    property color monthRectColor: "transparent"
    property color dayNameRectColor: "transparent"
    property color dayNumberBackColor: "transparent"
    property color daysTextColor: mApplicationTheme.mainTint4
    property color selectedDayColor: mApplicationTheme.green
    property color rangeStartColor: mApplicationTheme.green
    property color rangeEndColor: mApplicationTheme.green
    property color rangeMiddleColor: mApplicationTheme.main
    property int selectedDayBorderWidth: 3
    property color rectangleColor: "transparent"

    signal showResult()
    // ========================================================================================
    // DATE MANAGEMENT PROPERTIES
    // ========================================================================================

    property var currentDate: DateConversion.today()

    // Selection mode: 0 = single date, 1 = date range
    property int selectionMode: 1
    property int lastSelectionMode

    // Range selection properties
    property var rangeStartDate: null
    property var rangeEndDate: null
    property var rangeStartDateLastSelected
    property var rangeEndDateLastSelected

    property bool isSelectingRange: false

    // Current calendar display date
    property int displayYear: currentDate["y"]
    property int displayMonth: currentDate["m"]
    property int displayDay: currentDate["d"]

    // Selected date for single selection mode
    property var selectedDate: currentDate

    // Calculated properties
    property string thisMonth: DateConversion.monthName(displayMonth)
    property int daysInMonth: DateConversion.dayInMonth(displayYear, displayMonth)
    property int firstDayOfMonth: DateConversion.dayNumber(displayYear, displayMonth, 1)

    property bool okHited : false

    Layout.fillWidth: true
    Layout.fillHeight: true
    Layout.minimumHeight: 40
    Layout.maximumHeight: 40
    Layout.minimumWidth: 280
    Layout.maximumWidth: 280

    // Display text based on selection mode
    displayText: {
        if (selectionMode === 0) {
            // Single date mode
            return selectedDate ?
                        selectedDate.y + "/" + selectedDate.m + "/" + selectedDate.d :
                        displayYear + "/" + displayMonth + "/" + displayDay
        } else if(rangeStartDate && rangeEndDate) {
            // Range mode
            return rangeStartDate.y + "/" + rangeStartDate.m + "/" + rangeStartDate.d +
                    " تا " +
                    rangeEndDate.y + "/" + rangeEndDate.m + "/" + rangeEndDate.d
        }
        else
        {
            return rangeStartDateLastSelected.y + "/" + rangeStartDateLastSelected.m + "/" + rangeStartDateLastSelected.d +
                    " تا " +
                    rangeEndDateLastSelected.y + "/" + rangeEndDateLastSelected.m + "/" + rangeEndDateLastSelected.d
        }
    }

    // ========================================================================================
    // SIGNALS
    // ========================================================================================

    signal dateSelected(var date)
    signal dateRangeSelected(var startDate, var endDate)

    // ========================================================================================
    // UTILITY FUNCTIONS
    // ========================================================================================

    /**
 * Navigate to previous/next month with year rollover handling
 */
    function navigateMonth(direction) {
        let newMonth = displayMonth + direction
        let newYear = displayYear

        if (newMonth > 12) {
            newMonth = 1
            newYear++
        } else if (newMonth < 1) {
            newMonth = 12
            newYear--
        }

        displayYear = newYear
        displayMonth = newMonth
        refreshCalendar()
    }

    /**
 * Navigate to previous/next year
 */
    function navigateYear(direction) {
        displayYear += direction
        refreshCalendar()
    }

    /**
 * Refresh calendar display
 */
    function refreshCalendar() {
        // Force update of calculated properties
        thisMonth = DateConversion.monthName(displayMonth)
        daysInMonth = DateConversion.dayInMonth(displayYear, displayMonth)
        firstDayOfMonth = DateConversion.dayNumber(displayYear, displayMonth, 1)

        // Trigger visual update
        calendarRepeater.model = 0
        calendarRepeater.model = 42
    }

    /**
 * Handle day selection based on current mode
 */
    function selectDay(day) {
        if (day <= 0 || day > daysInMonth) return

        let selectedDateObj = {
            "y": displayYear,
            "m": displayMonth,
            "d": day
        }

        if (selectionMode === 0) {
            // Single date selection
            selectedDate = selectedDateObj
            //dateSelected(selectedDate)
        } else {
            // Range selection
            handleRangeSelection(selectedDateObj)
        }
        refreshCalendar()
    }

    /**
 * Handle range selection logic
 */
    function handleRangeSelection(dateObj) {
        if (!rangeStartDate) {
            // First click - set start date
            rangeStartDate = dateObj
            rangeEndDate = null
            isSelectingRange = true
        } else if (!rangeEndDate) {
            // Second click - set end date
            if (compareDates(dateObj, rangeStartDate) >= 0) {
                rangeEndDate = dateObj
                isSelectingRange = false
                //dateRangeSelected(rangeStartDate, rangeEndDate)
            } else {
                // If clicked date is before start date, swap them
                rangeEndDate = rangeStartDate
                rangeStartDate = dateObj
                isSelectingRange = false
                //dateRangeSelected(rangeStartDate, rangeEndDate)
            }
        } else {
            // Third click - start new range
            rangeStartDate = dateObj
            rangeEndDate = null
            isSelectingRange = true
        }
    }

    /**
 * Compare two date objects
 * Returns: -1 if date1 < date2, 0 if equal, 1 if date1 > date2
 */
    function compareDates(date1, date2) {
        if (date1.y !== date2.y) return date1.y - date2.y
        if (date1.m !== date2.m) return date1.m - date2.m
        return date1.d - date2.d
    }

    /**
 * Check if a date is within the selected range
 */
    function isDateInRange(dateObj) {
        if (!rangeStartDate || !rangeEndDate) return false

        return compareDates(dateObj, rangeStartDate) >= 0 &&
                compareDates(dateObj, rangeEndDate) <= 0
    }

    /**
 * Check if a date is the start of the range
 */
    function isRangeStart(dateObj) {
        if (!rangeStartDate) return false
        return compareDates(dateObj, rangeStartDate) === 0
    }

    /**
 * Check if a date is the end of the range
 */
    function isRangeEnd(dateObj) {
        if (!rangeEndDate) return false
        return compareDates(dateObj, rangeEndDate) === 0
    }

    /**
 * Reset range selection
 */
    function resetRange() {
        rangeStartDate = null
        rangeEndDate = null
        isSelectingRange = false
        refreshCalendar()
    }

    // ========================================================================================
    // UI COMPONENTS
    // ========================================================================================

    contentItem: Text {
        id: comboText
        text: mItem.displayText
        font: mItem.font
        color: mApplicationTheme.mainTint3
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignRight
        rightPadding: 16
        leftPadding: 16
        elide: Text.ElideRight
    }

    indicator: Canvas {
        id: canvas
        x: mItem.width - width - mItem.rightPadding
        y: mItem.topPadding + (mItem.availableHeight - height) / 2
        width: 12
        height: 8
        contextType: "2d"
        anchors.left: parent.left
        anchors.leftMargin: 16

        Connections {
            target: mItem
            function onPressedChanged() { canvas.requestPaint(); }
        }

        onPaint: {
            context.reset();
            context.moveTo(0, 0);
            context.lineTo(width, 0);
            context.lineTo(width / 2, height);
            context.closePath();
            context.fillStyle = mApplicationTheme.mainTint4;
            context.fill();
        }
    }

    font: mApplicationTheme.font_Fa_Medium_Regular
    Material.foreground: mApplicationTheme.mainTint3

    background: Rectangle {
        anchors.fill: parent
        color: mApplicationTheme.mainTint1
        radius: 0
    }

    popup: Popup {
        y: mItem.y + mItem.height - 1
        x: mItem.x + mItem.width - width + 16
        width: 328
        height: mainLayout.implicitHeight + 16
        topPadding: 8
        bottomPadding: 16
        rightPadding: 0
        leftPadding: 0
        clip: true
        modal: true
        focus: true // Ensure proper focus handling
        Component.onCompleted:
        {
            mItem.okHited = false
        }
        onOpened: {
            y: mItem.y + mItem.height - 1
            x: mItem.x + mItem.width - width + 16

        }


        onAboutToHide: {
            if(!mItem.okHited)
            {
                selectionMode = lastSelectionMode
                rangeEndDate= null
                rangeStartDate=  null
            }
        }


        background: Rectangle {
            anchors.fill: parent
            color: mApplicationTheme.mainShade1
            radius: 0
        }

        ColumnLayout {
            id: mainLayout
            anchors.fill: parent
            spacing: 34

            // ========================================================================================
            // SELECTION MODE TABS
            // ========================================================================================

            Pane {
                id: uTabBar_Pane
                padding: 0
                Layout.fillWidth: true
                Layout.preferredHeight: 36
                Layout.maximumHeight: 36

                background: Rectangle {
                    anchors.fill: parent
                    color: mApplicationTheme.mainShade1
                    radius: 0
                }

                TabBar {
                    id: selectionModeBar
                    width: parent.width
                    spacing: 5
                    padding: 0
                    font: mApplicationTheme.font_Fa_Medium_Regular
                    Material.background: mApplicationTheme.mainTint1
                    Material.accent: mApplicationTheme.mainTint2
                    currentIndex: mItem.selectionMode

                    onCurrentIndexChanged: {
                        mItem.selectionMode = currentIndex
                        if (currentIndex === 0) {
                            // Switched to single date mode - reset range
                            resetRange()
                        } else {
                            // Switched to range mode - reset single selection
                            selectedDate = null
                        }
                    }

                    TabButton {
                        id: singleDateTab
                        text: "انتخاب روز"
                        padding: 0

                        contentItem: IconLabel {
                            text: singleDateTab.text
                            font: parent.font
                            color: !singleDateTab.enabled ? mApplicationTheme.mainTint4:
                                                            singleDateTab.down || singleDateTab.checked ? mApplicationTheme.mainTint4 : mApplicationTheme.mainTint3
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            color: !singleDateTab.enabled ? mApplicationTheme.mainTint2:
                                                            singleDateTab.down || singleDateTab.checked ? mApplicationTheme.mainTint2 : mApplicationTheme.mainTint1
                            radius: 0
                        }

                        onClicked: selectedDate = currentDate
                    }

                    TabButton {
                        id: rangeTab
                        text: "انتخاب بازه"
                        padding: 0

                        contentItem: IconLabel {
                            text: rangeTab.text
                            font: parent.font
                            color: !rangeTab.enabled ? mApplicationTheme.mainTint4:
                                                       rangeTab.down || rangeTab.checked ? mApplicationTheme.mainTint4 : mApplicationTheme.mainTint3
                        }

                        background: Rectangle {
                            anchors.fill: parent
                            color: !rangeTab.enabled ? mApplicationTheme.mainTint2:
                                                       rangeTab.down || rangeTab.checked ? mApplicationTheme.mainTint2 : mApplicationTheme.mainTint1
                            radius: 0
                        }
                    }
                }
            }

            // ========================================================================================
            // RANGE SELECTION INFO AND CONTROLS
            // ========================================================================================

            Text {
                id: uInstruction_Text
                Layout.fillWidth: true
                visible: rangeTab.checked
                horizontalAlignment: Text.AlignHCenter
                text: {
                    if (!rangeStartDate) {
                        return "ابتدای بازه را انتخاب کنید"
                    } else if (!rangeEndDate) {
                        return "انتهای بازه را انتخاب کنید"
                    } else {
                        return "بازه انتخابی: " +
                                DateConversion.toFarsiNumber(rangeStartDate.d) + " " +
                                DateConversion.monthName(rangeStartDate.m) + " تا " +
                                DateConversion.toFarsiNumber(rangeEndDate.d) + " " +
                                DateConversion.monthName(rangeEndDate.m)
                    }
                }
                color: mApplicationTheme.yellow
                font: mApplicationTheme.font_Fa_Medium_Regular
            }

            // ========================================================================================
            // CALENDAR SECTION
            // ========================================================================================

            ColumnLayout {
                id: uCalendar_Layout
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 17
                Layout.rightMargin: 8
                Layout.leftMargin: 8

                // ========================================================================================
                // YEAR NAVIGATION
                // ========================================================================================

                Pane {
                    id: uNavigationYear_Pane
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    padding: 0

                    background: Rectangle {
                        color: mApplicationTheme.main
                    }

                    RowLayout {
                        anchors.fill: parent

                        IconButton {
                            id: prevYearButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.maximumWidth: 36
                            mApplicationTheme: mItem.mApplicationTheme
                            _icon: "Left_Icon_F_E"
                            _ButtonSize: 36
                            onClicked: navigateYear(-1)
                            _ButtonStyle: IconButton.ButtonStyle.Navigation
                        }

                        Text {
                            id: headerText
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: mApplicationTheme.mainTint3
                            font: mApplicationTheme.font_Fa_Medium_Regular
                            text: DateConversion.toFarsiNumber(displayYear)
                        }

                        IconButton {
                            id: nextYearButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.maximumWidth: 36
                            mApplicationTheme: mItem.mApplicationTheme
                            _icon: "Right_Icon_F_E"
                            _ButtonSize: 36
                            onClicked: navigateYear(1)
                            _ButtonStyle: IconButton.ButtonStyle.Navigation
                        }
                    }
                }

                // ========================================================================================
                // MONTH NAVIGATION
                // ========================================================================================

                Pane {
                    id: uNavigationMonth_Pane
                    Layout.fillWidth: true
                    Layout.preferredHeight: 36
                    padding: 0

                    background: Rectangle {
                        color: mApplicationTheme.main
                    }

                    RowLayout {
                        anchors.fill: parent

                        IconButton {
                            id: prevButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.maximumWidth: 36
                            mApplicationTheme: mItem.mApplicationTheme
                            _icon: "Left_Icon_F_E"
                            _ButtonSize: 36
                            onClicked: navigateMonth(1)
                            _ButtonStyle: IconButton.ButtonStyle.Navigation
                        }

                        Text {
                            id: monthText
                            Layout.fillHeight: true
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                            horizontalAlignment: Text.AlignHCenter
                            color: mApplicationTheme.mainTint3
                            text: thisMonth
                            font: mApplicationTheme.font_Fa_Medium_Regular
                        }

                        IconButton {
                            id: nextButton
                            Layout.fillWidth: true
                            Layout.fillHeight: true
                            Layout.maximumWidth: 36
                            mApplicationTheme: mItem.mApplicationTheme
                            _icon: "Right_Icon_F_E"
                            _ButtonSize: 36
                            onClicked: navigateMonth(-1)
                            _ButtonStyle: IconButton.ButtonStyle.Navigation
                        }
                    }
                }

                // ========================================================================================
                // CALENDAR GRID
                // ========================================================================================

                ColumnLayout {
                    id: uDateNumber_ColumnLayout
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    spacing: 3
                    Layout.alignment: Qt.AlignHCenter

                    GridLayout {
                        id: calendarGrid
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.rightMargin: 8
                        Layout.leftMargin: 8
                        Layout.alignment: Qt.AlignHCenter
                        columns: 7
                        rowSpacing: 8
                        columnSpacing: 8

                        Repeater {
                            id: calendarRepeater
                            model: 42 // 6 weeks × 7 days

                            delegate: Rectangle {
                                id: dayCell
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                Layout.minimumWidth: 32
                                Layout.minimumHeight: 32
                                Layout.maximumWidth: 32
                                Layout.maximumHeight: 32

                                // Calculate day number for this cell
                                property int dayNumber: {
                                    let cellDay = index - firstDayOfMonth + 1
                                    return (cellDay > 0 && cellDay <= daysInMonth) ? cellDay : 0
                                }

                                property bool isValidDay: dayNumber > 0

                                // Create date object for this cell
                                property var cellDate: isValidDay ? {
                                                                        "y": displayYear,
                                                                        "m": displayMonth,
                                                                        "d": dayNumber
                                                                    } : null

                                // Visual state calculations
                                property bool isSingleSelected: {
                                    if (selectionMode !== 0 || !selectedDate || !isValidDay) return false
                                    return selectedDate.y === displayYear &&
                                            selectedDate.m === displayMonth &&
                                            selectedDate.d === dayNumber
                                }

                                property bool isRangeStart: isValidDay && mItem.isRangeStart(cellDate)
                                property bool isRangeEnd: isValidDay && mItem.isRangeEnd(cellDate)
                                property bool isInRange: isValidDay && mItem.isDateInRange(cellDate)

                                // Color logic
                                color: {
                                    if (!isValidDay) return dayNumberBackColor

                                    if (selectionMode === 0) {
                                        // Single date mode
                                        return isSingleSelected ? selectedDayColor : dayNumberBackColor
                                    } else {
                                        // Range mode
                                        if (isRangeStart || isRangeEnd) {
                                            return rangeStartColor
                                        } else if (isInRange) {
                                            return rangeMiddleColor
                                        } else {
                                            return dayNumberBackColor
                                        }
                                    }
                                }

                                border.color: {
                                    if (!isValidDay) return dayNumberBackColor

                                    if (selectionMode === 0) {
                                        return isSingleSelected ? selectedDayColor : dayNumberBackColor
                                    } else {
                                        if (isRangeStart || isRangeEnd) {
                                            return rangeStartColor
                                        } else {
                                            return dayNumberBackColor
                                        }
                                    }
                                }

                                border.width: {
                                    if (!isValidDay) return 0

                                    if (selectionMode === 0) {
                                        return isSingleSelected ? selectedDayBorderWidth : 0
                                    } else {
                                        return (isRangeStart || isRangeEnd) ? selectedDayBorderWidth : 0
                                    }
                                }

                                radius: 0

                                Text {
                                    id: dayText
                                    anchors.centerIn: parent
                                    text: dayCell.isValidDay ? DateConversion.toFarsiNumber(dayCell.dayNumber) : ""
                                    color: {
                                        if (!dayCell.isValidDay) return daysTextColor

                                        if (selectionMode === 0) {
                                            return dayCell.isSingleSelected ? mApplicationTheme.mainShade2 : daysTextColor
                                        } else {
                                            if (dayCell.isRangeStart || dayCell.isRangeEnd) {
                                                return mApplicationTheme.mainShade2
                                            } else if (dayCell.isInRange) {
                                                return mApplicationTheme.mainTint4
                                            } else {
                                                return daysTextColor
                                            }
                                        }
                                    }
                                    font: mApplicationTheme.font_Fa_Medium_Regular
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    enabled: dayCell.isValidDay

                                    onClicked: {
                                        if (dayCell.isValidDay) {
                                            selectDay(dayCell.dayNumber)
                                        }
                                    }

                                    onPressed: {
                                        if (dayCell.isValidDay) {
                                            parent.opacity = 0.8
                                        }
                                    }

                                    onReleased: {
                                        parent.opacity = 1.0
                                    }
                                }
                            }
                        }
                    }
                }


                // Action buttons
                RowLayout {
                    id: uActionButtons_RowLayout
                    Layout.fillWidth: true
                    Layout.rightMargin: 8
                    Layout.leftMargin: 8
                    Layout.preferredHeight: 40
                    spacing: 8

                    CustomButton {
                        id: resetButton
                        text: "انتخاب مجدد"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        Layout.maximumHeight: 40
                        enabled: (selectionMode === 0 && selectedDate) ||
                                 (selectionMode === 1 && (rangeStartDate || rangeEndDate))
                        _ButtonStyle: CustomButton.ButtonStyle.Optional
                        onClicked: {
                            if (selectionMode === 0) {
                                selectedDate = currentDate
                            } else {
                                resetRange()
                            }
                        }
                    }

                    CustomButton {
                        id: uApply_CustomButton
                        text: "تایید انتخاب"
                        Layout.fillWidth: true
                        Layout.preferredHeight: 40
                        Layout.maximumHeight: 40

                        enabled: (selectionMode === 0 && selectedDate) ||
                                 (selectionMode === 1 && rangeStartDate && rangeEndDate)
                        _ButtonStyle: CustomButton.ButtonStyle.Optional
                        onClicked: {
                        if(selectionMode === 0 )
                        {
                            mItem.dateSelected(selectedDate)
                            mItem.lastSelectionMode=0
                        }
                        else
                        {
                            mItem.lastSelectionMode=1
                            mItem.dateRangeSelected(rangeStartDate, rangeEndDate)
                            mItem.rangeEndDateLastSelected =rangeEndDate
                            mItem.rangeStartDateLastSelected=rangeStartDate
                        }
                        mItem.okHited = true
                        mItem.showResult()
                            mItem.popup.close()
                        }
                    }
                }
            }
        }
    }
}
