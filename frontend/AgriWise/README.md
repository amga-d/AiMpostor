# AgriWise - Intelligent Agriculture Mobile Application

## 📱 Overview

AgriWise is an intelligent agriculture platform with a Flutter mobile app designed to help farmers identify plant diseases, assess seed quality, and predict pest growth. The application leverages AI technology to provide smart agriculture solutions.

## ✨ Features

- **Plant Disease Detection**: Identify plant diseases using your camera
- **Seed Quality Assessment**: Analyze seed quality with AI-powered image recognition
- **Pest Growth Prediction**: Forecast potential pest outbreaks
- **Fertilizer Recipe Generator**: Get personalized fertilizer recommendations

## 🛠️ Tech Stack

- **Mobile**: Flutter SDK
- **Authentication**: Firebase Auth
- **Backend**: Node.js (API Server)
- **AI Integration**: Google Cloud Vision API & Gemini API

## 🏗️ Project Structure

```
AgriWise/
├── lib/                  # Main Dart code
│   ├── main.dart         # Application entry point
│   ├── screens/          # UI screens
│   ├── services/         # API and service integrations
│   ├── models/           # Data models
│   └── widgets/          # Reusable UI components
├── assets/
│   ├── fonts/            # Custom fonts
│   └── icons/            # App icons and images
└── firebase_options.dart # Firebase configuration
```

## 🧪 Dependencies

The app relies on several key packages:

- `firebase_auth` & `firebase_core` for authentication
- `image_picker` for camera integration
- `http` for API requests
- `flutter_svg` for vector graphics
- `flutter_dotenv` for environment configuration

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.7.2+)
- Dart SDK
- Android Studio / Xcode
- Firebase account

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/Wibson27/AiMpostor.git
   cd AiMpostor/frontend/AgriWise
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure Firebase:

   - Create a Firebase project
   - Add Android/iOS apps to your Firebase project
   - Download and place the configuration files:
     - `google-services.json` in `android/app/`
   - Create `lib/firebase_options.dart` with your Firebase config

   4. Create an `.env` file in the project root:

      ```
      BASE_URL=https://aimpostor-889491896780.asia-southeast2.run.app
      ```

      > If you have hosted the backend server elsewhere, you can specify its public URL here instead.

4. Run the application:
   ```bash
   flutter run
   ```

## 📱 Building for Production

### Android

```bash
flutter build apk --release
```

## 🔧 Platform-Specific Notes

### Android

- Minimum SDK: 23 (Android 6.0)
- Implemented with Kotlin
- Registered plugins: Firebase Auth, Firebase Core, Image Picker, Path Provider
- Thoroughly tested and optimized for Android devices

### Web (Chrome)

- Progressive Web App functionality
- Optimized for Chrome browser
- Uses HTML5 camera APIs for image capture
- LocalStorage for maintaining session data

### iOS

- Native modules via CocoaPods
- Plugin registration handled through Objective-C bridges
- Note: Not extensively tested on iOS devices

## 👥 Contributors

- **Rifqi Wibisono** - Frontend Development
- **Amgad Al-Ameri** - Frontend & Backend Development
- **Alma Nurul Salma** - Project Manager
- **Vivi Zalzabilah** - UI/UX Designer

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact

For questions or support, please contact us at [23523242@students.uii.ac.id](mailto:23523242@students.uii.ac.id) or [23523001@students.uii.ac.id](mailto:23523001@students.uii.ac.id)

---

<p align="center">Made with ❤️ for Indonesia's agricultural community</p>
