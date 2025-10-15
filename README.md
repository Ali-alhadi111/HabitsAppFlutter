# Habit Tracker App

A beautiful and feature-rich Flutter mobile application for tracking daily habits with reminders, progress visualization, and comprehensive statistics.

## Features

### 🎯 Core Functionality
- **Habit Management**: Create, edit, and delete habits with detailed customization
- **Progress Tracking**: Track daily completions with visual progress indicators
- **Smart Reminders**: Customizable notification system with time and day selection
- **Streak Tracking**: Monitor current and longest streaks for motivation
- **Statistics Dashboard**: Comprehensive analytics with charts and insights

### 🎨 Beautiful Design
- **Modern UI**: Clean, intuitive interface with Material Design principles
- **Customizable Colors**: 10+ color options for personalizing habits
- **Icon Selection**: 30+ icons to represent different habit types
- **Smooth Animations**: Delightful micro-interactions and transitions
- **Responsive Layout**: Optimized for different screen sizes

### 📊 Analytics & Insights
- **Progress Charts**: Visual representation of weekly progress
- **Category Breakdown**: Pie charts showing habit distribution
- **Streak Leaderboard**: Track and compare habit performance
- **Completion Statistics**: Detailed completion history and trends

### 🔔 Smart Notifications
- **Customizable Timing**: Set specific reminder times for each habit
- **Day Selection**: Choose which days to receive reminders
- **Persistent Notifications**: Reliable reminder delivery
- **Permission Management**: Graceful handling of notification permissions

## Technical Features

### 🏗️ Architecture
- **Provider State Management**: Clean separation of concerns
- **SQLite Database**: Local data persistence with efficient queries
- **Modular Design**: Well-organized code structure with reusable components
- **Error Handling**: Comprehensive error management and user feedback

### 📱 Platform Support
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

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── habit.dart           # Habit and completion models
├── providers/               # State management
│   ├── habit_provider.dart  # Habit state management
│   └── notification_provider.dart # Notification state
├── screens/                 # UI screens
│   ├── home_screen.dart     # Main dashboard
│   ├── add_habit_screen.dart # Create new habits
│   ├── habit_detail_screen.dart # Habit details and history
│   └── statistics_screen.dart # Analytics dashboard
├── widgets/                 # Reusable UI components
│   ├── habit_card.dart      # Habit display card
│   ├── progress_chart.dart  # Progress visualization
│   ├── streak_widget.dart   # Streak tracking
│   └── ...                  # Other UI components
├── database/                # Data persistence
│   └── database_helper.dart # SQLite operations
└── utils/                   # Utilities
    ├── app_colors.dart      # Color scheme
    └── notification_service.dart # Notification handling
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

## Customization

### Adding New Habit Categories
1. Update `HabitCategory` enum in `models/habit.dart`
2. Add corresponding icon and name in `widgets/category_selector.dart`

### Modifying Color Scheme
1. Update colors in `utils/app_colors.dart`
2. Add new colors to `habitColors` list for habit customization

### Adding New Icons
1. Add icon names to `icons` list in `widgets/icon_selector.dart`
2. Implement corresponding `IconData` in `_getIconData()` method

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Open source community for various packages used

## Support

For support, please create an issue in the repository.

## Screenshots

_Add screenshots of your app here after taking some on your device_

---

**Happy Habit Building! 🚀**

Made with ❤️ using Flutter


