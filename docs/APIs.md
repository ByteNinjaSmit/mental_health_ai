# Application Programming Interfaces (APIs)

This document outlines the external APIs and backend SDKs utilized within the Mental Health Companion application to provide its core functionalities.

## Google Gemini API
The primary generative artificial intelligence service powering the chatbot.

- **SDK Used**: Custom HTTP integration or community Flutter wrapper for Gemini.
- **Model**: `gemini-2.5-flash`
- **Authentication**: Bearer Token / API Key (`GEMINI_API_KEY` defined in `.env`).
- **Primary Function**: To parse user text inputs, apply Cognitive Behavioral Therapy (CBT) contextual constraints, and generate empathetic, constructive responses.
- **Data Payload**: JSON array containing conversation history (role: 'user' vs 'model') to maintain conversational context.

## Firebase Authentication API
The identity management service utilized for secure user onboarding and session management.

- **SDK Used**: `firebase_auth`
- **Authentication Methods**: Email and Password authentication.
- **Primary Functions**:
  - `createUserWithEmailAndPassword`: Registers new users and generates a unique `uid`.
  - `signInWithEmailAndPassword`: Authenticates returning users and dispenses a session token.
  - `signOut`: Terminates the active session securely.

## Cloud Firestore API
The real-time database API used for all persistent data storage and synchronization.

- **SDK Used**: `cloud_firestore`
- **Primary Functions**:
  - `collection().doc().set()`: Used to create new user profiles or book appointments.
  - `collection().doc().update()`: Used to modify existing records, such as canceling an appointment or adding a like to a forum post.
  - `collection().snapshots()`: Establishes a real-time listener (WebSocket) to stream updates directly to the Flutter UI, specifically utilized in the Community Forums and Appointments dashboard.
