
# 📅 Persian Calendar QML

A modern **Persian (Jalali) Calendar** widget/application built using **Qt Quick (QML)** with **JavaScript** date conversion logic.  
This project provides a **beautiful, responsive, and themeable Persian Calendar** that can be embedded in QML applications or run as a standalone app.

---

## ✨ Features

- 📆 **Accurate Persian (Jalali) Date** calculations  
- 🔄 **Gregorian ↔ Jalali conversion** using `date-conversion.js`  
- 🎨 **Custom UI theme** with an `ApplicationTheme.qml` file  
- 🖱 **Custom buttons and icons** (`CustomButton.qml`, `IconButton.qml`)  
- 📱 **Responsive & adaptive** layout for different screen sizes  
- 🚀 **Built entirely in QML** — lightweight & fast  
- 🌏 Localization-friendly design  

---

## 📂 Project Structure  

```
Persian-Calendar-Qml/
│── ApplicationTheme.qml      # App-wide theme & colors
│── CustomButton.qml          # Custom styled button control
│── Icon.qml                  # Icon helper QML
│── IconButton.qml            # Icon with button behavior
│── PersianCalender.qml       # Main Persian Calendar widget
│── date-conversion.js        # Jalali ↔ Gregorian conversion logic
│── main.qml                  # Root QML for GUI
│── main.cpp                  # C++ entry point, loads QML engine
│── Resources.qrc             # Resource file for images/icons
│── qml.qrc                   # QML resources
│── Persian_Calendar_Qml.pro  # Qt Project file
│── Resources/Icon/           # App icons
│── README.md                 # Project documentation
```

---

## 🛠 Technologies Used

- **[Qt 5/6](https://www.qt.io/)** — Cross-platform framework  
- **QML** — UI and layout  
- **JavaScript** — Date conversion logic  
- **C++** — Application entry point  

---

## 📦 Installation & Build Instructions  

### **1. Prerequisites**
- Install **Qt 5.x or Qt 6.x** with `Qt Quick` and `QML` modules  
- Install a C++ compiler (GCC, MSVC, or Clang)  
- Have **Qt Creator** (recommended) or CMake with qmake support  

---

### **2. Clone the Repository**
```bash
git clone https://github.com/abbaslele/Persian-Calendar-Qml.git
cd Persian-Calendar-Qml
```

---

### **3. Open in Qt Creator**
- Open `Persian_Calendar_Qml.pro` in **Qt Creator**  
- Configure the kit (Desktop Qt 5/6)  
- Click **Build** → **Run**  

---

### **4. Build via Command Line (Optional)**
```bash
qmake Persian_Calendar_Qml.pro
make         # or 'nmake' / 'mingw32-make' depending on platform
./Persian-Calendar-Qml
```

---

## 📸 Screenshot / Demo

> _Add your app screenshots here to make it visually appealing_

Example:
![Persian Calendar Screenshot](Resources/Icon/demo_screenshot.png)  

---

## 🎯 Usage

- The app opens showing **today’s date** in the Persian calendar.  
- Use navigation buttons to switch **months**.  
- Click on a date to select it.  
- Conversion between **Persian ↔ Gregorian** happens in the background via `date-conversion.js`.  

---

## 🧩 Embedding the Persian Calendar in Another QML Project

You can re-use `PersianCalender.qml` in your projects:  

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

PersianCalender {
    id: persianCalendar
    anchors.centerIn: parent
}
```

Make sure to also include:
- `date-conversion.js`
- Any required icons & themes from `Resources/Icon/`  

---

## 📜 License

This project is licensed under the **GPL-3.0 License** — see [LICENSE](LICENSE) for details.  
You are free to modify and distribute it as long as your project is also open source under GPL.

---

## 👨‍💻 Author

**Abbas Lele**  
🔗 [GitHub](https://github.com/abbaslele)

