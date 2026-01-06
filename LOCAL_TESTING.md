# Local Testing Guide

This guide explains how to test your Flutter app locally before pushing to GitHub.

## Problem with act on Apple Silicon (M1/M2/M3)

The GitHub Actions tool `act` has issues on Apple Silicon Macs because:
- Flutter setup actions are designed for GitHub's runners
- Docker containers need specific architecture configuration
- Some actions don't work well in local Docker environments

## Solution: Multiple Testing Approaches

We provide **3 ways** to test locally:

---

## Method 1: Local Test Script (Recommended ⭐)

**Best for**: Quick local validation before pushing

This script runs the same checks as GitHub Actions but uses your local Flutter installation.

### Usage:
```bash
# Run from project root
.github/scripts/local-test.sh
```

### What it does:
- ✅ Checks Flutter installation
- ✅ Runs flutter doctor
- ✅ Installs dependencies
- ✅ Verifies code formatting
- ✅ Analyzes code (flutter analyze)
- ✅ Runs tests
- ✅ Checks for outdated dependencies

### Advantages:
- Fast (uses local Flutter, no Docker)
- Works on any platform (macOS, Linux, Windows)
- Easy to customize
- Colored output for easy reading

### Example Output:
```
=========================================
Local Flutter CI Test
=========================================

▶ Environment Information
---
Flutter version:
Flutter 3.10.3 • channel stable

▶ Verifying Code Formatting
---
✓ Code formatting is correct

▶ Analyzing Code
---
✓ Code analysis passed

▶ Running Tests
---
✓ All tests passed

=========================================
✓ All checks passed!
=========================================
```

---

## Method 2: act with Correct Configuration

**Best for**: Testing the actual workflow file

### Setup:

1. **Install act** (if not already installed):
   ```bash
   brew install act
   ```

2. **Use the .actrc configuration**:
   The `.actrc` file is already configured for Apple Silicon Macs with:
   - `--container-architecture linux/amd64` (fixes M1/M2/M3 issues)
   - Full Ubuntu image for better compatibility
   - Verbose output

3. **Run act**:
   ```bash
   # Test with the simpler local-test workflow
   act -j quick-test -W .github/workflows/local-test.yml

   # Or test the main workflow (may take longer)
   act -j analyze-and-test --container-architecture linux/amd64
   ```

### Known Limitations:
- ⚠️ First run downloads large Docker image (~2GB)
- ⚠️ Flutter setup action may still fail in Docker
- ⚠️ iOS builds cannot run (requires macOS, not Docker)
- ⚠️ Slower than local script method

### Troubleshooting act:

**Error: "Set up Flutter" fails**
```bash
# Use the act-compatible workflow instead:
act -W .github/workflows/local-test.yml

# Or use the local script (Method 1)
.github/scripts/local-test.sh
```

**Error: "Container architecture" warning**
```bash
# The .actrc file should handle this, but you can also specify manually:
act --container-architecture linux/amd64
```

**Error: Docker daemon not running**
```bash
# Start Docker Desktop first
open -a Docker
```

---

## Method 3: Manual Step-by-Step

**Best for**: Debugging specific issues

Run each command individually:

```bash
# 1. Check Flutter setup
flutter doctor -v

# 2. Clean previous builds
flutter clean

# 3. Get dependencies
flutter pub get

# 4. Check formatting
flutter format --set-exit-if-changed .

# 5. Analyze code
flutter analyze

# 6. Run tests
flutter test

# 7. (Optional) Build Android
flutter build apk --release

# 8. Check outdated packages
flutter pub outdated
```

---

## Comparison Table

| Method | Speed | Accuracy | Setup Required | Recommended For |
|--------|-------|----------|----------------|-----------------|
| Local Script | ⚡ Fast | ✅ High | None | Daily development |
| act (local-test.yml) | 🐌 Slow | ✅ High | Docker | Testing workflow changes |
| act (main workflow) | 🐌 Very slow | ⚠️ May fail | Docker | Advanced users |
| Manual commands | ⚡ Fast | ✅ High | None | Debugging specific issues |

---

## Recommended Workflow

```bash
# During development:
.github/scripts/local-test.sh

# Before creating PR:
.github/scripts/local-test.sh
flutter build apk --release  # Test full build

# If you modified the workflow file:
act -W .github/workflows/local-test.yml

# Push to GitHub and verify:
git push origin development
# Check GitHub Actions tab for real CI results
```

---

## Quick Commands Cheat Sheet

```bash
# Run local test script (fastest)
.github/scripts/local-test.sh

# Test with act (simple workflow)
act -j quick-test -W .github/workflows/local-test.yml

# Test with act (main workflow, may fail on M-series)
act -j analyze-and-test --container-architecture linux/amd64

# Just run the tests
flutter test

# Just analyze code
flutter analyze

# Format all files
flutter format .

# Build Android APK
flutter build apk --release

# Build iOS (macOS only)
flutter build ios --release --no-codesign

# Clean and rebuild everything
flutter clean && flutter pub get && flutter test
```

---

## Fixing Common Issues

### Issue: "Flutter command not found"
```bash
# Check Flutter is in PATH
which flutter

# If not found, add to PATH (example for macOS):
export PATH="$PATH:$HOME/flutter/bin"

# Or use FVM if installed
fvm flutter --version
```

### Issue: Local tests pass, GitHub Actions fail
- Check Flutter version matches (see workflow file)
- Ensure `.env` file exists (copy from `.env.example`)
- Check for platform-specific code
- Enable debug mode on GitHub Actions

### Issue: act takes forever to download
- First run downloads ~2GB Docker image
- Subsequent runs use cached image
- Consider using local script method instead

### Issue: "Permission denied" when running script
```bash
chmod +x .github/scripts/local-test.sh
```

---

## For Beginners

**Simple 2-step local testing:**

1. Run the test script:
   ```bash
   .github/scripts/local-test.sh
   ```

2. If it passes, push to GitHub:
   ```bash
   git add .
   git commit -m "Your changes"
   git push
   ```

That's it! GitHub Actions will run automatically on the server.

---

## For Advanced Users

### Running specific act jobs:
```bash
# List all jobs
act -l

# Run specific job
act -j analyze-and-test
act -j build-android

# Run with secrets
act -j analyze-and-test --secret-file .secrets

# Run with event simulation
act pull_request
act push -b main
```

### Debugging act issues:
```bash
# Very verbose output
act -v -j quick-test -W .github/workflows/local-test.yml

# Dry run (shows what would happen)
act --dryrun

# Use specific Docker platform
act --container-architecture linux/arm64  # For ARM native
act --container-architecture linux/amd64  # For Intel/Rosetta

# Reuse containers (faster subsequent runs)
act --reuse
```

---

## Need Help?

1. Use the local script first (easiest and most reliable)
2. Check `.github/DEBUGGING_WORKFLOWS.md` for detailed GitHub Actions debugging
3. If act fails, don't worry - the local script is often better for development
4. GitHub Actions on the server is the ultimate source of truth
