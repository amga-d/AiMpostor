# 🌱 AiMpostor

An intelligent agriculture platform with mobile app for plant disease detection, seed quality assessment, and pest growth prediction.

## 🚀 Overview

AiMpostor leverages AI technology to help farmers and agricultural professionals make data-driven decisions. Our mobile application connects to a Node.js backend with Gemini AI integration to provide actionable insights for better crop management, specifically designed for Indonesia's agricultural community.

## ✨ Features

- **Plant Disease Detection**: Upload images of plants to identify diseases and get treatment recommendations
- **Seed Quality Assessment**: Analyze seed quality through image processing
- **Fertilizer Recipe Generation**: Get personalized fertilizer recommendations
- **Pest Growth Prediction**: Predict pest growth patterns and potential infestations
- **Chat Support**: Communicate with AI assistance for agricultural queries

## 🛠️ Tech Stack

### Frontend (AgriWise Mobile App)
- **Framework**: Flutter
- **Authentication**: Firebase Auth
- **State Management**: Provider/Bloc 

### Backend
- **Server**: Node.js
- **Storage**: Google Cloud Storage
- **Database**: Firestore
- **AI Integration**: Gemini API
- **Image Processing**: Multer

## 📁 Project Structure

```
AiMpostor/
├── backend/                # Node.js server
│   ├── src/
│   │   ├── ai/             # AI integration modules
│   │   ├── config/         # Configuration files
│   │   ├── controllers/    # API controllers
│   │   ├── helpers/        # Utility functions
│   │   ├── middlewares/    # Request middlewares
│   │   ├── models/         # Data models
│   │   ├── routes/         # API routes
│   │   └── schemas/        # Data validation schemas
│   ├── .env                # Environment variables (not committed)
│   ├── dockerfile          # Docker configuration
│   └── server.js           # Main entry point
│
└── frontend/              
    └── AgriWise/           # Flutter mobile application
        ├── assets/         # Static assets (fonts, icons)
        └── lib/
            ├── helpers/    # Helper functions
            ├── models/     # Data models
            ├── screens/    # UI screens
            │   ├── disease_detection/
            │   ├── fertilizer_recipe/
            │   ├── pest_forecast/
            │   └── seeding_quality/
            ├── services/   # Service classes
            ├── widgets/    # Reusable UI components
            └── main.dart   # Entry point
```

## 📱 Screenshots

![image](https://github.com/user-attachments/assets/6691310e-4438-4d3c-a2cf-8ffe3613c73b)
![image](https://github.com/user-attachments/assets/aacbac76-de61-4c39-9b0c-280976679734)
![image](https://github.com/user-attachments/assets/232bee51-023d-46ac-bd33-ec63707c9911)
![image](https://github.com/user-attachments/assets/5582cf79-19d4-4ccd-844c-ea47205c14b8)
![image](https://github.com/user-attachments/assets/435c72b4-50fb-436d-8517-fcfa82dbbf83)

## 🏁 Getting Started

### Prerequisites

- Flutter SDK (3.0+)
- Node.js (16+)
- Android Studio
- Firebase account
- Google Cloud Platform account
- Gemini API key

### Backend Setup

1. Clone the repository:
   ```bash
   git clone https://github.com/Wibson27/AiMpostor.git
   cd AiMpostor/backend
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Create a `.env` file based on `.env.example`:
   ```
   PORT=5000
   FIREBASE_API_KEY=your-firebase-api-key
   GEMINI_API_KEY=your-gemini-api-key
   GCS_BUCKET=your-gcs-bucket
   ```

4. Start the server:
   ```bash
   npm start
   ```

### Frontend Setup

1. Navigate to the frontend directory:
   ```bash
   cd ../frontend/AgriWise
   ```

2. Install Flutter dependencies:
   ```bash
   flutter pub get
   ```

3. Update `firebase_options.dart` with your Firebase configuration

4. Update the API endpoint in `services/http_service.dart` to point to your backend server

5. Run the application:
   ```bash
   flutter run
   ```

## 🚀 Deployment

### Backend
```bash
# Using Docker
docker build -t aimpostor-backend .
docker run -p 5000:5000 aimpostor-backend
```

### Frontend
```bash
# Build APK
flutter build apk --release

# Build App Bundle for Play Store
flutter build appbundle
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](docs/CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Project Manager**: Alma Nurul Salma
- **Frontend Development**: Rifqi Wibisono & Amgad Al-Ameri
- **Backend Development**: Amgad Al-Ameri & Rifqi Wibisono
- **UI/UX Designer**: Vivi Zalzabilah

## 📫 Contact

For questions or support, please open an issue or contact us at [23523001@students.uii.ac.id]

---

<p align="center">Made with ❤️ for Indonesia's agricultural community</p>
