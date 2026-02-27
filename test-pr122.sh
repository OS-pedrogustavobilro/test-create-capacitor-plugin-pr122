#!/bin/bash

################################################################################
# Test Script for PR #122: Kotlin/Java Language Selection
#
# This script automates the testing of the new Android language selection
# feature for Capacitor plugin generation.
#
# Usage: ./test-pr122.sh
################################################################################

set -e  # Exit on error
set -o pipefail  # Exit on pipe failure

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PLUGIN_TOOL_DIR="${SCRIPT_DIR}/../fork-create-capacitor-plugin-pr122-kotlin"
PLUGIN_TOOL_CMD="${PLUGIN_TOOL_DIR}/bin/create-capacitor-plugin"
TEST_OUTPUT_DIR="${SCRIPT_DIR}/test-results"
LOGS_DIR="${TEST_OUTPUT_DIR}/logs"
REPORTS_DIR="${SCRIPT_DIR}/reports"

# Test results tracking
TESTS_PASSED=0
TESTS_FAILED=0
FAILED_TESTS=()

################################################################################
# Logging Functions
################################################################################

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_section() {
    echo ""
    echo "================================================================================"
    echo -e "${BLUE}$1${NC}"
    echo "================================================================================"
    echo ""
}

################################################################################
# Prerequisite Checks
################################################################################

check_command() {
    local cmd=$1
    local required=$2
    local version_cmd=$3

    if command -v "$cmd" &> /dev/null; then
        local version=""
        if [ -n "$version_cmd" ]; then
            version=$(eval "$version_cmd" 2>&1 | head -n 1 || echo "unknown")
        fi
        log_success "$cmd found${version:+ ($version)}"
        return 0
    else
        if [ "$required" = "required" ]; then
            log_error "$cmd not found (REQUIRED)"
            return 1
        else
            log_warning "$cmd not found (optional)"
            return 0
        fi
    fi
}

check_prerequisites() {
    log_section "Phase 1: Checking Prerequisites"

    local all_ok=true

    # Required tools
    check_command "node" "required" "node --version" || all_ok=false
    check_command "npm" "required" "npm --version" || all_ok=false
    check_command "java" "required" "java -version" || all_ok=false
    check_command "git" "required" "git --version" || all_ok=false

    # Optional tools
    check_command "gradle" "optional" "gradle --version | head -n 1"

    # Check environment variables
    if [ -z "$JAVA_HOME" ]; then
        log_warning "JAVA_HOME not set"
    else
        log_success "JAVA_HOME set to: $JAVA_HOME"
    fi

    if [ -z "$ANDROID_HOME" ]; then
        log_warning "ANDROID_HOME not set (required for full Android builds)"
    else
        log_success "ANDROID_HOME set to: $ANDROID_HOME"
    fi

    if [ "$all_ok" = false ]; then
        log_error "Prerequisites check failed. Please install missing required tools."
        exit 1
    fi

    log_success "All required prerequisites satisfied"
}

################################################################################
# PR Setup and Verification
################################################################################

verify_and_build_pr() {
    log_section "Phase 2: Verifying and Building PR Code"

    # Check if PR directory exists
    if [ ! -d "$PLUGIN_TOOL_DIR" ]; then
        log_error "PR directory not found at: $PLUGIN_TOOL_DIR"
        log_error "Please ensure the PR code is cloned to the correct location."
        exit 1
    fi

    log_info "Found PR directory at: $PLUGIN_TOOL_DIR"

    # Navigate to PR directory
    cd "$PLUGIN_TOOL_DIR" || exit 1

    # Check current branch
    local branch=$(git branch --show-current 2>/dev/null || echo "unknown")
    log_info "Current branch: $branch"

    # Show recent commits
    log_info "Recent commits:"
    git log --oneline -3 || true

    # Install dependencies
    log_info "Installing dependencies..."
    npm install >> "${LOGS_DIR}/pr-build.log" 2>&1 || {
        log_error "npm install failed. Check ${LOGS_DIR}/pr-build.log"
        exit 1
    }

    # Build the tool
    log_info "Building the tool..."
    npm run build >> "${LOGS_DIR}/pr-build.log" 2>&1 || {
        log_error "npm run build failed. Check ${LOGS_DIR}/pr-build.log"
        exit 1
    }

    # Verify bin directory exists
    if [ ! -f "$PLUGIN_TOOL_CMD" ]; then
        log_error "Build did not create expected binary at: $PLUGIN_TOOL_CMD"
        exit 1
    fi

    # Make it executable
    chmod +x "$PLUGIN_TOOL_CMD"

    log_success "PR code built successfully"

    # Return to script directory
    cd "$SCRIPT_DIR" || exit 1
}

verify_pr_features() {
    log_section "Phase 3: Verifying PR Features"

    log_info "Checking for --android-lang option..."

    if "$PLUGIN_TOOL_CMD" --help 2>&1 | grep -q "android-lang"; then
        log_success "Found --android-lang option"

        # Show the help text for this option
        log_info "Option details:"
        "$PLUGIN_TOOL_CMD" --help 2>&1 | grep -A 1 "android-lang" || true
    else
        log_error "PR does not contain expected --android-lang option"
        log_error "This may not be the correct PR code."
        exit 1
    fi
}

################################################################################
# Plugin Generation Functions
################################################################################

generate_plugin() {
    local name=$1
    local package_id=$2
    local class_name=$3
    local android_lang=$4
    local output_dir="${TEST_OUTPUT_DIR}/${name}"

    log_info "Generating plugin: $name (language: $android_lang)"

    # Remove existing directory if present (tool will create it)
    if [ -d "$output_dir" ]; then
        log_warning "Removing existing directory: $output_dir"
        rm -rf "$output_dir"
    fi

    # Generate plugin (tool will create the directory)
    local log_file="${LOGS_DIR}/${name}-generation.log"

    cd "$TEST_OUTPUT_DIR" || exit 1

    if "$PLUGIN_TOOL_CMD" \
        "$name" \
        --name "$name" \
        --package-id "$package_id" \
        --class-name "$class_name" \
        --android-lang "$android_lang" \
        --repo "https://github.com/test/test-plugin" \
        --author "Test Author <test@example.com>" \
        --license "MIT" \
        --description "Test plugin for PR #122 validation" > "$log_file" 2>&1; then

        log_success "Generated plugin: $name"
        cd "$SCRIPT_DIR" || exit 1
        return 0
    else
        log_error "Failed to generate plugin: $name"
        log_error "Check log: $log_file"
        cd "$SCRIPT_DIR" || exit 1
        return 1
    fi
}

################################################################################
# Validation Functions
################################################################################

validate_folder_exists() {
    local plugin_dir=$1
    local folder_path=$2
    local should_exist=$3

    if [ "$should_exist" = "yes" ]; then
        if [ -d "${plugin_dir}/${folder_path}" ]; then
            return 0
        else
            log_error "Expected folder not found: $folder_path"
            return 1
        fi
    else
        if [ ! -d "${plugin_dir}/${folder_path}" ]; then
            return 0
        else
            log_error "Unexpected folder found: $folder_path"
            return 1
        fi
    fi
}

validate_file_exists() {
    local plugin_dir=$1
    local file_path=$2

    if [ -f "${plugin_dir}/${file_path}" ]; then
        return 0
    else
        log_error "Expected file not found: $file_path"
        return 1
    fi
}

validate_file_extension() {
    local plugin_dir=$1
    local folder_path=$2
    local expected_ext=$3

    local files=$(find "${plugin_dir}/${folder_path}" -type f -name "*${expected_ext}" 2>/dev/null | wc -l)

    if [ "$files" -gt 0 ]; then
        return 0
    else
        log_error "No files with extension $expected_ext found in $folder_path"
        return 1
    fi
}

validate_gradle_dependencies() {
    local plugin_dir=$1
    local android_lang=$2
    local gradle_file="${plugin_dir}/android/build.gradle"

    if [ ! -f "$gradle_file" ]; then
        log_error "build.gradle not found at: $gradle_file"
        return 1
    fi

    if [ "$android_lang" = "kotlin" ]; then
        # Check for Kotlin plugin and configuration
        # Note: kotlin-stdlib is auto-added by kotlin-android plugin in modern Kotlin
        if grep -q "kotlin-android" "$gradle_file" && \
           grep -q "kotlin" "$gradle_file"; then
            return 0
        else
            log_error "Expected Kotlin configuration not found in build.gradle"
            return 1
        fi
    else
        # Check that Kotlin dependencies are NOT present
        if ! grep -q "kotlin-android" "$gradle_file" && \
           ! grep -q "org.jetbrains.kotlin:kotlin-stdlib" "$gradle_file"; then
            return 0
        else
            log_error "Unexpected Kotlin dependencies found in build.gradle for Java plugin"
            return 1
        fi
    fi
}

validate_plugin_structure() {
    local name=$1
    local android_lang=$2
    local plugin_dir="${TEST_OUTPUT_DIR}/${name}"

    log_info "Validating structure for: $name"

    local validation_ok=true

    if [ "$android_lang" = "kotlin" ]; then
        # Kotlin: should have kotlin folders, not java folders
        validate_folder_exists "$plugin_dir" "android/src/main/kotlin" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/main/java" "no" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/test/kotlin" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/test/java" "no" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/androidTest/kotlin" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/androidTest/java" "no" || validation_ok=false

        # Check file extensions
        validate_file_extension "$plugin_dir" "android/src/main/kotlin" ".kt" || validation_ok=false
        validate_file_extension "$plugin_dir" "android/src/test/kotlin" ".kt" || validation_ok=false

    else
        # Java: should have java folders, not kotlin folders
        validate_folder_exists "$plugin_dir" "android/src/main/java" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/main/kotlin" "no" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/test/java" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/test/kotlin" "no" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/androidTest/java" "yes" || validation_ok=false
        validate_folder_exists "$plugin_dir" "android/src/androidTest/kotlin" "no" || validation_ok=false

        # Check file extensions
        validate_file_extension "$plugin_dir" "android/src/main/java" ".java" || validation_ok=false
        validate_file_extension "$plugin_dir" "android/src/test/java" ".java" || validation_ok=false
    fi

    # Validate Gradle dependencies
    validate_gradle_dependencies "$plugin_dir" "$android_lang" || validation_ok=false

    if [ "$validation_ok" = true ]; then
        log_success "Structure validation passed for: $name"
        return 0
    else
        log_error "Structure validation failed for: $name"
        return 1
    fi
}

################################################################################
# Build and Test Functions
################################################################################

build_plugin() {
    local name=$1
    local plugin_dir="${TEST_OUTPUT_DIR}/${name}"
    local log_file="${LOGS_DIR}/${name}-build.log"

    log_info "Building plugin: $name"

    cd "$plugin_dir" || return 1

    # Install npm dependencies
    log_info "Installing npm dependencies for: $name"
    if ! npm install > "$log_file" 2>&1; then
        log_error "npm install failed for: $name"
        cd "$SCRIPT_DIR" || exit 1
        return 1
    fi

    # Build the plugin
    log_info "Running npm build for: $name"
    if ! npm run build >> "$log_file" 2>&1; then
        log_error "npm build failed for: $name"
        cd "$SCRIPT_DIR" || exit 1
        return 1
    fi

    log_success "Built plugin: $name"
    cd "$SCRIPT_DIR" || exit 1
    return 0
}

run_gradle_tests() {
    local name=$1
    local plugin_dir="${TEST_OUTPUT_DIR}/${name}"
    local log_file="${LOGS_DIR}/${name}-gradle.log"

    log_info "Running Gradle build and tests for: $name"

    cd "${plugin_dir}/android" || return 1

    # Run Gradle build with tests
    if ./gradlew clean build test > "$log_file" 2>&1; then
        log_success "Gradle tests passed for: $name"
        cd "$SCRIPT_DIR" || exit 1
        return 0
    else
        log_error "Gradle tests failed for: $name"
        log_error "Check log: $log_file"
        cd "$SCRIPT_DIR" || exit 1
        return 1
    fi
}

################################################################################
# Test Scenario Functions
################################################################################

run_test_scenario() {
    local scenario_name=$1
    local plugin_name=$2
    local package_id=$3
    local class_name=$4
    local android_lang=$5

    log_section "Testing Scenario: $scenario_name"

    local test_passed=true

    # Generate plugin
    if ! generate_plugin "$plugin_name" "$package_id" "$class_name" "$android_lang"; then
        test_passed=false
    fi

    # Validate structure
    if [ "$test_passed" = true ]; then
        if ! validate_plugin_structure "$plugin_name" "$android_lang"; then
            test_passed=false
        fi
    fi

    # Build plugin
    if [ "$test_passed" = true ]; then
        if ! build_plugin "$plugin_name"; then
            test_passed=false
        fi
    fi

    # Run Gradle tests
    if [ "$test_passed" = true ]; then
        if ! run_gradle_tests "$plugin_name"; then
            test_passed=false
        fi
    fi

    # Record results
    if [ "$test_passed" = true ]; then
        log_success "✓ Scenario passed: $scenario_name"
        ((TESTS_PASSED++))
    else
        log_error "✗ Scenario failed: $scenario_name"
        ((TESTS_FAILED++))
        FAILED_TESTS+=("$scenario_name")
    fi

    # Always return 0 so script continues even if this scenario failed
    return 0
}

################################################################################
# Report Generation
################################################################################

generate_report() {
    log_section "Phase 4: Generating Test Report"

    local report_file="${REPORTS_DIR}/test-summary.txt"
    local total_tests=$((TESTS_PASSED + TESTS_FAILED))

    mkdir -p "$REPORTS_DIR"

    {
        echo "================================================================================"
        echo "Test Report for PR #122: Kotlin/Java Language Selection"
        echo "================================================================================"
        echo ""
        echo "Date: $(date)"
        echo "Total Tests: $total_tests"
        echo "Passed: $TESTS_PASSED"
        echo "Failed: $TESTS_FAILED"
        echo ""

        if [ $TESTS_FAILED -gt 0 ]; then
            echo "Failed Tests:"
            for test in "${FAILED_TESTS[@]}"; do
                echo "  - $test"
            done
            echo ""
        fi

        echo "Detailed logs available in: $LOGS_DIR"
        echo ""

        if [ $TESTS_FAILED -eq 0 ]; then
            echo "Result: ALL TESTS PASSED ✓"
        else
            echo "Result: SOME TESTS FAILED ✗"
        fi

        echo "================================================================================"
    } | tee "$report_file"

    log_success "Report saved to: $report_file"
}

################################################################################
# Main Execution
################################################################################

main() {
    log_section "PR #122 Automated Test Suite"
    log_info "Starting automated tests for Kotlin/Java language selection feature"

    # Setup
    mkdir -p "$TEST_OUTPUT_DIR"
    mkdir -p "$LOGS_DIR"
    mkdir -p "$REPORTS_DIR"

    # Verify manual-tests directory is not touched
    if [ -d "${SCRIPT_DIR}/manual-tests" ]; then
        log_warning "manual-tests/ directory exists - will not be modified by this script"
    fi

    # Run prerequisite checks
    check_prerequisites

    # Setup PR code
    verify_and_build_pr
    verify_pr_features

    # Run test scenarios
    run_test_scenario \
        "Scenario 1: Basic Java Plugin (Regression)" \
        "test-java-plugin" \
        "com.example.testjava" \
        "TestJava" \
        "java"

    run_test_scenario \
        "Scenario 2: Basic Kotlin Plugin" \
        "test-kotlin-plugin" \
        "com.example.testkotlin" \
        "TestKotlin" \
        "kotlin"

    run_test_scenario \
        "Scenario 3: Complex Package Names (Kotlin)" \
        "advanced-features-plugin" \
        "io.mycompany.advanced.features" \
        "AdvancedFeatures" \
        "kotlin"

    run_test_scenario \
        "Scenario 4: Simple Package Names (Java)" \
        "simple-plugin" \
        "com.simple" \
        "Simple" \
        "java"

    # Generate final report
    generate_report

    # Exit with appropriate code
    if [ $TESTS_FAILED -eq 0 ]; then
        log_success "All tests completed successfully!"
        exit 0
    else
        log_error "Some tests failed. Please review the logs."
        exit 1
    fi
}

# Run main function
main "$@"
