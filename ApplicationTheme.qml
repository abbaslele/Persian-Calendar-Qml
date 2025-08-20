import QtQuick 2.15
import QtQuick.Controls.Material 2.15

QtObject {

    property int bordeRadius: 8
    property int bordeMargin: 6
    property int layoutSpacing: 8 // Ensure this property exists
    property int defaultMargin: 6
    property int elevation: 0


    property bool isThemeDark: true

    // Use the Theme singleton properties
    property var theme :  isThemeDark ? Material.Dark : Material.Light

    //   **ColorStyles**
    property string mainTint4: "#F8F8F8"
    property string mainTint3: "#C3C1BF"
    property string mainTint2: "#858381"
    property string mainTint1: "#7A7775"
    property string main: "#3F3C3A"
    property string mainShade1: "#32302E"
    property string mainShade2: "#262423"
    property string mainShade2Op: "#E6262423"
    property string red:  "#FFA5A5"
    property string redShade1:    "#BC5F5F"
    property string redShade2:     "#914141"
    property string redShade3:   "#9D4C4C"
    property string green: "#90E29C"
    property string yellow:  "#FFD56B"
    property string violetTint1:   "#EABFFF"
    property string violet:  "#9A6FB0"
    property string violetShade1:  "#7E5792"
    property string white_Op10:  "#1AFFFFFF"
     property string red_Dis:  "#785B5A"
     property string redShade2_Dis:  "#573D3C"
     property string redShade3_Dis:  "#5B413F"
     property string mainTint4_Dis:  "#767473"
     property string mainTint3_Dis:  "#666462"

    // Buttons Backgrounds
    property string button_Icon_Normal: "#262423"
    property string button_Icon_Pressed: "#7A7775"
    property string button_Icon_Disable: "#262423"
    property string button_Icon_Hover: "#1AFFFFFF"
    property string button_Primary_Normal: ""
    property string button_Primary_Pressed: ""
    property string button_Primary_Disable: ""
    property string button_Primary_Hover: "#1AFFFFFF"
    property string button_Secondary_Normal: ""
    property string button_Secondary_Pressed: ""
    property string button_Secondary_Disable: ""
    property string button_Secondary_Hover: "#1AFFFFFF"


    /// Persian Font÷
    property string fontFaFamily: "B Mitra"
    property font font_Fa_3X_Large_Regular: Qt.font({ family: fontFaFamily, pixelSize: 48 , weight: Font.Normal})
    property font font_Fa_3X_Large_Bold: Qt.font({ family: fontFaFamily, pixelSize: 48 , weight: Font.Bold})
    property font font_Fa_2X_Large_Regular: Qt.font({ family: fontFaFamily, pixelSize: 40 , weight: Font.Normal})
    property font font_Fa_2X_Large_Bold: Qt.font({ family: fontFaFamily, pixelSize: 40 , weight: Font.Bold	})
    property font font_Fa_Large_Regular:   Qt.font({ family: fontFaFamily, pixelSize: 32 , weight: Font.Normal})
    property font font_Fa_Large_Bold:   Qt.font({ family: fontFaFamily, pixelSize: 32 , weight: Font.Bold })
    property font font_Fa_Medium_Regular:     Qt.font({ family: fontFaFamily, pixelSize: 24 , weight: Font.Normal	})
    property font font_Fa_Medium_Bold:     Qt.font({ family: fontFaFamily, pixelSize: 24 , weight: Font.Bold })
    property font font_Fa_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 20 , weight: Font.Normal	})
    property font font_Fa_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 20 , weight: Font.Bold	})
    property font font_Fa_2X_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 16 , weight: Font.Normal	})
    property font font_Fa_2X_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 16 , weight: Font.Bold	})
    property font font_Fa_3X_Small_Regular:  Qt.font({ family: fontFaFamily, pixelSize: 10 , weight: Font.Normal	})
    property font font_Fa_3X_Small_Bold:  Qt.font({ family: fontFaFamily, pixelSize: 10 , weight: Font.Bold	})


    function toFarsiNumber(input) {
        // Convert string input to Persian numerals
        var persianDigits = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
        var englishDigits = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

        var result = input.toString();
        for (var i = 0; i < englishDigits.length; i++) {
            result = result.replace(new RegExp(englishDigits[i], 'g'), persianDigits[i]);
        }
        return result;
    }


    function toFarsiTwoDigitNumber(num) {
        if (num < 10) {
            return  "۰" + Number(num).toLocaleString(Qt.locale("fa_IR"), 'f', 0).replace(Qt.locale("fa_IR").groupSeparator, ""); // Adding Persian zero (۰) for numbers less than 10
        }else{
            return Number(num).toLocaleString(Qt.locale("fa_IR"), 'f', 0);
        }
    }

}
