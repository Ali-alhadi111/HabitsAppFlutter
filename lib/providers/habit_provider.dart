import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../database/database_helper.dart';

class HabitProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  List<Habit> get activeHabits => _habits.where((h) => h.isActive).toList();

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      _habits = await _dbHelper.getAllHabits();
    } catch (e) {
      print('Error loading habits: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    try {
      final id = await _dbHelper.insertHabit(habit);
      final newHabit = habit.copyWith(id: id);
      _habits.add(newHabit);
      
      notifyListeners();
    } catch (e) {
      print('Error adding habit: $e');
      rethrow;
    }
  }

  Future<void> updateHabit(Habit habit) async {
    try {
      await _dbHelper.updateHabit(habit);
      final index = _habits.indexWhere((h) => h.id == habit.id);
      if (index != -1) {
        _habits[index] = habit;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating habit: $e');
      rethrow;
    }
  }

  Future<void> deleteHabit(int habitId) async {
    try {
      await _dbHelper.deleteHabit(habitId);
      _habits.removeWhere((h) => h.id == habitId);
      notifyListeners();
    } catch (e) {
      print('Error deleting habit: $e');
      rethrow;
    }
  }

  Future<void> toggleHabitActive(int habitId) async {
    try {
      final habit = _habits.firstWhere((h) => h.id == habitId);
      final updatedHabit = habit.copyWith(isActive: !habit.isActive);
      await updateHabit(updatedHabit);
    } catch (e) {
      print('Error toggling habit: $e');
      rethrow;
    }
  }

  Future<void> completeHabit(int habitId, {int count = 1, String? notes}) async {
    try {
      final completion = HabitCompletion(
        habitId: habitId,
        completedAt: DateTime.now(),
        count: count,
        notes: notes,
      );
      await _dbHelper.insertHabitCompletion(completion);
      notifyListeners();
    } catch (e) {
      print('Error completing habit: $e');
      rethrow;
    }
  }

  Future<int> getHabitCompletionsForDate(int habitId, DateTime date) async {
    try {
      return await _dbHelper.getTotalCompletionsForDate(habitId, date);
    } catch (e) {
      print('Error getting completions: $e');
      return 0;
    }
  }

  Future<int> getCurrentStreak(int habitId) async {
    try {
      return await _dbHelper.getCurrentStreak(habitId);
    } catch (e) {
      print('Error getting current streak: $e');
      return 0;
    }
  }

  Future<int> getLongestStreak(int habitId) async {
    try {
      return await _dbHelper.getLongestStreak(habitId);
    } catch (e) {
      print('Error getting longest streak: $e');
      return 0;
    }
  }

  Future<List<HabitCompletion>> getHabitCompletions(int habitId) async {
    try {
      return await _dbHelper.getHabitCompletions(habitId);
    } catch (e) {
      print('Error getting habit completions: $e');
      return [];
    }
  }

  Future<List<HabitCompletion>> getCompletionsInRange(
    int habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      return await _dbHelper.getCompletionsInRange(habitId, startDate, endDate);
    } catch (e) {
      print('Error getting completions in range: $e');
      return [];
    }
  }


  Habit? getHabitById(int id) {
    try {
      return _habits.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Habit> getHabitsByCategory(HabitCategory category) {
    return _habits.where((h) => h.category == category).toList();
  }

  double getOverallProgress() {
    if (_habits.isEmpty) return 0.0;
    
    double totalProgress = 0.0;
    for (final habit in _habits) {
      // This is a simplified calculation - you might want to make it more sophisticated
      totalProgress += habit.isActive ? 1.0 : 0.0;
    }
    
    return totalProgress / _habits.length;
  }
}
