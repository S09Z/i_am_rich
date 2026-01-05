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
- **Environment Management**: flutter_dotenv for environment variables
- **CI/CD**: GitHub Actions for automated testing and builds
- **Version Control**: Git

## Project Structure
```
i_am_rich/
├── .github/
│   └── workflows/
│       └── flutter_ci.yml # GitHub Actions CI/CD workflow
├── lib/
│   └── main.dart          # Main application entry point
├── images/
│   └── diamond.png        # Diamond asset image
├── ios/                   # iOS-specific configuration
├── android/               # Android-specific configuration
├── .env.example           # Environment variables template
├── .env                   # Environment variables (gitignored)
├── pubspec.yaml           # Project dependencies and configuration
├── claude.md              # AI agent context file
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
- Dependencies: sentry_flutter, flutter_dotenv, cupertino_icons
- Asset configuration (images/ directory and .env file)
- Sentry upload configuration

### .env / .env.example
Environment configuration:
- **DSN**: Sentry Data Source Name
- **Sample Rates**: Traces, session replay, and error sampling rates
- `.env.example` is committed (template), `.env` is gitignored (actual secrets)

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
- **DSN**: Configured via `.env` file (loaded with flutter_dotenv)
- **Traces Sample Rate**: 100% (configurable in .env)
- **Session Replay**: 10% sample rate, 100% on errors (configurable in .env)
- **PII**: Enabled (sends user IP and request headers)
- **Setup**: Copy `.env.example` to `.env` and add your Sentry DSN

## Development Notes
- Using FVM (Flutter Version Manager) - see .fvmrc
- Debug banner is disabled (debugShowCheckedModeBanner: false)
- Original counter app code preserved in comments for reference
- Asset images stored in /images directory
- Environment variables managed with flutter_dotenv
- Sensitive credentials stored in .env (gitignored)

## CI/CD Pipeline
The project uses GitHub Actions for continuous integration:

### Workflow Triggers
- Push to `main` or `development` branches
- Pull requests to `main` or `development` branches
- Manual workflow dispatch

### Pipeline Jobs

**1. Analyze & Test** (runs on Ubuntu)
- Code formatting verification
- Static code analysis (flutter analyze)
- Unit test execution
- Dependency outdated check

**2. Build Android** (runs on Ubuntu)
- Builds release APK
- Uploads artifact (7-day retention)
- Runs only after analyze-and-test passes

**3. Build iOS** (runs on macOS)
- Builds release iOS app (no codesigning)
- Creates IPA archive
- Uploads artifact (7-day retention)
- Runs only after analyze-and-test passes

### Workflow Features
- Flutter SDK caching for faster builds
- Parallel Android and iOS builds
- Artifact retention for testing
- Fail-fast on code quality issues
- Built-in debug mode with verbose logging
- Conditional debug steps (only run when debug enabled)
- Automatic log artifact upload on failure

### Debugging Workflows
See `.github/DEBUGGING_WORKFLOWS.md` for comprehensive debugging guide.

**Quick Debug Methods:**

1. **Enable Debug Mode (GitHub UI)**
   - Actions tab → Flutter CI → Run workflow
   - Check "Enable debug mode" checkbox
   - Provides verbose output, flutter doctor, and detailed logs

2. **Test Locally with act**
   ```bash
   # Install act (macOS)
   brew install act

   # Run specific job
   act -j analyze-and-test
   ```

3. **Enable GitHub Debug Logging**
   - Add repository secret: `ACTIONS_STEP_DEBUG=true`
   - Shows detailed step execution info

4. **Common Debug Commands**
   ```bash
   # View workflow status
   gh workflow view "Flutter CI"

   # View recent runs
   gh run list --workflow="Flutter CI"

   # View logs for specific run
   gh run view <run-id> --log
   ```

## Next Learning Steps
Potential enhancements for continued learning:
1. Add multiple screens with navigation
2. Implement state management
3. Add user interactions (buttons, gestures)
4. Create custom widgets
5. Implement theming and dark mode
6. Add animations
7. Work with forms and input validation
