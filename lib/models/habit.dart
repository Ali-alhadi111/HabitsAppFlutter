import 'package:flutter/material.dart';

enum HabitFrequency {
  daily,
  weekly,
  monthly,
}

enum HabitCategory {
  health,
  fitness,
  learning,
  productivity,
  mindfulness,
  social,
  creative,
  other,
}

class Habit {
  final int? id;
  final String title;
  final String description;
  final HabitCategory category;
  final HabitFrequency frequency;
  final TimeOfDay reminderTime;
  final List<int> reminderDays; // 0 = Sunday, 1 = Monday, etc.
  final Color color;
  final String icon;
  final DateTime createdAt;
  final bool isActive;
  final int targetCount; // For habits that need multiple completions per day
  final String unit; // e.g., "glasses", "minutes", "pages"

  Habit({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.frequency,
    required this.reminderTime,
    required this.reminderDays,
    required this.color,
    required this.icon,
    required this.createdAt,
    this.isActive = true,
    this.targetCount = 1,
    this.unit = '',
  });

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    HabitCategory? category,
    HabitFrequency? frequency,
    TimeOfDay? reminderTime,
    List<int>? reminderDays,
    Color? color,
    String? icon,
    DateTime? createdAt,
    bool? isActive,
    int? targetCount,
    String? unit,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      frequency: frequency ?? this.frequency,
      reminderTime: reminderTime ?? this.reminderTime,
      reminderDays: reminderDays ?? this.reminderDays,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      isActive: isActive ?? this.isActive,
      targetCount: targetCount ?? this.targetCount,
      unit: unit ?? this.unit,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.index,
      'frequency': frequency.index,
      'reminder_hour': reminderTime.hour,
      'reminder_minute': reminderTime.minute,
      'reminder_days': reminderDays.join(','),
      'color_value': color.value,
      'icon': icon,
      'created_at': createdAt.millisecondsSinceEpoch,
      'is_active': isActive ? 1 : 0,
      'target_count': targetCount,
      'unit': unit,
    };
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      category: HabitCategory.values[map['category']],
      frequency: HabitFrequency.values[map['frequency']],
      reminderTime: TimeOfDay(
        hour: map['reminder_hour'],
        minute: map['reminder_minute'],
      ),
      reminderDays: (map['reminder_days'] as String)
          .split(',')
          .map((e) => int.parse(e))
          .toList(),
      color: Color(map['color_value']),
      icon: map['icon'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      isActive: map['is_active'] == 1,
      targetCount: map['target_count'] ?? 1,
      unit: map['unit'] ?? '',
    );
  }
}

class HabitCompletion {
  final int? id;
  final int habitId;
  final DateTime completedAt;
  final int count; // For habits that can be completed multiple times per day
  final String? notes;

  HabitCompletion({
    this.id,
    required this.habitId,
    required this.completedAt,
    this.count = 1,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'habit_id': habitId,
      'completed_at': completedAt.millisecondsSinceEpoch,
      'count': count,
      'notes': notes,
    };
  }

  factory HabitCompletion.fromMap(Map<String, dynamic> map) {
    return HabitCompletion(
      id: map['id'],
      habitId: map['habit_id'],
      completedAt: DateTime.fromMillisecondsSinceEpoch(map['completed_at']),
      count: map['count'] ?? 1,
      notes: map['notes'],
    );
  }
}


