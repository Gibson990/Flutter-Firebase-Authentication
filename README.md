# Flutter Firebase Authentication with GoRouter

A Flutter application demonstrating Firebase Authentication integration with `GoRouter` for seamless navigation and user state management. The app includes features like email/password authentication, profile management, and email verification, all within a modular and scalable architecture.

## Features

- **Firebase Authentication**: Integrated with email/password sign-in, email verification, and profile management using `firebase_ui_auth`.
- **GoRouter Navigation**: Dynamic routing with nested routes for authentication and profile management.
- **State Management**: Centralized application state handling using `Provider`.
- **Responsive Design**: Intuitive UI built with `Material Design` principles.

## Tech Stack

- **Flutter**: Framework for building cross-platform apps.
- **Firebase**: Backend services for authentication and app initialization.
- **GoRouter**: Declarative routing library for Flutter.
- **Provider**: State management library.

## Project Structure

```plaintext
lib/
├── authentication.dart   # Handles sign-in and sign-out logic
├── app_state.dart        # Manages authentication state
├── main.dart             # App entry point with routing setup
├── home_screen.dart      # Home screen UI
└── firebase_options.dart # Firebase configuration file
