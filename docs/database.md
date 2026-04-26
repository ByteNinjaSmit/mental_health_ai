# Database Schema

The application utilizes Firebase Firestore, a NoSQL document database, to manage user data, medical appointments, and community interactions securely. The following details the collections, their fields, and respective data types.

## Collection: users

Stores registered user profiles, encompassing both standard patients and medical professionals.

| Field | Type | Description |
| :--- | :--- | :--- |
| `uid` | String | Unique Firebase User ID, automatically generated upon authentication. |
| `name` | String | User's full display name. |
| `email` | String | User's registered email address. |
| `age` | String | User's age or age group for demographic tracking. |
| `role` | String | Determines system access privileges. Permitted values: 'user' or 'doctor'. |

## Collection: appointments

Manages scheduled sessions between users and verified psychiatrists.

| Field | Type | Description |
| :--- | :--- | :--- |
| `userId` | String | Foreign key reference to the User document (`uid`). |
| `doctorName` | String | Name of the selected psychiatrist or clinic. |
| `specialization` | String | Medical area of expertise of the selected professional. |
| `date` | String | Confirmed booking date, formatted as YYYY-MM-DD. |
| `timeSlot` | String | Selected time window for the appointment. |
| `status` | String | Current state of the appointment. Permitted values: 'booked', 'completed', 'cancelled'. |
| `createdAt` | Timestamp | Server-generated timestamp denoting when the booking was finalized. |

## Collection: topics

Facilitates the organization of community forum discussions based on specific mental health subjects.

| Field | Type | Description |
| :--- | :--- | :--- |
| `categoryId` | String | Identifier mapping to predefined categories (e.g., Anxiety, Depression, PTSD). |
| `title` | String | Headline or primary subject of the discussion thread. |
| `description` | String | Initial context or body text initiating the topic. |
| `user` | Reference | Firestore Document Reference pointing to the creator in the `users` collection. |
| `createdAt` | Timestamp | System timestamp recording topic generation. |

## Collection: posts

Records individual contributions, replies, or independent threads within the community forum.

| Field | Type | Description |
| :--- | :--- | :--- |
| `topicId` | String | Foreign key reference linking the post to a specific topic document. |
| `userId` | String | Creator's unique identification string. |
| `text` | String | Content of the forum post or reply. |
| `likes` | Number | Integer representing total positive reactions from the community. |
| `timestamp` | Timestamp | Immutable record of creation or publication time. |
