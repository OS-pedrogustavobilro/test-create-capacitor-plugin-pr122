# Test Suite for PR #122: Kotlin/Java Language Selection

Test suite for validating the Android language selection feature (Kotlin/Java) in Capacitor plugin generation.

## Structure

- **`manual-tests/`** - Manual testing workspace (not modified by automation)
- **`test-pr122.sh`** - AI-assisted automated test script
- **`TEST_PLAN.md`** - Comprehensive test strategy and scenarios
- **`TEST_RESULTS.md`** - Detailed test results and findings
- **`EXECUTION_GUIDE.md`** - Complete usage instructions

## Quick Start

### Prerequisites

Ensure the PR code is available locally. The test script expects it at:

```
../fork-create-capacitor-plugin-pr122-kotlin
```

Adjust the path in `test-pr122.sh` if your PR fork is located elsewhere:

```bash
# Line 14 in test-pr122.sh
PLUGIN_TOOL_DIR="${SCRIPT_DIR}/../fork-create-capacitor-plugin-pr122-kotlin"
```

### Run Automated Tests

```bash
./test-pr122.sh
```

The script will build the PR code from source and run all test scenarios.

## Results

Last run: ✅ **4/4 tests passed** (Feb 27, 2026)
- Scenario 1: Basic Java Plugin (Regression) - PASSED
- Scenario 2: Basic Kotlin Plugin - PASSED
- Scenario 3: Complex Package Names (Kotlin) - PASSED
- Scenario 4: Simple Package Names (Java) - PASSED
