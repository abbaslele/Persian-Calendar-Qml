import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

Button {
    id: mButton

    property ApplicationTheme mApplicationTheme: mItem.mApplicationTheme
    property string _buttonIcon: ""
    // property string _textColor: mApplicationTheme.mainTint4
    property var _textFont: mApplicationTheme.font_Fa_Medium_Regular
    property int _iconSize: 36
    property string _iconColor: mApplicationTheme.mainTint4

    rightPadding: 4
    leftPadding: 4

    property int _Pathbackward: 2
    property bool iconOnRight: isRTL

    property string pathBack: {
        switch(_Pathbackward) {
        case 3:
            return "../../../"
        default:
            return "../../"
        }
    }

    // Define enum properly
    enum ButtonStyle {
        Primary,
        Secondary,
        Optional
    }

    // Add a property to hold the current style
    property int _ButtonStyle: CustomButton.ButtonStyle.Secondary

    property string mEnableColor: mApplicationTheme.mainTint4
    property string mEnableTextColor: mApplicationTheme.mainShade2

    property string mDisableColor: mApplicationTheme.mainTint1
    property string mDisableTextColor: mApplicationTheme.main

    property string mHoverColor: mApplicationTheme.mainTint4
    property string mHoverBorderColor: mApplicationTheme.mainTint2
    property string mHoverTextColor: mApplicationTheme.mainTint2

    property string mPressedColor: mApplicationTheme.mainTint3
    property string mPressedTextColor: mApplicationTheme.mainShade2

    Component.onCompleted: {
        switch(_ButtonStyle) {
        case CustomButton.ButtonStyle.Primary:
            mEnableColor = mApplicationTheme.mainTint4
            mEnableTextColor = mApplicationTheme.mainShade2

            mDisableColor = mApplicationTheme.mainTint1
            mDisableTextColor = mApplicationTheme.main

            mHoverColor = mApplicationTheme.mainTint4
            mHoverBorderColor = mApplicationTheme.mainTint2
            mHoverTextColor = mApplicationTheme.mainTint2

            mPressedColor = mApplicationTheme.mainTint3
            mPressedTextColor = mApplicationTheme.mainShade2
            break
        case CustomButton.ButtonStyle.Secondary:
            mEnableColor = mApplicationTheme.mainShade1
            mEnableTextColor = mApplicationTheme.mainTint4

            mDisableColor = mApplicationTheme.white_Op10
            mDisableTextColor = mApplicationTheme.mainTint1

            mHoverColor = mApplicationTheme.mainShade1
            mHoverBorderColor = mApplicationTheme.mainTint1
            mHoverTextColor = mApplicationTheme.mainTint2

            mPressedColor = mApplicationTheme.mainShade2
            mPressedTextColor = mApplicationTheme.mainTint4
            break
        case CustomButton.ButtonStyle.Optional:
            mEnableColor = mApplicationTheme.main
            mEnableTextColor = mApplicationTheme.mainTint4

            mHoverColor = mApplicationTheme.main
            mHoverBorderColor = mApplicationTheme.mainTint1
            mHoverTextColor = mApplicationTheme.mainTint2

            mDisableColor = mApplicationTheme.main
            mDisableTextColor = mApplicationTheme.mainTint1

            mPressedColor = mApplicationTheme.mainShade1
            mPressedTextColor = mApplicationTheme.mainTint4
            break
        }
    }


    contentItem: Row {
        visible: _buttonIcon !== ""
        topPadding: 8
        rightPadding: 8
        spacing: 16
        layoutDirection: iconOnRight ? Qt.RightToLeft : Qt.LeftToRight

        Item {
            Layout.fillHeight: true
            width: _iconSize
            height: _iconSize
            visible: _buttonIcon !== ""

            Icon {
                anchors.fill: parent
                _icon: _buttonIcon
                _size: _iconSize
                _Pathbackward: _Pathbackward
                _color: _iconColor

                ColorOverlay {
                    source: parent
                    anchors.fill: parent
                    color: _iconColor
                }
            }
        }

        Text {
            id: iconText
            topPadding: -8
            rightPadding: -8
            Layout.fillHeight: true
            Layout.fillWidth: true
            text: mButton.text
            // color: _textColor
            font: _textFont
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }
    }

    Text {
        id: text
        visible: _buttonIcon === ""
        anchors.fill: parent
        text: mButton.text
        // color: _textColor
        font: _textFont
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }

    state: "Normal"
    states: [
        State {
            name: "Pressed"
            PropertyChanges { target: background; color: mPressedColor }
            PropertyChanges { target: text; color: mPressedTextColor }
            PropertyChanges { target: iconText; color: mPressedTextColor }
            PropertyChanges { target: rightBorder; color:  mHoverBorderColor ; visible: false}
            PropertyChanges { target: leftBorder; color:  mHoverBorderColor ; visible: false}

        },
        State {
            name: "Normal"
            PropertyChanges { target: background; color: mEnableColor }
            PropertyChanges { target: text; color: mEnableTextColor }
            PropertyChanges { target: iconText; color: mPressedTextColor }
            PropertyChanges { target: rightBorder; color:  mHoverBorderColor ; visible: false}
            PropertyChanges { target: leftBorder; color:  mHoverBorderColor ; visible: false}

        },
        State {
            name: "Disable"
            PropertyChanges { target: background; color: mDisableColor }
            PropertyChanges { target: text; color: mEnableTextColor }
            PropertyChanges { target: iconText; color: mPressedTextColor }
            PropertyChanges { target: rightBorder; color:  mHoverBorderColor ; visible: false}
            PropertyChanges { target: leftBorder; color:  mHoverBorderColor ; visible: false}

        },
        State {
            name: "Hover"
            PropertyChanges { target: background; color: mHoverColor }
            PropertyChanges { target: text; color: mEnableTextColor }
            PropertyChanges { target: iconText; color: mPressedTextColor }
            PropertyChanges { target: rightBorder; color:  mHoverBorderColor ; visible: true}
            PropertyChanges { target: leftBorder; color:  mHoverBorderColor ; visible: true}
        }
    ]

    background: Rectangle {
        id: background
        anchors.fill: parent
        border.width: 0

        Rectangle {
            id: rightBorder
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: mHoverBorderColor
            visible: false
        }

        Rectangle {
            id: leftBorder
            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            width: 4
            color: mHoverBorderColor
            visible: false
        }
    }

    property bool isRTL: true
    property string buttonText_Tooltip

    ToolTip.text: buttonText_Tooltip
    ToolTip.visible: buttonText_Tooltip !== "" ? hovered : false
    ToolTip.delay: 500
    ToolTip.timeout: 4000

    Layout.fillHeight: true
    Layout.fillWidth: true
    Layout.minimumHeight: 48
    Layout.preferredHeight: 48
    Layout.maximumHeight: 60

    Material.roundedScale: Material.NotRounded
    Material.elevation: mApplicationTheme.elevation

    onPressed: state = state !== "Disable" ? "Pressed" : "Disable"
    onReleased: state = state !== "Disable" ? "Normal" : "Disable"
    onEnabledChanged: state =  enabled ? "Normal" : "Disable"
    onHoveredChanged: state = hovered ? "Hover": "Normal"

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: state !== "Disable" ? Qt.PointingHandCursor : Qt.ForbiddenCursor
    }
}
