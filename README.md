# AI-Powered Mental Health Companion 🧠💙

A cutting-edge, cross-platform mental health application built with **Flutter**, designed to provide accessible, personalized, and real-time support. It leverages **Artificial Intelligence (Google Gemini)** and community-driven features to bridge the gap between individuals and effective mental health resources.

---

## 🌟 Project Overview
The rising prevalence of mental health issues like anxiety, depression, and stress is exacerbated by the limited availability of professional support, social stigmas, and financial constraints. This project serves as a 24/7 digital companion capable of detecting emotional states, conducting clinical-style diagnostic tests, and seamlessly connecting users to verified mental health professionals.

### **Key Objectives:**
- **Real-Time Support:** Deliver on-demand emotional backing through NLP and Generative AI.
- **Accessibility:** Ensure 24/7 localized support regardless of financial status.
- **Privacy & Security:** Safeguard sensitive clinical and personal data using robust encrypted backends.
- **Community Healing:** Foster peer-to-peer engagement via moderated forums.

---

## 🚀 Core Features

### 1. 🤖 AI Chatbot Therapist
- Driven by the **Gemini API** for high-quality Natural Language Processing.
- Employs conversational techniques inspired by CBT (Cognitive Behavioral Therapy) to help users navigate panic attacks or low moods.
- Automatically contextualizes advice and tracks emotional trends.

### 2. 📋 Mental Health Assessments
- Built-in, interactive surveys modeling standard psychological diagnostics (e.g., PHQ-9, GAD-7).
- Real-time progress bars and beautifully animated scoring modules.
- Generates post-test action plans based on Low, Moderate, or High-Risk assessments.

### 3. 📅 Medical Directory & Appointment Booking
- Integrated database of trusted Psychologists and Therapists.
- Interactive, native **Date and Time Pickers** allowing users to flawlessly secure exact consultation windows.
- Backend synchronization capturing the appointment data in real-time.

### 4. 🗣️ Community Forums (Anonymous Support)
- Users can post topics, share experiences, and engage in peer support.
- Fully functional commenting, liking, and post-modification interactions.
- Sophisticated UI featuring `flutter_animate` components, glassmorphism, and smooth scroll properties to mimic premium social applications.

### 5. 🏥 Crisis Helpline & Resources
- Integrated emergency contacts (Calling functionality).
- Expandable resource hubs routing users to PDF documentation and curated YouTube therapy sessions.

---

## 🛠️ Technology Stack

**Frontend:**
- **Flutter & Dart:** For cross-platform building on iOS and Android.
- **flutter_animate:** For buttery-smooth UI interactions and micro-animations.
- **google_fonts:** Providing native *Inter* typeface integrations.

**Backend Services:**
- **Firebase Authentication:** Handles secure user identity and access control.
- **Cloud Firestore:** Serves as the NoSQL document database powering the Forums, Appointments, and User Data.
- **Google Generative AI (Gemini):** The primary brain behind the interactive Therapist Chat.

---

## 🎨 UI/UX Design System
The app has recently undergone a massive UI/UX overhaul transitioning to a **Premium Light Theme**:
- Deep Teal and Cyan Color Schemes (`0xFF00B4D8`) to invoke calmness and trust.
- Elevated input forms using bounded borders and padded padding arrays.
- Structured bottom sheets over legacy alert dialogs.

---

## ⚙️ Installation & Usage

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>=3.0.0`)
- Valid `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) configured for your Firebase Project.

### Setup Instructions
1. **Clone the repository:**
   ```bash
   git clone https://github.com/ByteNinjaSmit/mental_health_ai.git
   cd mental_health_ai
   ```
2. **Install Dependencies:**
   ```bash
   flutter clean
   flutter pub get
   ```
3. **Configure API Keys:**
   - Place your Gemini API Key directly inside `lib/services/gemini_service.dart`.
4. **Run the App:**
   ```bash
   flutter run
   ```

---

---
*Disclaimer: This app serves as a digital companion and early intervention tool. It is not a permanent replacement for certified human psychiatric evaluation or severe emergency intervention.*
