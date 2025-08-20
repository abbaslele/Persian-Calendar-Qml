import QtQuick 2.15
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts


Button {
    id: root
    property ApplicationTheme mApplicationTheme
    property string _icon : ""
    property int _Pathbackward : 2
    property int _ButtonSize: 48
    property int  _IconSize: 32

    property string pathBack:{
        switch(_Pathbackward){
        case 3:
            return "../../../"
        default : {
            return "../../"
        }
        }
    }


    enum ButtonStyle {
        Navigation,
        Normal,
        Warning,
        Action,
        Ribbon
    }

    property int _ButtonStyle: IconButton.ButtonStyle.Action

    property string mEnableColor: mApplicationTheme.mainTint4
    property string mEnableIconColor: mApplicationTheme.mainTint4

    property string mDisableColor: mApplicationTheme.mainTint1
    property string mDisableIconColor: mApplicationTheme.main

    property string mHoverColor: mApplicationTheme.mainTint4
    property string mHoverIconColor: mApplicationTheme.mainTint2

    property string mPressedColor: mApplicationTheme.mainTint3
    property string mPressedIconColor: mApplicationTheme.mainShade2


    Component.onCompleted: {
        switch(_ButtonStyle) {
        case IconButton.ButtonStyle.Action:
            mEnableColor = "transparent"
            mEnableIconColor = mApplicationTheme.mainTint3

            mDisableColor = "transparent"
            mDisableIconColor = mApplicationTheme.mainTint1

            mHoverColor = mApplicationTheme.mainShade1
            mHoverIconColor = mApplicationTheme.mainTint3

            mPressedColor = "transparent"
            mPressedIconColor = mApplicationTheme.mainTint4
            break
        case IconButton.ButtonStyle.Normal:
            mEnableColor = "transparent"
            mEnableIconColor = mApplicationTheme.mainTint3

            mDisableColor = "transparent"
            mDisableIconColor = mApplicationTheme.mainTint1

            mHoverColor = mApplicationTheme.white_Op10
            mHoverIconColor = mApplicationTheme.mainTint3

            mPressedColor = "transparent"
            mPressedIconColor = mApplicationTheme.mainTint4
            break
        case IconButton.ButtonStyle.Warning:
            mEnableColor = "transparent"
            mEnableIconColor = mApplicationTheme.mainTint4

            mDisableColor = "transparent"
            mDisableIconColor = mApplicationTheme.redShade1

            mHoverColor = mApplicationTheme.white_Op10
            mHoverIconColor = mApplicationTheme.mainTint4

            mPressedColor = "transparent"
            mPressedIconColor = mApplicationTheme.red
            break
        case IconButton.ButtonStyle.Navigation:
            mEnableColor = mApplicationTheme.mainTint1
            mEnableIconColor = mApplicationTheme.mainTint4

            mHoverColor = mApplicationTheme.mainTint2
            mHoverIconColor = mApplicationTheme.mainTint4

            mDisableColor = mApplicationTheme.mainTint1
            mDisableIconColor = mApplicationTheme.mainTint2

            mPressedColor = mApplicationTheme.mainTint3
            mPressedIconColor = mApplicationTheme.mainTint4
            break
        case IconButton.ButtonStyle.Ribbon:
            mEnableColor = mApplicationTheme.mainShade2
            mEnableIconColor = mApplicationTheme.mainTint3

            mHoverColor = mApplicationTheme.main
            mHoverIconColor = mApplicationTheme.mainTint3

            mDisableColor = mApplicationTheme.white_Op10
            mDisableIconColor = mApplicationTheme.mainTint3

            mPressedColor = mApplicationTheme.mainTint1
            mPressedIconColor = mApplicationTheme.mainTint4
            break
        }
    }


    state: "Normal"
    states:[
        State{
            name: "Pressed"
            PropertyChanges { target: background; color: mPressedColor }
            PropertyChanges { target: root; icon.color:mPressedIconColor }
        },
        State{
            name: "Normal"
            PropertyChanges { target: background; color:mEnableColor }
            PropertyChanges { target: root; icon.color:mEnableIconColor }
        },
        State{
            name: "Hover"
            PropertyChanges { target: background; color:  mHoverColor}
            PropertyChanges { target: root; icon.color:mHoverIconColor }
        },
        State{
            name: "Disable"
            PropertyChanges { target: background; color:  mDisableColor }
            PropertyChanges { target: root; icon.color:mDisableIconColor }
        }
    ]


    background: Rectangle {
        id : background
        // color: control.pressed ? _backgroundColor_Pressed : _backgroundColor// Static color change
    }

    property bool isRTL : true

    property string buttonText_Tooltip
    ToolTip.text: buttonText_Tooltip
    ToolTip.visible: {
        if(buttonText_Tooltip !== ""){
            hovered
        }else{
            null
        }
    }

    topPadding: 0
    bottomPadding: 0
    leftPadding: 0
    rightPadding: 0
    topInset: 0
    bottomInset: 0
    leftInset: 0
    rightInset: 0

    ToolTip.delay: 500
    ToolTip.timeout: 4000

    Layout.fillHeight: true
    Layout.fillWidth:  true

    Layout.minimumWidth: _ButtonSize
    Layout.maximumWidth: _ButtonSize
    Layout.maximumHeight: _ButtonSize
    Layout.minimumHeight: _ButtonSize
    //Layout.minimumWidth: icon.width + leftPadding + rightPadding


    Material.roundedScale : Material.NotRounded

    Material.elevation: mApplicationTheme.elevation

    // contentItem: Icon{
    //     id: icon
    //     anchors.centerIn: root

    //     _Pathbackward : root._Pathbackward
    //     _size: root._IconSize
    //     _icon : root._icon
    // }
    icon.name: "edit-cut"
    // icon.color :  _iconColor
    icon.source:  _icon === "" ? "" : pathBack + "Resources/Icon/"+ _icon +".svg"
    icon.height: _IconSize
    icon.width: _IconSize

    onPressed: state = state !== "Disable" ? "Pressed" : "Disable"
    onReleased: state = state !== "Disable" ? "Normal" : "Disable"
    onEnabledChanged: state =  enabled ? "Normal" : "Disable"
    onHoveredChanged: state = hovered ? "Hover": "Normal"

    HoverHandler {
        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
        cursorShape: state != "Disable" ? Qt.PointingHandCursor : Qt.ForbiddenCursor

    }

}
