# Radio-Hub-TN

A Flutter application that serves as a hub for Tunisian radio stations, allowing users to listen to live audio/video streams. The project is built with Flutter and utilizes Firebase for backend services.

## Features

*   **User Authentication:** Secure sign-up, sign-in, and password reset functionality using Firebase Authentication.
*   **Live Radio Streaming:** Listen to various Tunisian radio stations in real-time.
*   **Cloud Database:** User data and radio station information are stored and managed with Cloud Firestore.
*   **State Management:** Efficiently manages application state using the Provider package.
*   **Embedded Video & Web:** Capable of displaying YouTube videos and web content directly within the app.

## Core Technologies & Dependencies

*   **UI Framework:** [Flutter](https://flutter.dev/)
*   **Backend & Authentication:** [Firebase](https://firebase.google.com/)
    *   `firebase_core`: For initializing the Firebase app.
    *   `firebase_auth`: For handling user authentication.
    *   `cloud_firestore`: For storing and retrieving data from Firestore.
*   **Audio Playback:**
    *   `just_audio`: A feature-rich audio player for Dart.
*   **State Management:**
    *   `provider`: A wrapper around InheritedWidget to make it easier to use and more reusable.
*   **Web & Video Content:**
    *   `youtube_player_flutter`: For embedding and playing YouTube videos.
    *   `flutter_inappwebview`: To render web pages within the application.

## Project Structure

The project follows a standard Flutter application structure, with the core logic organized as follows:

```
lib/
├── main.dart           # Application entry point
├── models/             # Data models (e.g., User)
├── screens/            # UI widgets for different app screens
│   ├── auth/           # Authentication-related screens (Sign In, Register)
│   ├── radio.dart      # Main screen for radio playback
│   └── wrapper.dart    # Handles routing based on auth state
├── services/           # Business logic (e.g., Authentication service)
└── shared/             # Shared widgets and constants
```

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

*   Flutter SDK: [Installation Guide](https://flutter.dev/docs/get-started/install)
*   A code editor like VS Code or Android Studio.
*   A configured Firebase project. You will need to add your own `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) for the Firebase integration to work.

### Installation & Running

1.  **Clone the repository:**
    ```sh
    git clone <your-repository-url>
    ```
2.  **Navigate to the project directory:**
    ```sh
    cd Radio-Hub-TN
    ```
3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```
4.  **Run the application:**
    ```sh
    flutter run
    ```