# Test Plan for PR #122: Kotlin/Java Language Selection

> **PR Link:** https://github.com/ionic-team/create-capacitor-plugin/pull/122
> **Feature:** Android language selection (Kotlin/Java) for Capacitor plugin generation
> **Test Type:** Integration, Regression, End-to-End

---

## Table of Contents

- [Overview](#overview)
- [Test Strategy](#test-strategy)
- [Critical Files](#critical-files)
- [Test Scenarios](#test-scenarios)
- [Automated Test Script](#automated-test-script)
- [Prerequisites](#prerequisites)
- [Success Criteria](#success-criteria)
- [Execution Timeline](#execution-timeline)
- [Deliverables](#deliverables)
- [Risk Assessment](#risk-assessment)

---

## Overview

PR #122 introduces the ability to select between **Kotlin** and **Java** when creating Capacitor plugins for Android. When a language is selected, the plugin generator creates all source files, unit tests, and instrumented tests in the chosen language.

This feature requires thorough validation to ensure:

| Validation Area | Description |
|----------------|-------------|
| **Backward Compatibility** | Existing Java workflow continues to work (regression testing) |
| **New Kotlin Support** | Kotlin templates generate correctly and compile |
| **Build System Integration** | Gradle configuration adapts correctly based on language choice |
| **Language Consistency** | Source, unit tests, and instrumented tests all use the selected language |
| **Generated Tests** | Both unit and instrumented tests execute successfully in the correct language |
| **End-to-End Validation** | Generated plugins work in real Capacitor applications |

This test plan provides both comprehensive documentation and an automated test script to validate all aspects of this feature.

---

## Test Strategy

### Approach

| Strategy | Description |
|----------|-------------|
| **Integration Testing** | Generate complete plugins and verify compilation, testing, and integration |
| **Multiple Variants** | Test different naming conventions, package structures, and configurations |
| **Automated Validation** | Script-driven testing to ensure repeatability and thoroughness |
| **Manual Verification** | Human validation of template quality and code structure |

### Test Levels

1. **Generation Tests** - Verify correct file structure and template rendering
2. **Compilation Tests** - Ensure plugins compile successfully with Gradle
3. **Unit Test Execution** - Run generated unit tests (JVM-based)
4. **Integration Test Execution** - Run generated instrumented tests (Android device/emulator)
5. **Full Integration** - Test plugins in actual Capacitor applications

---

## Critical Files

Based on PR #122 changes, the following files require validation:

| File Path | Purpose |
|-----------|---------|
| `src/template.ts` | Template rendering and language-based folder deletion |
| `src/options.ts` | New `android-lang` option validation |
| `src/prompt.ts` | Interactive language selection prompt |
| `assets/plugin-template/android/build.gradle.mustache` | Conditional Kotlin dependencies |
| `assets/plugin-template/android/src/main/kotlin/` | Kotlin source templates |
| `assets/plugin-template/android/src/main/java/` | Java source templates (regression) |
| `assets/plugin-template/android/src/test/kotlin/` | Kotlin unit test templates |
| `assets/plugin-template/android/src/test/java/` | Java unit test templates (regression) |
| `assets/plugin-template/android/src/androidTest/kotlin/` | Kotlin instrumented test templates |
| `assets/plugin-template/android/src/androidTest/java/` | Java instrumented test templates (regression) |

---

## Test Scenarios

### Scenario 1: Basic Java Plugin (Regression Test)

**Purpose:** Ensure existing Java functionality still works correctly

#### Configuration

| Parameter | Value |
|-----------|-------|
| Name | `test-java-plugin` |
| Package ID | `com.example.testjava` |
| Class Name | `TestJava` |
| Android Language | `java` |

#### Validation Checklist

- ✅ Only Java source folder exists (`android/src/main/java/`)
- ✅ No Kotlin source folder present (`android/src/main/kotlin/` deleted)
- ✅ Only Java test folder exists (`android/src/test/java/`)
- ✅ No Kotlin test folder present (`android/src/test/kotlin/` deleted)
- ✅ Only Java instrumented test folder exists (`android/src/androidTest/java/`)
- ✅ No Kotlin instrumented test folder present (`android/src/androidTest/kotlin/` deleted)
- ✅ No Kotlin dependencies in `build.gradle`
- ✅ Plugin compiles successfully
- ✅ Unit tests pass (Java tests)
- ✅ Code follows Java conventions
- ✅ Test files follow Java conventions

---

### Scenario 2: Basic Kotlin Plugin

**Purpose:** Validate new Kotlin template generation

#### Configuration

| Parameter | Value |
|-----------|-------|
| Name | `test-kotlin-plugin` |
| Package ID | `com.example.testkotlin` |
| Class Name | `TestKotlin` |
| Android Language | `kotlin` |

#### Validation Checklist

- ✅ Only Kotlin source folder exists (`android/src/main/kotlin/`)
- ✅ No Java source folder present (`android/src/main/java/` deleted)
- ✅ Only Kotlin test folder exists (`android/src/test/kotlin/`)
- ✅ No Java test folder present (`android/src/test/java/` deleted)
- ✅ Only Kotlin instrumented test folder exists (`android/src/androidTest/kotlin/`)
- ✅ No Java instrumented test folder present (`android/src/androidTest/java/` deleted)
- ✅ Kotlin dependencies present in `build.gradle`
- ✅ Kotlin Gradle plugin applied
- ✅ JVM toolchain set to 21
- ✅ Plugin compiles successfully
- ✅ Unit tests pass (Kotlin tests)
- ✅ Code follows Kotlin conventions
- ✅ Test files follow Kotlin conventions (`.kt` extension)

---

### Scenario 3: Complex Package Names (Kotlin)

**Purpose:** Test edge cases in package naming

#### Configuration

| Parameter | Value |
|-----------|-------|
| Name | `@my-org/advanced-features-plugin` |
| Package ID | `io.mycompany.advanced.features` |
| Class Name | `AdvancedFeatures` |
| Android Language | `kotlin` |

#### Validation Checklist

- ✅ Package path correctly created (`io/mycompany/advanced/features/`)
- ✅ Scoped npm package handled correctly
- ✅ Compiles and tests pass

---

### Scenario 4: Simple Package Names (Java)

**Purpose:** Test minimal naming conventions

#### Configuration

| Parameter | Value |
|-----------|-------|
| Name | `simple-plugin` |
| Package ID | `com.simple` |
| Class Name | `Simple` |
| Android Language | `java` |

#### Validation Checklist

- ✅ Short package paths handled correctly
- ✅ Compiles and tests pass

---

### Scenario 5: Full Integration Test (Kotlin)

**Purpose:** Validate plugin works in real Capacitor app

#### Steps

1. Generate Kotlin plugin
2. Build plugin
3. Create test Capacitor app (already generated in `example-app/`)
4. Build iOS and Android platforms
5. Verify plugin loads and functions

#### Validation Checklist

- ✅ Plugin registers in Capacitor
- ✅ Echo method callable from web layer
- ✅ iOS and Android platforms build successfully

---

### Scenario 6: Full Integration Test (Java)

**Purpose:** Validate Java plugin works in real Capacitor app

#### Steps

1. Generate Java plugin
2. Build plugin
3. Use generated example app
4. Build iOS and Android platforms
5. Verify plugin loads and functions

#### Validation Checklist

- ✅ Plugin registers in Capacitor
- ✅ Echo method callable from web layer
- ✅ iOS and Android platforms build successfully

---

## Testing Unreleased PR Code

### Overview

Since PR #122 is not yet merged or released to npm, we need to build and use the tool locally from the PR branch.

The PR code is already available locally at: `../fork-create-capacitor-plugin-pr122-kotlin`

### Setup Process

#### 1. Verify the PR Branch

```bash
# Navigate to the PR directory
cd ../fork-create-capacitor-plugin-pr122-kotlin

# Verify we're on the correct branch
git branch --show-current

# Check the latest commits
git log --oneline -5
```

#### 2. Build the Tool Locally

```bash
# Install dependencies
npm install

# Build the TypeScript source
npm run build

# Verify the build created the dist/ folder
ls -la dist/

# Verify the CLI entry point exists
ls -la bin/create-capacitor-plugin
```

**Important:** Always use `bin/create-capacitor-plugin` as the entry point, not `dist/index.js`. The `bin/` script is the proper CLI entry point that:
- Sets the correct process title
- Handles `--verbose` flag for debugging
- Includes proper error handling
- Matches exactly how the tool runs when installed via npm

#### 3. Use the Local Build

There are three approaches to use the locally built tool:

##### Option A: npm link (Recommended)

```bash
# In the PR directory
cd ../fork-create-capacitor-plugin-pr122-kotlin
npm link

# Now you can use the tool globally
cd /path/to/test-directory
npm init @capacitor/plugin@local
```

##### Option B: Direct Execution via bin/ (Recommended)

```bash
# Run the built tool directly using the proper entry point
cd /path/to/test-directory
../fork-create-capacitor-plugin-pr122-kotlin/bin/create-capacitor-plugin \
  --name "test-plugin" \
  --package-id "com.example.test" \
  --class-name "TestPlugin" \
  --android-lang "kotlin"

# With verbose output for debugging
../fork-create-capacitor-plugin-pr122-kotlin/bin/create-capacitor-plugin \
  --verbose \
  --name "test-plugin" \
  --package-id "com.example.test" \
  --class-name "TestPlugin" \
  --android-lang "kotlin"
```

**Note:** This uses `bin/create-capacitor-plugin`, which is the proper CLI entry point (not `dist/index.js`). This ensures the tool runs exactly as it would when installed via npm.

##### Option C: npm pack + npx

```bash
# In the PR directory
cd ../fork-create-capacitor-plugin-pr122-kotlin
npm pack
# This creates create-capacitor-plugin-X.Y.Z.tgz

# Use the tarball with npx
cd /path/to/test-directory
npx ../fork-create-capacitor-plugin-pr122-kotlin/create-capacitor-plugin-X.Y.Z.tgz
```

### Verification

To verify you're using the PR code and not a published version:

```bash
# Check for the new --android-lang option
cd ../fork-create-capacitor-plugin-pr122-kotlin
./bin/create-capacitor-plugin --help | grep "android-lang"

# Should output something like:
# --android-lang <lang>  Android language (java or kotlin) (default: "java")

# Or check all help output
./bin/create-capacitor-plugin --help
```

### Automated Test Script Approach

The test script (`test-pr122.sh`) will use **Option B (Direct Execution via bin/)** because it:
- Uses the proper CLI entry point (`bin/create-capacitor-plugin`)
- Doesn't require global npm linking (avoids pollution)
- Works in CI/CD environments
- Allows testing multiple PR versions side-by-side
- Provides explicit path control
- Matches exactly how the tool runs when installed via npm

#### Script Implementation

```bash
# In test-pr122.sh
PLUGIN_TOOL_DIR="../fork-create-capacitor-plugin-pr122-kotlin"
PLUGIN_TOOL_CMD="${PLUGIN_TOOL_DIR}/bin/create-capacitor-plugin"

# ⚠️ IMPORTANT: All generated plugins MUST go in test-results/ directory
# DO NOT generate plugins in or modify the manual-tests/ directory
TEST_OUTPUT_DIR="./test-results"

generate_plugin() {
  local name=$1
  local package_id=$2
  local class_name=$3
  local android_lang=$4

  # Generate plugin in test-results directory
  cd "${TEST_OUTPUT_DIR}" || exit 1

  ${PLUGIN_TOOL_CMD} \
    --name "${name}" \
    --package-id "${package_id}" \
    --class-name "${class_name}" \
    --android-lang "${android_lang}" \
    --no-git

  cd - > /dev/null
}

# Usage
generate_plugin "test-kotlin-plugin" "com.example.testkotlin" "TestKotlin" "kotlin"

# For verbose debugging during development
generate_plugin_verbose() {
  local name=$1
  local package_id=$2
  local class_name=$3
  local android_lang=$4

  ${PLUGIN_TOOL_CMD} \
    --verbose \
    --name "${name}" \
    --package-id "${package_id}" \
    --class-name "${class_name}" \
    --android-lang "${android_lang}" \
    --no-git
}
```

---

## Automated Test Script

**⚠️ IMPORTANT:** The automated test script must respect the `manual-tests/` directory:
- All generated plugins go in `test-results/` directory
- **DO NOT** read, write, modify, or delete anything in `manual-tests/`
- `manual-tests/` is reserved exclusively for manual testing

### Script Structure

The automated script performs the following phases:

#### 1. Setup Phase
- Check prerequisites (Node.js, npm, Java/JDK, Gradle, Android SDK)
- Verify PR #122 code exists at `../fork-create-capacitor-plugin-pr122-kotlin`
- Build the tool locally (`cd ../fork-create-capacitor-plugin-pr122-kotlin && npm install && npm run build`)
- Verify `bin/create-capacitor-plugin` exists and is executable
- Verify tool contains new `--android-lang` option (`./bin/create-capacitor-plugin --help`)
- Create `test-results/` directory for generated plugins
- **⚠️ DO NOT** create, modify, or delete anything in `manual-tests/` directory
- See [Testing Unreleased PR Code](#testing-unreleased-pr-code) for detailed setup

#### 2. Generation Phase
- Generate plugins for each test scenario in `test-results/` directory
- **⚠️ DO NOT** use or modify `manual-tests/` directory
- Capture generation output and logs
- Validate file structure

#### 3. Compilation Phase
For each generated plugin:
- Run `npm install`
- Run `npm run build`
- Run `cd android && ./gradlew clean build test`
- Capture build output and test results

#### 4. Validation Phase
- Verify expected source files exist/don't exist (`src/main/kotlin/` vs `src/main/java/`)
- Verify expected test files exist/don't exist (`src/test/kotlin/` vs `src/test/java/`)
- Verify expected instrumented test files exist/don't exist (`src/androidTest/kotlin/` vs `src/androidTest/java/`)
- Confirm test files use correct file extensions (`.kt` for Kotlin, `.java` for Java)
- Parse test reports (JUnit XML)
- Check for Kotlin/Java-specific dependencies in `build.gradle`
- Validate package structure

#### 5. Reporting Phase
- Generate summary report
- List all passed/failed tests
- Provide detailed logs for failures
- Create comparison matrix

### Core Functions

| Function | Description |
|----------|-------------|
| `check_prerequisites()` | Validate all required tools installed |
| `verify_and_build_pr()` | Verify PR code exists at `../fork-create-capacitor-plugin-pr122-kotlin`, install deps, build, and verify `bin/` exists |
| `verify_pr_features()` | Verify `--android-lang` option exists in `bin/create-capacitor-plugin` |
| `generate_plugin()` | Generate plugin with specific options using local build |
| `build_plugin()` | Compile and test plugin |
| `validate_structure()` | Check file structure correctness (source, test, and instrumented test files) |
| `validate_dependencies()` | Parse `build.gradle` for expected dependencies |
| `run_tests()` | Execute unit and instrumented tests |
| `generate_report()` | Create summary report |

### Execution Flow

```bash
#!/bin/bash
set -e

# 1. Prerequisites check
check_prerequisites

# 2. Verify and build PR from local folder
verify_and_build_pr
verify_pr_features

# 3. Run test scenarios using local build
test_java_basic
test_kotlin_basic
test_complex_package_kotlin
test_simple_package_java
test_full_integration_kotlin
test_full_integration_java

# 4. Generate report
generate_report
```

---

## Prerequisites

### System Requirements

| Tool | Version | Notes |
|------|---------|-------|
| **Node.js** | >= 18.x | Required |
| **npm** | >= 8.x | Required |
| **Java** | JDK 21 | Required for Kotlin JVM toolchain |
| **Gradle** | 8.14.3 | Via wrapper |
| **Android SDK** | API level 36 | Required |
| **Git** | Latest | For cloning and repository operations |

### Optional (for full integration)

| Tool | Version | Notes |
|------|---------|-------|
| **Xcode** | 15+ | For iOS builds (macOS only) |
| **Android Emulator** | Latest | For instrumented tests |
| **CocoaPods** | Latest | For iOS dependency management |

### Environment Variables

| Variable | Description |
|----------|-------------|
| `ANDROID_HOME` | Path to Android SDK |
| `JAVA_HOME` | Path to JDK 21 |

---

## Success Criteria

### Must Pass

- ✅ All Java plugins generate, compile, and test successfully (regression)
- ✅ All Kotlin plugins generate, compile, and test successfully (new feature)
- ✅ Language-specific source folders correctly deleted (`src/main/kotlin/` or `src/main/java/`)
- ✅ Language-specific test folders correctly deleted (`src/test/kotlin/` or `src/test/java/`)
- ✅ Language-specific instrumented test folders correctly deleted (`src/androidTest/kotlin/` or `src/androidTest/java/`)
- ✅ Test files generated in the same language as source files (no mixed Java/Kotlin)
- ✅ `build.gradle` has correct conditional dependencies
- ✅ All generated unit tests pass (Java tests for Java plugins, Kotlin tests for Kotlin plugins)
- ✅ Plugins integrate successfully with Capacitor apps

### Quality Checks

- ✅ Generated source code follows language conventions (formatting, naming)
- ✅ Generated test code follows language conventions (formatting, naming, assertions)
- ✅ No compilation warnings in source or test code
- ✅ Test coverage adequate (unit + instrumented tests)
- ✅ Test file extensions correct (`.java` for Java, `.kt` for Kotlin)
- ✅ README documentation clear and accurate

---

## Execution Timeline

| Phase | Duration | Description |
|-------|----------|-------------|
| **Setup** | 5 minutes | Prerequisites check and PR setup |
| **Plugin Generation** | 10 minutes | Generate 6 test scenarios |
| **Compilation** | 20-30 minutes | Build and test all plugins |
| **Test Execution** | 10-15 minutes | Run unit and integration tests |
| **Reporting** | 2 minutes | Generate summary and logs |
| **Total** | **45-60 minutes** | End-to-end automated testing |

---

## Deliverables

1. **Test Plan Document** (this file) - Comprehensive test strategy and scenarios
2. **Automated Test Script** (`test-pr122.sh`) - Bash script for automated validation
3. **Test Report** - Generated summary with pass/fail status for all scenarios
4. **Generated Plugins** - Sample plugins for manual inspection

---

## Manual Verification Checklist

After automated tests pass, perform manual inspection:

- [ ] Review generated Kotlin code quality
- [ ] Review generated Java code quality
- [ ] Verify README instructions accurate
- [ ] Check `build.gradle` structure and formatting
- [ ] Validate test file quality
- [ ] Test interactive prompts (language selection)
- [ ] Verify CLI help text updated

---

## Risk Assessment

### Low Risk

- Java plugin generation (existing functionality)
- Basic Kotlin template rendering

### Medium Risk

- Conditional Gradle configuration
- Language-specific folder deletion
- Complex package name handling

### High Risk

- Full integration with Capacitor apps
- Android instrumented tests (requires device/emulator)
- Cross-platform compatibility

---

## Rollback Plan

If critical issues are found:

1. Document specific failures
2. Create GitHub issue with reproduction steps
3. Request PR author address issues
4. Re-test after fixes

---

## Implementation Steps

- [x] Write test plan (this document)
- [ ] Create automated test script (`test-pr122.sh`)
- [ ] Execute tests and capture results
- [ ] Generate report with findings
- [ ] Provide feedback to PR author if issues found

**Script Location:** `/Users/pedrobilro/Desktop/client_projects/outsystems/source_codes/community_ionic_repos/test-create-capacitor-plugin-pr122/test-pr122.sh`

---

## File Structure

```
test-create-capacitor-plugin-pr122/
├── test-pr122.sh              # Main test script
├── TEST_PLAN.md               # This document
├── manual-tests/              # ⚠️  DO NOT TOUCH - User's manual testing area
├── test-results/              # Generated during test execution
│   ├── summary.txt            # Overall pass/fail summary
│   ├── test-java-plugin/      # Generated Java plugin
│   ├── test-kotlin-plugin/    # Generated Kotlin plugin
│   ├── test-complex-kotlin/   # Complex package Kotlin plugin
│   ├── test-simple-java/      # Simple package Java plugin
│   └── logs/                  # Detailed logs
└── reports/                   # Test reports and comparison matrices
```

**⚠️ IMPORTANT:** The `manual-tests/` directory is reserved for manual testing. Automated test scripts **MUST NOT**:
- Add files to this directory
- Delete files from this directory
- Modify any contents in this directory
- Use this directory for automated test output

---

**Document Version:** 1.0
**Last Updated:** 2026-02-27
**Status:** Ready for Implementation
