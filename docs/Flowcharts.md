# In-Depth System Architecture and Flowcharts

This document provides comprehensive, in-depth visualizations of the system architecture and the intricate logical flows that govern the AI-Powered Mental Health Companion.

---

## 1. Complete System Architecture

This diagram illustrates the separation of concerns and the data flow between the client application, internal services, and external cloud/AI infrastructure.

```mermaid
graph TD
    subgraph Frontend "Flutter Application (Client)"
        UI[UI Components / Screens]
        State[State Management - Provider]
        UI <-->|Listens / Triggers| State
    end

    subgraph Business Logic "Services Layer"
        AuthSvc[Authentication Service]
        DbSvc[Database Service]
        AISvc[Gemini AI Service]
        State <-->|Method Calls| AuthSvc
        State <-->|Data Streams| DbSvc
        State <-->|Prompt Generation| AISvc
    end

    subgraph Backend "Firebase Ecosystem"
        FirebaseAuth[Firebase Authentication]
        Firestore[Cloud Firestore]
        AuthSvc <-->|Auth Tokens| FirebaseAuth
        DbSvc <-->|Read / Write / Snapshots| Firestore
    end

    subgraph External APIs "AI & External Integration"
        Gemini[Google Gemini 2.5 Flash API]
        AISvc <-->|REST HTTP Request / Response| Gemini
    end
```

---

## 2. In-Depth User Authentication & Session Management

This sequence diagram details the precise interaction during the user login phase, including role-based data retrieval.

```mermaid
sequenceDiagram
    participant User
    participant FlutterUI as Flutter UI
    participant AuthProvider as Auth Provider
    participant Firebase as Firebase Auth
    participant Firestore as Cloud Firestore

    User->>FlutterUI: Enters Credentials (Email/Password)
    FlutterUI->>AuthProvider: Trigger signInWithEmailAndPassword()
    AuthProvider->>Firebase: Authenticate Request
    
    alt Invalid Credentials
        Firebase-->>AuthProvider: Error Response
        AuthProvider-->>FlutterUI: Update State (Error)
        FlutterUI-->>User: Display Error Message
    else Valid Credentials
        Firebase-->>AuthProvider: Success + User UID
        AuthProvider->>Firestore: Fetch User Profile Document (UID)
        Firestore-->>AuthProvider: Return User Data (Role, Name)
        AuthProvider-->>FlutterUI: Update State (Authenticated, Profile Data)
        FlutterUI-->>User: Navigate to Role-Based Dashboard
    end
```

---

## 3. In-Depth AI Therapist & CBT Processing Flow

This flowchart breaks down the internal logic executed during a single interaction with the AI chatbot, highlighting the safety override mechanisms.

```mermaid
graph TD
    A[User Submits Message] --> B[Validate Input Structure]
    B --> C{Check Safety Keywords}
    
    C -- High Risk Detected --> D[Trigger Crisis Protocol]
    D --> E[Show Emergency Helplines UI]
    
    C -- Safe Input --> F[Fetch Conversation History from State]
    F --> G[Construct CBT System Prompt]
    G --> H[Append User Input to Prompt]
    H --> I[Execute HTTP Call to Gemini API]
    I --> J{API Response Status}
    
    J -- Success --> K[Parse Response Text]
    K --> L[Update UI Chat State]
    L --> M[Log Interaction in Local State]
    
    J -- Failure / Timeout --> N[Display Fallback / Error Message]
```

---

## 4. In-Depth Appointment Lifecycle

This state diagram maps the lifecycle of a medical appointment request from the patient's initiation to the doctor's final decision.

```mermaid
stateDiagram-v2
    [*] --> ViewingDirectory: User Opens App
    ViewingDirectory --> DoctorProfile: Selects Doctor
    DoctorProfile --> SlotSelection: Clicks Book Appointment
    SlotSelection --> BookingConfirmation: Selects Valid Date & Time
    BookingConfirmation --> PendingApproval: Writes to Firestore
    PendingApproval --> DoctorDashboard: Real-time Snapshot Sync
    
    state DoctorDashboard {
        Reviewing[Doctor Reviews Request]
    }
    
    Reviewing --> AppointmentApproved: Doctor Clicks Approve
    Reviewing --> AppointmentDeclined: Doctor Clicks Decline
    
    AppointmentApproved --> UserDashboard: Status Updated to 'Booked'
    AppointmentDeclined --> UserDashboard: Status Updated to 'Cancelled'
    
    UserDashboard --> [*]: User Views Updated Status
```

---

## 5. In-Depth Community Forum Flow (Real-Time Sync)

This sequence diagram illustrates how Firestore's WebSocket streams automatically update the UI without requiring manual refreshes.

```mermaid
sequenceDiagram
    participant User
    participant ForumUI as Forum UI
    participant ForumProvider as Forum Provider
    participant Firestore as Cloud Firestore

    User->>ForumUI: Navigates to Category (e.g., Anxiety)
    ForumUI->>ForumProvider: Request Topic Stream
    ForumProvider->>Firestore: collection('topics').snapshots()
    Firestore-->>ForumProvider: Initial Data Snapshot Stream
    ForumProvider-->>ForumUI: Render Initial Topic List
    
    User->>ForumUI: Submits New Post
    ForumUI->>ForumProvider: trigger addPost()
    ForumProvider->>Firestore: collection('posts').add()
    Firestore-->>Firestore: Write Operation Successful
    
    %% Real-time update phase
    Firestore-->>ForumProvider: Push Snapshot Update (WebSocket)
    ForumProvider-->>ForumUI: Reactive Rebuild 
    ForumUI-->>User: Visual Confirmation (New Post Appears Instantly)
```

---

## 6. In-Depth Mental Health Assessment Scoring Flow

This flowchart maps the internal state transitions and conditional logic used during the execution of a PHQ-9 or GAD-7 clinical assessment.

```mermaid
graph TD
    A[Start PHQ-9 / GAD-7 Assessment] --> B[Initialize Score State = 0]
    B --> C[Present Question 1]
    C --> D[User Selects Option]
    D --> E[Map Option to Integer Value]
    E --> F[Add Value to Total Score]
    
    F --> G{Are there more questions?}
    G -- Yes --> H[Present Next Question]
    H --> D
    
    G -- No --> I[Calculate Final Score]
    I --> J{Evaluate Severity Thresholds}
    
    J -- Score: 0-4 --> K[Result: Minimal]
    J -- Score: 5-9 --> L[Result: Mild]
    J -- Score: 10-14 --> M[Result: Moderate]
    J -- Score: 15-27 --> N[Result: Severe]
    
    K --> O[Store Result in Firestore]
    L --> O
    M --> O
    N --> P[Recommend Booking Doctor Appointment]
    P --> O
    
    O --> Q[Update Trend Analysis Graph]
```
