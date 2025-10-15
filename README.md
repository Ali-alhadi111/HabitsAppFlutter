# Habit Tracker App

A Flutter mobile application for tracking daily habits with reminders, progress visualization, and comprehensive statistics.

## Features

### Core Functionality
- **Habit Management**: Create, edit, and delete habits with detailed customization
- **Progress Tracking**: Track daily completions with visual progress indicators
- **Smart Reminders**: Customizable notification system with time and day selection
- **Streak Tracking**: Monitor current and longest streaks for motivation
- **Statistics Dashboard**: Comprehensive analytics with charts and insights


###  Analytics & Insights
- **Progress Charts**: Visual representation of weekly progress
- **Category Breakdown**: Pie charts showing habit distribution
- **Streak Leaderboard**: Track and compare habit performance
- **Completion Statistics**: Detailed completion history and trends

###  Smart Notifications
- **Customizable Timing**: Set specific reminder times for each habit
- **Day Selection**: Choose which days to receive reminders
- **Persistent Notifications**: Reliable reminder delivery
- **Permission Management**: Graceful handling of notification permissions

## Technical Features

###  Architecture
- **Provider State Management**: Clean separation of concerns
- **SQLite Database**: Local data persistence with efficient queries
- **Modular Design**: Well-organized code structure with reusable components
- **Error Handling**: Comprehensive error management and user feedback

###  Platform Support
- **Android**: Full feature support with native notifications
- **iOS**: Compatible with iOS notification system
- **Cross-Platform**: Single codebase for both platforms

## Getting Started

### Prerequisites
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / VS Code
- Android device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd habit_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```


## Key Dependencies

- **flutter_local_notifications**: Local notification system
- **sqflite**: SQLite database for local storage
- **provider**: State management solution
- **fl_chart**: Beautiful charts and graphs
- **google_fonts**: Typography and fonts
- **permission_handler**: Permission management
- **timezone**: Timezone handling for notifications

## Usage Guide

### Creating a Habit
1. Tap the "+" button on the home screen
2. Fill in habit details (title, description, category)
3. Set frequency (daily, weekly, monthly)
4. Configure reminder time and days
5. Choose target count and unit (e.g., "8 glasses")
6. Select color and icon
7. Save the habit

### Tracking Progress
1. View habits on the home screen
2. Tap "Complete" to mark a habit as done
3. For multi-count habits, track progress throughout the day
4. View detailed progress in the habit detail screen

### Viewing Statistics
1. Navigate to the Statistics tab
2. View overview metrics and trends
3. Check individual habit progress
4. Review streak leaderboard
5. Analyze category breakdown




## Screenshots
![App Presentation ](https://github.com/user-attachments/assets/ac176ad5-f9c6-45ff-97af-029413d457dc)


