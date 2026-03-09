# Modern To-Do App (Flutter)

A production-ready Todo List application built using **Flutter**, **Firebase Auth**, and **Firebase Realtime Database (via REST API)**. It features a modern futuristic UI with Glassmorphism, Material 3, and Dark Mode.

## Features
- **Clean Architecture:** Domain, Data, and Presentation layers separated.
- **State Management:** BLoC pattern for all features.
- **REST API Integration:** Using Dio to talk directly to Firebase Realtime Database.
- **Dependency Injection:** Powered by GetIt.
- **Modern UI:** Glassmorphism, beautiful gradients, Material 3 layouts, and Dark Mode.
- **Firebase Auth:** Login, Sign Up, and session management.

## Setup Instructions

### 1. Enable Developer Mode (Windows Users)
If you're compiling on Windows, you must enable **Developer Mode** to allow for symlink creation, which is required by some plugins like `firebase_core`.
Go to: `Settings > Privacy & security > For developers` and toggle on "Developer Mode".

### 2. Configure Firebase
1. Create a [Firebase Project](https://console.firebase.google.com/).
2. Enable **Authentication** (Email/Password).
3. Enable **Realtime Database** and set up the Rules (allow read/write for authenticated users).
4. Connect the Flutter app to Firebase by installing FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure --project=YOUR_PROJECT_ID
   ```
5. Note: The current codebase uses a placeholder `firebase_options.dart`. Make sure to replace it via the above command!
6. Open `lib/core/network/api_client.dart` and update the `baseUrl` with your active Firebase Realtime Database URL.

### 3. Build & Run
Run the standard Flutter commands:
```bash
flutter pub get
flutter run
```

## Architecture Folder Structure
```text
lib/
 ├── core/              # Global errors, network client, themes, constants
 ├── features/
 │    ├── auth/         # Login, Sign Up, Authentication States
 │    └── tasks/        # Task listing, Adding/Editing, REST APIs
 ├── injection_container.dart # Service Locator configuration
 └── main.dart          # Entry point
```

## Developer Notes
All code follows SOLID principles and splits UI interactions from business logic using `UseCases` and `Repositories`. 
Offline caching mechanism structure exists via `SharedPreferences`.

Enjoy building!
