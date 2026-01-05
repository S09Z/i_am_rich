#!/bin/bash
# Complete workflow: Sync → Build → Deploy to Firebase App Distribution

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Firebase App Distribution Deployment${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Step 1: Clean and sync
echo -e "${GREEN}▶ Step 1: Cleaning and syncing project...${NC}"
flutter clean
flutter pub get
echo -e "${GREEN}✓ Project synced${NC}"
echo ""

# Step 2: Build release APK
echo -e "${GREEN}▶ Step 2: Building release APK...${NC}"
flutter build apk --release
echo -e "${GREEN}✓ APK built successfully${NC}"
echo ""

# Step 3: Check APK
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"
if [ -f "$APK_PATH" ]; then
    APK_SIZE=$(ls -lh "$APK_PATH" | awk '{print $5}')
    echo -e "${GREEN}✓ APK ready: $APK_PATH (${APK_SIZE})${NC}"
else
    echo -e "${RED}✗ APK not found!${NC}"
    exit 1
fi
echo ""

# Step 4: Upload to Firebase (if Firebase CLI is installed)
echo -e "${GREEN}▶ Step 3: Deploying to Firebase App Distribution...${NC}"

if command -v firebase &> /dev/null; then
    echo -e "${YELLOW}Firebase CLI detected. Ready to upload.${NC}"
    echo ""
    echo "Run one of these commands to upload:"
    echo ""
    echo -e "${BLUE}# Upload via Firebase Console (Easiest):${NC}"
    echo "  1. Go to: https://console.firebase.google.com"
    echo "  2. Select your project"
    echo "  3. Navigate to: App Distribution"
    echo "  4. Upload: $APK_PATH"
    echo ""
    echo -e "${BLUE}# OR upload via Firebase CLI:${NC}"
    echo "  firebase appdistribution:distribute \\"
    echo "    $APK_PATH \\"
    echo "    --app YOUR_FIREBASE_APP_ID \\"
    echo "    --groups \"testers\" \\"
    echo "    --release-notes \"Version 1.0 - Initial release\""
    echo ""
else
    echo -e "${YELLOW}⚠ Firebase CLI not installed${NC}"
    echo ""
    echo "Install Firebase CLI to upload automatically:"
    echo "  npm install -g firebase-tools"
    echo ""
    echo "Or upload manually:"
    echo "  1. Go to: https://console.firebase.google.com"
    echo "  2. Navigate to: App Distribution"
    echo "  3. Upload: $APK_PATH"
    echo ""
fi

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Build complete! Ready to deploy${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
