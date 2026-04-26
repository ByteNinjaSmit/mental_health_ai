# Development Methodology

This document outlines the software engineering methodologies, architectural patterns, and development approaches utilized throughout the project lifecycle.

## Agile Development Approach
The project was executed using an iterative Agile methodology, allowing for rapid prototyping of the AI features and continuous refinement based on testing and prompt performance.

## State Management Approach: Provider
The application relies on the `provider` package for state management. This approach was selected for its efficiency and scalability in Flutter applications.
- **Dependency Injection**: Services (like `AuthService` and `DatabaseService`) are injected at the root level, making them accessible throughout the widget tree.
- **Reactive UI**: By utilizing `ChangeNotifier`, the UI automatically rebuilds only when specific state variables change, ensuring smooth performance, particularly during real-time data syncing and AI response generation.

## Key Methodology Functions

### Real-Time Data Streaming
Rather than relying on manual fetch operations, the application utilizes Firestore's `snapshots()` method. This creates a persistent WebSocket connection, meaning any changes to the database (e.g., a new forum post or an updated appointment status) are immediately reflected in the user's interface without requiring a pull-to-refresh action.

### Asynchronous Programming
Given the heavy reliance on network requests (Firebase, Gemini API), the application heavily utilizes Dart's `Future` and `async/await` paradigms to prevent blocking the main UI thread, ensuring the app remains responsive during data loading or AI processing phases.

### Modular Widget Architecture
The UI is strictly broken down into modular, reusable widgets. For example, the `DoctorCard` widget is utilized in both the main directory and the search results, ensuring UI consistency and reducing code duplication.
