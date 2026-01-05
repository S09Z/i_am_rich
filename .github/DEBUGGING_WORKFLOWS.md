# Debugging GitHub Actions Workflows

This guide covers multiple approaches to debug and test your GitHub Actions workflows.

## Table of Contents
1. [Debug Mode in GitHub](#1-debug-mode-in-github)
2. [Local Testing with act](#2-local-testing-with-act)
3. [Local Test Script](#3-local-test-script-recommended-alternative)
4. [GitHub Actions Debug Logging](#4-github-actions-debug-logging)
5. [Common Issues & Solutions](#5-common-issues--solutions)
6. [Reading Workflow Logs](#6-reading-workflow-logs)

---

## 1. Debug Mode in GitHub

### Enable Debug Mode
The workflow has a built-in debug mode that you can enable:

**Via GitHub UI:**
1. Go to your repository on GitHub
2. Click **Actions** tab
3. Select **Flutter CI** workflow
4. Click **Run workflow** dropdown
5. Check **Enable debug mode with verbose output**
6. Click **Run workflow**

**What Debug Mode Does:**
- Prints environment information (OS, branch, commit)
- Runs `flutter doctor -v` for detailed Flutter setup info
- Lists installed packages with `flutter pub deps`
- Shows build outputs and directory contents
- Enables verbose mode for Flutter builds (`--verbose`)
- Continues on error (won't stop immediately on failure)
- Uploads Flutter logs as artifacts on failure

### View Debug Output
1. Click on the workflow run
2. Click on each job (Analyze & Test, Build Android, etc.)
3. Expand steps to see detailed logs
4. Debug steps are prefixed with "Debug -"

---

## 2. Local Testing with act

`act` allows you to run GitHub Actions locally using Docker.

⚠️ **Important for Apple Silicon (M1/M2/M3) users**: The main workflow has issues with act on ARM Macs. Use the **local test script** (Method 3) or the **act-compatible workflow** instead.

### Install act

**macOS:**
```bash
brew install act
```

**Linux:**
```bash
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash
```

**Windows (with Chocolatey):**
```bash
choco install act-cli
```

### Configuration for Apple Silicon

The `.actrc` file is pre-configured with:
```bash
--container-architecture linux/amd64  # Required for M-series Macs
-P ubuntu-latest=catthehacker/ubuntu:full-latest
--verbose
--network host
```

### Basic Usage

**Recommended: Use act-compatible workflow:**
```bash
act -j quick-test -W .github/workflows/local-test.yml
```

**Or try the main workflow (may fail on some systems):**
```bash
act -j analyze-and-test --container-architecture linux/amd64
```

**List available jobs:**
```bash
act -l
```

**Run with debug mode:**
```bash
act -v -j analyze-and-test
```

**Run with specific event:**
```bash
act push
act pull_request
act workflow_dispatch
```

### Known Issues with act

**Issue: "Set up Flutter" fails with exit code 1**
- **Cause**: `subosito/flutter-action@v2` doesn't work well in Docker on ARM Macs
- **Solution**: Use `.github/scripts/local-test.sh` instead (Method 3 below)
- **Alternative**: Use the act-compatible workflow: `act -W .github/workflows/local-test.yml`

**Issue: Slow first run**
- **Cause**: Docker needs to download ~2GB image
- **Solution**: Wait for first download, subsequent runs are cached
- **Alternative**: Use local test script (no Docker needed)

### Limitations of act
- Some GitHub-specific actions don't work in Docker
- Flutter setup action may fail on Apple Silicon
- macOS runners (`macos-latest`) won't work (Linux-based Docker only)
- Large images download needed for full compatibility
- Some actions may behave differently locally

---

## 3. Local Test Script (Recommended Alternative)

**Best option for daily development and Apple Silicon Macs**

A shell script that mimics the workflow using your local Flutter installation.

### Usage:
```bash
.github/scripts/local-test.sh
```

### Advantages:
- ✅ Fast (no Docker overhead)
- ✅ Works on all platforms
- ✅ Uses your actual Flutter installation
- ✅ Easy to customize
- ✅ Colored output

### What it does:
1. Checks Flutter installation
2. Runs flutter doctor
3. Installs dependencies
4. Verifies code formatting
5. Analyzes code
6. Runs tests
7. Checks for outdated dependencies

See `LOCAL_TESTING.md` for complete guide.

---

## 4. GitHub Actions Debug Logging

### Enable Step Debug Logging
Add secrets to your repository to enable debug logging:

1. Go to **Settings** > **Secrets and variables** > **Actions**
2. Add these repository secrets:
   - `ACTIONS_STEP_DEBUG` = `true` (enables step debugging)
   - `ACTIONS_RUNNER_DEBUG` = `true` (enables runner diagnostic logging)

**What This Shows:**
- Detailed step execution information
- Variable evaluation and substitution
- Action input/output values
- File system operations

### View Debug Logs
After enabling, all workflow runs will show additional debug information in expanded log views.

---

## 5. Common Issues & Solutions

### Issue: "flutter: command not found"
**Cause:** Flutter SDK not properly set up

**Debug:**
```yaml
- name: Debug Flutter installation
  run: |
    which flutter
    echo $PATH
    flutter --version
```

**Solution:** Ensure `subosito/flutter-action@v2` is running before Flutter commands

---

### Issue: Build fails with "No such file or directory"
**Cause:** Missing files or wrong working directory

**Debug:**
```yaml
- name: Debug file structure
  run: |
    pwd
    ls -la
    find . -name "pubspec.yaml"
```

**Solution:** Check if `actions/checkout@v4` is running first

---

### Issue: "Permission denied" errors
**Cause:** File permissions or executable issues

**Debug:**
```yaml
- name: Debug permissions
  run: |
    ls -la
    whoami
    id
```

**Solution:** Add `chmod +x` if needed, or fix file permissions

---

### Issue: Tests pass locally but fail in CI
**Cause:** Environment differences (dependencies, Flutter version, etc.)

**Debug:**
```yaml
- name: Debug environment differences
  run: |
    flutter doctor -v
    flutter pub deps
    cat pubspec.lock
```

**Solution:**
- Match Flutter versions between local and CI
- Check for platform-specific dependencies
- Verify `.env` file is properly loaded

---

### Issue: Cache issues causing stale builds
**Cause:** Cached dependencies or build artifacts

**Debug:**
Check cache keys in workflow logs

**Solution:**
```yaml
- name: Clear Flutter cache
  run: |
    flutter clean
    flutter pub cache repair
```

Or manually clear caches in GitHub:
1. Go to **Actions** > **Caches**
2. Delete relevant caches

---

### Issue: Artifacts not uploading
**Cause:** Wrong path or file doesn't exist

**Debug:**
```yaml
- name: Debug artifact path
  run: |
    ls -lah build/app/outputs/flutter-apk/
    find build -name "*.apk"
```

**Solution:** Verify the exact path where Flutter outputs the build

---

## 6. Reading Workflow Logs

### Log Structure
```
Job: analyze-and-test
├── Step: Checkout code
├── Step: Set up Flutter
├── Step: Install dependencies
└── Step: Run tests
    ├── stdout: test output
    └── stderr: errors (if any)
```

### Understanding Log Icons
- ✅ Green checkmark: Step succeeded
- ❌ Red X: Step failed
- ⚠️ Yellow warning: Step succeeded with warnings
- 🔵 Blue circle: Step in progress
- ⏭️ Gray: Step skipped (conditional not met)

### Expanding Logs
1. Click on the failed step
2. Look for the first error (often at the top of red text)
3. Check the exit code (shown at bottom of step)

### Downloading Logs
1. Go to workflow run summary
2. Click the ⋮ menu (top right)
3. Select **Download log archive**
4. Extract and search with text editor

### Searching Logs
Use browser search (Ctrl+F / Cmd+F) for:
- `Error:`
- `Exception:`
- `Failed`
- `exit code`

---

## Quick Debugging Checklist

When a workflow fails:

- [ ] Read the error message in the failed step
- [ ] Check if files are checked out (`ls -la`)
- [ ] Verify Flutter is installed (`flutter --version`)
- [ ] Check dependencies are installed (`flutter pub get`)
- [ ] Look for environment differences (Flutter version, OS)
- [ ] Try running the same command locally
- [ ] Enable debug mode and re-run
- [ ] Check uploaded artifacts for additional clues
- [ ] Review previous successful runs for changes

---

## Advanced Debugging Techniques

### SSH Debug Session (using tmate)
Add this step to SSH into the runner:

```yaml
- name: Setup tmate session
  if: failure()
  uses: mxschmitt/action-tmate@v3
  timeout-minutes: 15
```

**Warning:** Only use for private repos, as this exposes your runner

### Matrix Testing
Test multiple configurations:

```yaml
jobs:
  test:
    strategy:
      matrix:
        flutter-version: ['3.10.3', '3.13.0', 'stable']
        os: [ubuntu-latest, macos-latest]
    runs-on: ${{ matrix.os }}
    steps:
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: ${{ matrix.flutter-version }}
```

### Custom Debug Script
Create `.github/scripts/debug.sh`:

```bash
#!/bin/bash
set -e

echo "=== System Info ==="
uname -a
echo ""

echo "=== Flutter Info ==="
flutter doctor -v
echo ""

echo "=== Project Structure ==="
find . -name "*.dart" | head -20
echo ""

echo "=== Dependencies ==="
flutter pub deps --style=compact
```

Then use in workflow:
```yaml
- name: Run debug script
  run: bash .github/scripts/debug.sh
```

---

## Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [act GitHub Repository](https://github.com/nektos/act)
- [Flutter CI/CD Best Practices](https://docs.flutter.dev/deployment/cd)
- [Debugging Flutter Tests](https://docs.flutter.dev/testing/debugging)

---

## Need Help?

1. Check workflow logs for specific error messages
2. Search GitHub Issues for the actions you're using
3. Try running commands locally to isolate the issue
4. Enable debug mode for verbose output
5. Use `act` for rapid local iteration
