# System Architecture

The AI-Powered Mental Health Companion is architected as a modular, cloud-connected mobile application. It implements a client-server model heavily utilizing Platform-as-a-Service (PaaS) solutions to ensure scalability, real-time data synchronization, and secure AI integration.

## High-Level Components

### 1. Presentation Layer (Client)
Developed using the Flutter framework, ensuring a unified codebase across iOS, Android, and Web platforms.
- **State Management**: The application utilizes the `Provider` pattern for efficient, reactive state updates across UI components without unnecessary widget rebuilds.
- **UI Framework**: Built with custom widgets, integrating `flutter_animate` for transitions and maintaining a cohesive design language through a central theme configuration.

### 2. Business Logic Layer
Intermediary services bridging the frontend views and the backend data/AI layers.
- **Authentication Service**: Manages secure login, registration, and session persistence via Firebase Authentication.
- **Data Service**: Handles CRUD operations for Firestore, transforming raw document snapshots into typed Dart models.
- **AI Service**: Encapsulates the HTTP communication with the Google Gemini API, structuring prompts specifically for Cognitive Behavioral Therapy (CBT) paradigms.

### 3. Backend & Data Layer
Powered exclusively by Google Cloud and Firebase infrastructures.
- **Firebase Authentication**: Provides secure, token-based user verification supporting Email/Password and third-party OAuth providers.
- **Cloud Firestore**: A NoSQL, real-time database ensuring instantaneous synchronization of appointments, user profiles, and forum activities across all connected clients.
- **Firebase Storage** (Optional): Reserved for storing rich media, such as user avatars or uploaded diagnostic documents.

### 4. Artificial Intelligence Integration
- **Google Gemini API**: Serves as the cognitive engine for the chatbot interface. The backend logic sends sanitized user inputs alongside engineered system prompts to receive empathetic, context-aware responses and crisis detection flags.

## Architectural Flow

1. **User Interaction**: The user interacts with the Flutter UI.
2. **State Update**: The `Provider` intercepts the action and updates the local state.
3. **Service Invocation**: For persistent operations, the relevant service class is called.
4. **Cloud Communication**: The service authenticates the request and communicates with Firebase or the Gemini API over secure channels (HTTPS/WSS).
5. **Data Resolution**: The cloud service responds, the local state is updated, and the Flutter UI re-renders to reflect the new application state.
