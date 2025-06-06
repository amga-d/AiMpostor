# AiMpostor Backend Documentation

This documentation provides a comprehensive overview of the AiMpostor backend server, which provides AI-powered agricultural services including plant disease detection, seed quality assessment, and fertilizer recipe generation.

## Overview

AiMpostor is an agricultural assistance platform that uses Google's Generative AI (Gemini) to help farmers with plant health analysis, seed quality assessment, and fertilizer recommendations. The backend is built on Node.js with Express and integrates with Firebase for authentication and data storage, and Google Cloud Storage for image management.

## Architecture

The application follows a modular architecture with the following components:

- **Routes**: API endpoint definitions
- **Controllers**: Business logic for request handling
- **Models**: Data access layer for Firestore
- **AI Services**: Integration with Google's Generative AI
- **Middlewares**: Authentication, image processing, and validation
- **Config**: Environment and service configurations

## Tech Stack

- **Runtime**: Node.js
- **Framework**: Express.js
- **Database**: Firebase Firestore
- **Authentication**: Firebase Auth
- **Image Storage**: Google Cloud Storage
- **AI**: Google Generative AI (Gemini 2.0 Flash)
- **Image Processing**: Sharp
- **Validation**: Ajv (JSON Schema validation)

## Setup Instructions

### Prerequisites

- Node.js (v18 or newer recommended)
- npm or yarn
- Google Cloud Platform account
- Firebase account
- Google Generative AI API key

### Installation

1. Clone the repository:

   ```bash
   git clone https://github.com/amga-d/AiMpostor.git
   cd AiMpostor/backend
   ```

2. Install dependencies:

   ```bash
   npm install
   ```

3. Configure environment variables:

   - Copy `.env.example` to `.env`:
     ```bash
     cp .env.example .env
     ```
   - Fill in the required environment variables (see Environment Variables section)

4. Start the development server:

   ```bash
   npm run dev
   ```

5. For production:
   ```bash
   npm run start
   ```

### Docker Setup

You can also run the application using Docker:

1. Build the Docker image:

   ```bash
   docker build -t aimpostor-backend .
   ```

2. Run the container:
   ```bash
   docker run -p 8080:8080 --env-file .env aimpostor-backend
   ```

## Environment Variables

The following environment variables are required in your `.env` file:

| Variable                       | Description                                         |
| ------------------------------ | --------------------------------------------------- |
| `PORT`                         | Server port (default: 8080)                         |
| `GEMINI_API_KEY`               | Google Generative AI API key                        |
| `FIREBASE_SERVICE_ACCOUNT_KEY` | Firebase service account JSON (stringified)         |
| `GC_CREDENTIAL`                | Google Cloud Storage credentials JSON (stringified) |
| `GC_BUCKET_NAME`               | Google Cloud Storage bucket name                    |

Example `.env` configuration:

```
PORT=8080
GEMINI_API_KEY=your_gemini_api_key
FIREBASE_SERVICE_ACCOUNT_KEY='{...}' # Firebase service account JSON
GC_CREDENTIAL='{...}' # GCP service account JSON
GC_BUCKET_NAME=your_bucket_name
```

## Base URL

```
/api/v1
```

## Authentication

Authentication is required for all endpoints using Firebase Authentication. Include an `Authorization` header with a Bearer token in all requests:

```
Authorization: Bearer <firebase-auth-token>
```

## API Endpoints

### User Management

#### Create/Register User

- **URL**: `/api/v1/user/signup`
- **Method**: `POST`
- **Auth**: Required
- **Body**:
  ```json
  {
    "name": "User Name"
  }
  ```
- **Response**: User creation status

### Plant Disease Detection

#### Upload Plant Image for Disease Detection

- **URL**: `/api/v1/chats/upload`
- **Method**: `POST`
- **Auth**: Required
- **Content-Type**: `multipart/form-data`
- **Body**:
  - `plantImage`: Image file (JPEG, PNG)
- **Response**: Disease detection results and a new chat ID

#### Continue Chat About Plant Disease

- **URL**: `/api/v1/chats/chat`
- **Method**: `POST`
- **Auth**: Required
- **Body**:
  ```json
  {
    "chatId": "chat-id-from-previous-response",
    "message": "How can I treat this disease organically?"
  }
  ```
- **Response**: AI assistant response

#### List All User Chats

- **URL**: `/api/v1/chats/`
- **Method**: `GET`
- **Auth**: Required
- **Response**: List of all user chats

#### Get Chat History by ID

- **URL**: `/api/v1/chats/:chatId`
- **Method**: `GET`
- **Auth**: Required
- **Response**: Chat history for the specified chat ID

### Seed Quality Assessment

#### Assess Seed Quality

- **URL**: `/api/v1/seed/assess`
- **Method**: `POST`
- **Auth**: Required
- **Content-Type**: `multipart/form-data`
- **Body**:
  - `seedImage`: Image file of seeds (JPEG, PNG)
- **Response**: Seed quality assessment

#### List All Seed Quality Assessments

- **URL**: `/api/v1/seed/assessments`
- **Method**: `GET`
- **Auth**: Required
- **Response**: List of all user's seed quality assessments

#### Get Assessment by ID

- **URL**: `/api/v1/seed/assessments/:id`
- **Method**: `GET`
- **Auth**: Required
- **Response**: Specific seed quality assessment details

### Fertilizer Recipe Generation

#### Generate Fertilizer Recipe

- **URL**: `/api/v1/fertilizer-recipe/`
- **Method**: `POST`
- **Auth**: Required
- **Body**:
  ```json
  {
    "plant": "Tomato",
    "availableMaterials": ["banana peels", "coffee grounds", "eggshells"]
  }
  ```
- **Response**: Custom fertilizer recipe based on available materials

## Response Structures

### Plant Disease Detection Response

```json
{
  "response": {
    "crop": "String",
    "detectedDisease": "String",
    "riskLevel": "String",
    "aboutDisease": "String",
    "recommendedAction": ["String", "String", ...]
  },
  "chatId": "String"
}
```

### Seed Quality Assessment Response

```json
{
  "qualityAssessment": "String",
  "recommendation": "String",
  "details": "String"
}
```

### Fertilizer Recipe Response

```json
{
  "message": "success",
  "data": {
    "plant": "String",
    "availableMaterials": ["String", "String", ...],
    "recipe": {
      "title": "String",
      "ingredients": [
        {
          "quantity": "String",
          "material": "String"
        },
        ...
      ],
      "instructions": ["String", "String", ...]
    }
  }
}
```

## Data Storage

- **User Data**: Stored in Firestore `users` collection
- **Chat History**: Stored in Firestore `users/{userId}/chats` collection
- **Chat Messages**: Stored in Firestore `users/{userId}/chats/{chatId}/messages` collection
- **Seed Assessments**: Stored in Firestore `users/{userId}/qualityAssessments` collection
- **Images**: Stored in Google Cloud Storage bucket

## Development Notes

- Use `npm run dev` to start the development server with hot reloading
- Max file upload size is limited to 5MB
- Environment variables are managed with dotenv
- Request logging uses morgan
- CORS is enabled for all origins

## Security Considerations

- Firebase Authentication is used for user identity verification
- Sensitive credentials should be stored securely and not committed to version control
- API key validation and rate limiting are recommended for production

## Package Dependencies

### Main Dependencies

- `express`: Web server framework
- `@google/generative-ai`: Google's Gemini AI integration
- `firebase-admin`: Firebase services integration
- `multer`: Middleware for handling file uploads
- `sharp`: Image processing library
- `ajv`: JSON Schema validation
- `cors`: Cross-Origin Resource Sharing middleware
- `dotenv`: Environment variable management
- `morgan`: HTTP request logger

### Development Dependencies

- `nodemon`: Development server with hot reloading
- `eslint`: Code linting

## Usage Examples

### Uploading a Plant Image

```bash
curl -X POST \
  -H "Authorization: Bearer <firebase-auth-token>" \
  -F "plantImage=@leaf_sample.jpg" \
  http://localhost:8080/api/v1/chats/upload
```

### Continuing Conversation

```bash
curl -X POST \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <firebase-auth-token>" \
  -d '{"chatId":"abc123","message":"How often should I water the plant?"}' \
  http://localhost:8080/api/v1/chats/chat
```

## 👥 Contributors

- **Amgad Al-Ameri** - Backend Development & Deployment

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact

For questions or support, please contact us at [23523242@students.uii.ac.id](mailto:23523242@students.uii.ac.id)

---

<p align="center">Made with ❤️ for Indonesia's agricultural community</p>
