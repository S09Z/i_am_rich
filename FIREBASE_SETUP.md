# Firebase App Distribution Setup Guide

## Setup Complete! ✅

Your Flutter app is now configured with Firebase App Distribution, Analytics, and Crashlytics.

---

## What Was Configured

### 1. Android Configuration
- ✅ `google-services.json` placed in `android/app/`
- ✅ Google Services plugin added to `settings.gradle.kts`
- ✅ Firebase SDK added to `app/build.gradle.kts`
- ✅ Firebase App Distribution plugin configured
- ✅ Firebase Crashlytics plugin configured

### 2. Flutter Configuration
- ✅ Firebase packages added to `pubspec.yaml`:
  - `firebase_core` - Core Firebase functionality
  - `firebase_analytics` - Analytics tracking
  - `firebase_crashlytics` - Crash reporting
- ✅ Firebase initialized in `main.dart`
- ✅ Crashlytics error handling configured

---

## How to Distribute Your App

### Method 1: Using Firebase Console (Easiest)

1. **Build your APK**:
   ```bash
   flutter build apk --release
   ```

2. **Go to Firebase Console**:
   - Visit https://console.firebase.google.com
   - Select your project
   - Click "App Distribution" in the left menu

3. **Upload your APK**:
   - Click "Get started" or "Distribute"
   - Drag and drop: `build/app/outputs/flutter-apk/app-release.apk`
   - Add release notes (what's new in this version)
   - Add testers (email addresses)
   - Click "Distribute"

4. **Testers receive email**:
   - They click the link and download your app
   - Can provide feedback directly in Firebase

---

### Method 2: Using Gradle Task (Advanced)

1. **Authenticate with Firebase**:
   ```bash
   # Install Firebase CLI
   npm install -g firebase-tools

   # Login to Firebase
   firebase login
   ```

2. **Build and distribute in one command**:
   ```bash
   cd android
   ./gradlew assembleRelease appDistributionUploadRelease
   ```

3. **Configure distribution** (optional):

   Edit `android/app/build.gradle.kts` and add:
   ```kotlin
   firebaseAppDistribution {
       releaseNotes = "Bug fixes and improvements"
       groups = "qa-team"  // Tester group name from Firebase Console
   }
   ```

---

### Method 3: Using Firebase CLI

```bash
# Build APK
flutter build apk --release

# Upload to Firebase App Distribution
firebase appdistribution:distribute \
  build/app/outputs/flutter-apk/app-release.apk \
  --app YOUR_FIREBASE_APP_ID \
  --groups "testers" \
  --release-notes "Version 1.0.1 - Bug fixes"
```

---

## Managing Testers

### Adding Testers in Firebase Console:

1. Go to **App Distribution** > **Testers & Groups**
2. Click **Add testers**
3. Enter email addresses (one per line)
4. Optionally create groups (e.g., "qa-team", "beta-testers")

### Tester Experience:

1. Tester receives email invitation
2. Clicks link to download app
3. On Android:
   - May need to enable "Install from unknown sources"
   - Install the APK
4. App auto-updates when you release new versions

---

## Testing Your Setup

### 1. Test Firebase Connection:
```bash
flutter run
```

Check console for:
```
✓ Firebase initialized successfully
```

### 2. Test Crashlytics:

Add a test crash button to your app:
```dart
// Temporary test button
ElevatedButton(
  onPressed: () {
    FirebaseCrashlytics.instance.crash(); // Force crash
  },
  child: Text('Test Crash'),
)
```

### 3. Test Analytics:

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

// Log custom event
FirebaseAnalytics.instance.logEvent(
  name: 'diamond_viewed',
  parameters: {'screen': 'home'},
);
```

---

## Automated Distribution with GitHub Actions

Add to `.github/workflows/flutter_ci.yml`:

```yaml
  distribute-android:
    name: Distribute Android APK
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    needs: build-android

    steps:
      - name: Download APK artifact
        uses: actions/download-artifact@v4
        with:
          name: android-apk

      - name: Upload to Firebase App Distribution
        uses: wzieba/Firebase-Distribution-Github-Action@v1
        with:
          appId: ${{ secrets.FIREBASE_APP_ID }}
          serviceCredentialsFileContent: ${{ secrets.FIREBASE_SERVICE_ACCOUNT }}
          groups: testers
          file: app-release.apk
          releaseNotes: |
            Automated build from commit ${{ github.sha }}
```

**Setup Required**:
1. Get Firebase App ID from Firebase Console > Project Settings
2. Create service account:
   - Firebase Console > Project Settings > Service Accounts
   - Generate new private key
3. Add secrets to GitHub:
   - `FIREBASE_APP_ID`
   - `FIREBASE_SERVICE_ACCOUNT` (entire JSON content)

---

## Common Issues & Solutions

### Issue: "App not installed" on tester device
**Solution**:
- Ensure tester has enabled "Install from unknown sources"
- Check that APK is signed properly

### Issue: Firebase initialization fails
**Solution**:
```bash
# Make sure google-services.json is in the right place
ls android/app/google-services.json

# Rebuild the app
flutter clean
flutter pub get
flutter build apk
```

### Issue: Crashlytics not receiving crashes
**Solution**:
- Crashes appear after app restart (not immediately)
- Check Firebase Console > Crashlytics (can take 5-10 minutes)
- Ensure `FlutterError.onError` is set in main.dart

### Issue: Gradle build fails with Firebase
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter build apk
```

---

## Build Commands Reference

```bash
# Debug build (for development)
flutter build apk

# Release build (for distribution)
flutter build apk --release

# Build with split per ABI (smaller files)
flutter build apk --release --split-per-abi

# Build app bundle (for Play Store)
flutter build appbundle --release

# Check build size
ls -lh build/app/outputs/flutter-apk/

# Clean build artifacts
flutter clean
```

---

## Firebase Console URLs

- **Project Overview**: https://console.firebase.google.com/project/YOUR_PROJECT_ID
- **App Distribution**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/appdistribution
- **Crashlytics**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/crashlytics
- **Analytics**: https://console.firebase.google.com/project/YOUR_PROJECT_ID/analytics

---

## Next Steps

1. **Build and distribute your first test**:
   ```bash
   flutter build apk --release
   ```
   Then upload via Firebase Console

2. **Add testers** in Firebase Console

3. **Set up automated distribution** with GitHub Actions

4. **Monitor crashes and analytics** in Firebase Console

5. **Iterate and improve** based on tester feedback

---

## Additional Resources

- [Firebase App Distribution Docs](https://firebase.google.com/docs/app-distribution)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase CLI Reference](https://firebase.google.com/docs/cli)
- [Crashlytics Flutter Setup](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)

---

## Quick Distribution Workflow

```bash
# 1. Make changes to your app
# 2. Build release APK
flutter build apk --release

# 3. Go to Firebase Console
# https://console.firebase.google.com

# 4. App Distribution > Release
# Upload: build/app/outputs/flutter-apk/app-release.apk

# 5. Add release notes and testers

# 6. Click "Distribute"

# Done! Testers receive email notification
```

Your app is now ready for distribution! 🚀
