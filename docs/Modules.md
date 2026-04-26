# System Modules

The application is logically divided into five core modules, each serving a distinct purpose in the mental health support ecosystem.

## 1. AI Chatbot Therapist
The primary interaction interface. Powered by Google Gemini 2.5 Flash, it acts as a first responder for emotional distress. It utilizes Cognitive Behavioral Therapy (CBT) principles to help users reframe negative thoughts. It operates continuously and includes hard-coded safety triggers for crisis detection.

## 2. Mental Health Assessments
A clinical evaluation module featuring standard psychological tools such as the PHQ-9 (Depression) and GAD-7 (Anxiety) tests. It provides users with objective metrics regarding their mental state, tracks historical scores to plot trends over time, and visually presents this data using charts.

## 3. Medical Directory & Appointment Booking
A healthcare integration module that bridges the gap between digital companion and professional psychiatric help. It loads verified practitioner data, allows users to filter by specialization or location, and provides an interface for scheduling, modifying, or canceling appointments. All bookings are synced in real-time with Firestore.

## 4. Community Forums
A peer-to-peer support network designed to reduce isolation. Users can post anonymously in categorized topic boards (e.g., Anxiety, PTSD). The module supports threaded replies and reaction metrics, creating a safe, moderated space for shared experiences.

## 5. Crisis Helpline & Resource Hub
An emergency module designed for immediate, critical intervention. It features one-tap calling to national suicide prevention and domestic violence hotlines. Additionally, it serves as an educational repository, hosting curated PDFs and video therapy sessions integrated directly into the application.
