#!/bin/bash

echo "🚀 Habit Tracker App Setup"
echo "=========================="

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed. Please install Flutter first."
    echo "Visit: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter is installed"

# Check Flutter version
echo "📱 Flutter version:"
flutter --version

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Check for any issues
echo "🔍 Checking for issues..."
flutter doctor

# Run the app
echo "🎯 Starting the app..."
echo "Make sure you have an Android device connected or emulator running!"
echo ""

flutter run


