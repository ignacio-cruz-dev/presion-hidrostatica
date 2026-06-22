# HydroPressure Lab

HydroPressure Lab is a professional Flutter application designed for hydrostatic pressure calculations used in drilling, petroleum engineering, and industrial fluid analysis.

Developed by Grupo TANIS Ingeniería y Consultoría.

---

# 🚀 Features

- Hydrostatic pressure calculation (BHP)
- Multiple unit systems:
  - SI Metric
  - Field Units (ppg / ft)
  - Mixed System
- Real-time pressure visualization
- Fluid presets:
  - Fresh water
  - Salt water
  - Light mud
  - Heavy mud
  - Oil
  - Cement
- Interactive depth slider
- Calculation history
- PDF report generation
- Responsive Web + Mobile UI
- Custom splash screen
- Professional industrial design

---

# 🛠 Technologies Used

- Flutter
- Dart
- Hive (Local Storage)
- PDF / Printing
- Syncfusion Charts
- Font Awesome
- URL Launcher

---

# 📱 Screenshots

## Mobile Version

- Splash Screen
- Hydrostatic Pressure Calculator
- Fluid Selection
- PDF Export

## Web Version

Responsive interface compatible with desktop and mobile browsers.

---

# 📂 Project Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── enums/
│   └── theme/
│
├── features/
│   └── calculator/
│       ├── models/
│       ├── services/
│       ├── ui/
│       │   ├── screens/
│       │   └── widgets/
```

---

# ⚙️ Getting Started

## Requirements

- Flutter SDK 3.x
- Dart SDK
- Android Studio or VSCode
- Android SDK

---

# 📦 Installation

Clone repository:

```bash
git clone <repository_url>
```

Install dependencies:

```bash
flutter pub get
```

Run app:

```bash
flutter run
```

---

# 🤖 Build APK

## Debug APK

```bash
flutter build apk
```

## Release APK

```bash
flutter build apk --release
```

APK generated at:

```text
build/app/outputs/flutter-apk/app-release.apk
```

---

# 🎨 Splash Screen

Generated with:

```bash
dart run flutter_native_splash:create
```

---

# 🧩 Launcher Icon

Generated with:

```bash
dart run flutter_launcher_icons
```

---

# 🌐 Supported Platforms

- Android
- Web

---

# 🏢 Developed By

## Grupo TANIS

Altas Soluciones para la Industria

---