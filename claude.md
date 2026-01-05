# I Am Rich - Flutter Learning Lab

## Project Overview
This is a simple Flutter learning project based on the classic "I Am Rich" app. It's designed as a beginner-friendly lab for learning Flutter fundamentals.

## Purpose
- Learn basic Flutter widget structure (MaterialApp, Scaffold, AppBar, Center, Image)
- Understand how to display assets (images) in Flutter
- Practice setting up a simple Flutter project
- Learn error monitoring with Sentry integration

## Tech Stack
- **Framework**: Flutter SDK 3.10.3+
- **Language**: Dart
- **Monitoring**: Sentry Flutter (v9.9.1) for error tracking and session replay
- **Version Control**: Git

## Project Structure
```
i_am_rich/
├── lib/
│   └── main.dart          # Main application entry point
├── images/
│   └── diamond.png        # Diamond asset image
├── ios/                   # iOS-specific configuration
├── android/               # Android-specific configuration
├── pubspec.yaml           # Project dependencies and configuration
└── README.md              # Project documentation
```

## Key Files

### lib/main.dart
The main application file containing:
- Sentry initialization with error tracking and session replay
- Simple MaterialApp with Scaffold structure
- AppBar with "I Am Rich" title
- Center widget displaying a diamond image from assets
- Commented-out default Flutter counter app code (for reference)

### pubspec.yaml
Defines:
- Project metadata (name: i_am_rich, version: 1.0.0+1)
- Dependencies: sentry_flutter, cupertino_icons
- Asset configuration (images/ directory)
- Sentry upload configuration

## Learning Objectives
This project teaches:
1. Basic Flutter app structure
2. Using StatelessWidget vs StatefulWidget
3. Working with Assets (images)
4. AppBar and Scaffold widgets
5. MaterialApp configuration
6. Third-party package integration (Sentry)
7. Removing debug banner

## Common Commands
```bash
# Run the app
flutter run

# Build for release
flutter build apk          # Android
flutter build ios          # iOS

# Clean build artifacts
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze
```

## Sentry Configuration
The app includes Sentry for error monitoring:
- **DSN**: Configured in main.dart
- **Traces Sample Rate**: 100% (adjust for production)
- **Session Replay**: 10% sample rate, 100% on errors
- **PII**: Enabled (sends user IP and request headers)

## Development Notes
- Using FVM (Flutter Version Manager) - see .fvmrc
- Debug banner is disabled (debugShowCheckedModeBanner: false)
- Original counter app code preserved in comments for reference
- Asset images stored in /images directory

## Next Learning Steps
Potential enhancements for continued learning:
1. Add multiple screens with navigation
2. Implement state management
3. Add user interactions (buttons, gestures)
4. Create custom widgets
5. Implement theming and dark mode
6. Add animations
7. Work with forms and input validation
