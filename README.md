# AI-Powered Mental Health Companion

A cutting-edge, cross-platform mental health application built with Flutter, designed to provide accessible, personalized, and real-time support. It leverages Artificial Intelligence and community-driven features to bridge the gap between individuals and effective mental health resources.

## Contributor

| Profile | Name | GitHub | Role |
| :--- | :--- | :--- | :--- |
| <img src="https://github.com/ByteNinjaSmit.png" width="100" height="100" style="border-radius:50%"> | Smit (ByteNinjaSmit) | [@ByteNinjaSmit](https://github.com/ByteNinjaSmit) | Lead Developer & Architect |

## Project Overview
The rising prevalence of mental health issues like anxiety, depression, and stress is exacerbated by the limited availability of professional support, social stigmas, and financial constraints. This project serves as a 24/7 digital companion capable of detecting emotional states, conducting clinical-style diagnostic tests, and seamlessly connecting users to verified mental health professionals.

### Key Objectives:
- Real-Time Support: Deliver on-demand emotional backing through NLP and Generative AI.
- Accessibility: Ensure 24/7 localized support regardless of financial status.
- Privacy & Security: Safeguard sensitive clinical and personal data using robust encrypted backends.
- Community Healing: Foster peer-to-peer engagement via moderated forums.

## Technology Stack

- Frontend: Flutter & Dart (Cross-platform iOS/Android/Web)
- State Management: Provider
- Backend Services: Firebase (Auth, Firestore)
- AI Core: Google Gemini API (Natural Language Processing & Trend Analysis)
- UI & Experience: Google Fonts, Flutter Animate, Glassmorphism Design
- Integration: Youtube Player & Syncfusion PDF Viewer

## Environment Variables (.env)

To run this project, you will need to add the following environment variables to your `.env` file in the root directory:

| Key | Description |
| :--- | :--- |
| `GEMINI_API_KEY` | Your Google AI Studio API Key |
| `FIREBASE_API_KEY_WEB` | API Key for Firebase Web/Windows |
| `FIREBASE_APP_ID_WEB_WINDOWS` | App ID for Firebase Web/Windows |
| `FIREBASE_API_KEY_ANDROID` | API Key for Firebase Android |
| `FIREBASE_APP_ID_ANDROID` | App ID for Firebase Android |
| `FIREBASE_API_KEY_IOS` | API Key for Firebase iOS/MacOS |
| `FIREBASE_APP_ID_IOS` | App ID for Firebase iOS/MacOS |
| `FIREBASE_PROJECT_ID` | Your Firebase Project ID |
| `FIREBASE_MESSAGING_SENDER_ID` | Firebase Cloud Messaging Sender ID |
| `FIREBASE_AUTH_DOMAIN` | Firebase Authentication Domain |
| `FIREBASE_STORAGE_BUCKET` | Firebase Storage Bucket URL |

## Installation & Setup

### Prerequisites
- Flutter SDK (>=3.0.0)
- Firebase account
- Google AI Studio (Gemini) API Key

### Setup Instructions
1. Clone the repository:
   ```bash
   git clone https://github.com/ByteNinjaSmit/mental_health_ai.git
   cd mental_health_ai
   ```
2. Install Dependencies:
   ```bash
   flutter clean
   flutter pub get
   ```
3. Configure Environment:
   Create a `.env` file in the root directory and add your keys as defined in the Environment Variables section.
4. Firebase Configuration:
   Place your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) in the respective app directories.
5. Run the App:
   ```bash
   flutter run
   ```

## License
This project is licensed under the MIT License.

*Disclaimer: This app serves as a digital companion and early intervention tool. It is not a permanent replacement for certified human psychiatric evaluation or severe emergency intervention.*
