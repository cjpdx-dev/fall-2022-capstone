#!/bin/bash

set -e
YELLOW='\033[1;33m' # Yellow color
NC='\033[0m' # No Color
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'

xcodegen_installed=0

user_warning() {
    echo -e "${YELLOW}$1${NC}"
}

success_prompt() {
    echo -e "${GREEN}$1${NC}"
}

setup_section_prompt() {
    echo -e "${BLUE}$1${NC}"
}


error_trap_message() {
    echo -e "${RED}$1${NC}"
}

# Trap function for script exit
error_trap() {
    local exit_code=$?
    if [ "$exit_code" != "0" ]; then
        error_trap_message "Error: The script encountered an issue and will exit with code $exit_code"
    fi
}

trap error_trap EXIT

setup_section_prompt "Starting setup for the iOS project..."
sleep 1

# Initialize a flag to track if an update was installed
update_installed=0

# Function to update RubyGems
update_gems() {
    setup_section_prompt "Updating RubyGems..."
    sleep 1
    if gem update --system; then
        update_installed=1
        success_prompt "[Success]"
    else
        user_warning "Failed to update RubyGems. Continuing setup..."
    fi
}

# Function to install CocoaPods
install_cocoapods() {
    setup_section_prompt "Installing CocoaPods..."
    sleep 1
    if sudo gem install cocoapods; then
        update_installed=1
        success_prompt "[Success]"
    else
        user_warning "Failed to install CocoaPods. Continuing setup..."
    fi
}

# Function to update CocoaPods
update_cocoapods() {
    setup_section_prompt "Updating CocoaPods..."
    sleep 1
    if sudo gem update cocoapods; then
        update_installed=1
        success_prompt "[Success]"
    else
        user_warning "Failed to update CocoaPods. Continuing setup..."
    fi
}

# Function to update Xcode Command Line Tools
update_xcode() {
    setup_section_prompt "Updating Xcode Command Line Tools..."
    sleep 1
    if softwareupdate -i -a; then
        update_installed=1
        success_prompt "[Success]"
    else
        user_warning "Failed to update Xcode Command Line Tools. Continuing setup..."
    fi
}

# Update RubyGems
update_gems

# Install/Update CocoaPods
if ! command -v pod >/dev/null; then
    install_cocoapods
else
    update_cocoapods
fi

# Update Xcode Command Line Tools
update_xcode

# Navigate to the project's frontend directory
# Update the path as per your project structure
cd frontend || exit

update_homebrew() {
    setup_section_prompt "Updating Homebrew..."
    sleep 1
    if brew update; then
        success_prompt "Homebrew is up to date."
    else
        user_warning "Failed to update Homebrew. Continuing setup..."
    fi
}

check_outdated_brew_formulae() {
    local outdated=$(brew outdated)
    if [[ -n "$outdated" ]]; then
        user_warning "You have the following outdated formulae:\n"
        echo "$outdated"
        user_warning "Consider running 'brew upgrade' to update them and repeating this setup script."
    else
        success_prompt "All Homebrew formulae are up to date."
    fi
}

install_xcodegen() {
    setup_section_prompt "Installing XcodeGen..."
    sleep 1
    if brew list xcodegen >/dev/null 2>&1; then
        success_prompt "\nXcodeGen is already installed.\n"
        xcodegen_installed=1
    elif brew install xcodegen; then
        success_prompt "\nSuccess\n"
        xcodegen_installed=1
    else
        user_warning "\nFailed to install XcodeGen \nXCode project files could be corrupt or unintialized.\n"
    fi
}

run_xcodegen() {

    setup_section_prompt "\nGenerating project with XcodeGen...\n"
    sleep 1
    if xcodegen generate; then
        success_prompt "\nProject generated successfully.\n"
    else
        user_warning "\nFailed to generate project with XcodeGen.\nXCode project files could remain missing or corrupt. Please check for errors.\n"
    fi
}

# Run pod install
run_pod_install() {
    setup_section_prompt "\nRunning 'pod install' for the project...\n"
    sleep 1
    pod install || error_trap_message "\nFailed to run 'pod install'. Running the application will not be possible. Please check for errors.\n"
}

update_homebrew

check_outdated_brew_formulae

install_xcodegen

if [ "$xcodegen_installed" -eq 1 ]; then
    run_xcodegen
else
    user_warning "\nSkipping command: xcodegen generate\n"
    sleep 1
fi

run_pod_install

setup_section_prompt "\nCompleted setup.sh\n"

# Notify the user if any updates were installed
if [ "$update_installed" -eq 1 ]; then
    user_warning "\n NOTE: System updates have been installed. You may need to restart your system and rerun this setup script if necessary."
fi
