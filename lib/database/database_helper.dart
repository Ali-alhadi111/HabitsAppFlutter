import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/habit.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'habits.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Create habits table
    await db.execute('''
      CREATE TABLE habits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        category INTEGER NOT NULL,
        frequency INTEGER NOT NULL,
        reminder_hour INTEGER NOT NULL,
        reminder_minute INTEGER NOT NULL,
        reminder_days TEXT NOT NULL,
        color_value INTEGER NOT NULL,
        icon TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        is_active INTEGER NOT NULL DEFAULT 1,
        target_count INTEGER NOT NULL DEFAULT 1,
        unit TEXT DEFAULT ''
      )
    ''');

    // Create habit_completions table
    await db.execute('''
      CREATE TABLE habit_completions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        habit_id INTEGER NOT NULL,
        completed_at INTEGER NOT NULL,
        count INTEGER NOT NULL DEFAULT 1,
        notes TEXT,
        FOREIGN KEY (habit_id) REFERENCES habits (id) ON DELETE CASCADE
      )
    ''');

    // Create indexes for better performance
    await db.execute('''
      CREATE INDEX idx_habit_completions_habit_id ON habit_completions(habit_id)
    ''');
    
    await db.execute('''
      CREATE INDEX idx_habit_completions_date ON habit_completions(completed_at)
    ''');
  }

  // Habit CRUD operations
  Future<int> insertHabit(Habit habit) async {
    final db = await database;
    return await db.insert('habits', habit.toMap());
  }

  Future<List<Habit>> getAllHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<List<Habit>> getActiveHabits() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'is_active = ?',
      whereArgs: [1],
      orderBy: 'created_at DESC',
    );
    return List.generate(maps.length, (i) => Habit.fromMap(maps[i]));
  }

  Future<Habit?> getHabit(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Habit.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateHabit(Habit habit) async {
    final db = await database;
    return await db.update(
      'habits',
      habit.toMap(),
      where: 'id = ?',
      whereArgs: [habit.id],
    );
  }

  Future<int> deleteHabit(int id) async {
    final db = await database;
    // Delete related completions first
    await db.delete(
      'habit_completions',
      where: 'habit_id = ?',
      whereArgs: [id],
    );
    // Delete the habit
    return await db.delete(
      'habits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Habit completion operations
  Future<int> insertHabitCompletion(HabitCompletion completion) async {
    final db = await database;
    return await db.insert('habit_completions', completion.toMap());
  }

  Future<List<HabitCompletion>> getHabitCompletions(int habitId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_completions',
      where: 'habit_id = ?',
      whereArgs: [habitId],
      orderBy: 'completed_at DESC',
    );
    return List.generate(maps.length, (i) => HabitCompletion.fromMap(maps[i]));
  }

  Future<List<HabitCompletion>> getCompletionsForDate(
    int habitId,
    DateTime date,
  ) async {
    final db = await database;
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_completions',
      where: 'habit_id = ? AND completed_at >= ? AND completed_at < ?',
      whereArgs: [
        habitId,
        startOfDay.millisecondsSinceEpoch,
        endOfDay.millisecondsSinceEpoch,
      ],
    );
    return List.generate(maps.length, (i) => HabitCompletion.fromMap(maps[i]));
  }

  Future<int> getTotalCompletionsForDate(int habitId, DateTime date) async {
    final completions = await getCompletionsForDate(habitId, date);
    int total = 0;
    for (final completion in completions) {
      total += completion.count;
    }
    return total;
  }

  Future<List<HabitCompletion>> getCompletionsInRange(
    int habitId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'habit_completions',
      where: 'habit_id = ? AND completed_at >= ? AND completed_at <= ?',
      whereArgs: [
        habitId,
        startDate.millisecondsSinceEpoch,
        endDate.millisecondsSinceEpoch,
      ],
      orderBy: 'completed_at ASC',
    );
    return List.generate(maps.length, (i) => HabitCompletion.fromMap(maps[i]));
  }

  Future<int> deleteHabitCompletion(int id) async {
    final db = await database;
    return await db.delete(
      'habit_completions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Statistics methods
  Future<int> getCurrentStreak(int habitId) async {
    final db = await database;
    final today = DateTime.now();
    
    // Get all completions for this habit
    final completions = await getHabitCompletions(habitId);
    if (completions.isEmpty) return 0;
    
    // Sort by date (most recent first)
    completions.sort((a, b) => b.completedAt.compareTo(a.completedAt));
    
    int streak = 0;
    DateTime currentDate = today;
    
    for (final completion in completions) {
      final completionDate = DateTime(
        completion.completedAt.year,
        completion.completedAt.month,
        completion.completedAt.day,
      );
      
      if (completionDate == currentDate) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else if (completionDate == currentDate.subtract(const Duration(days: 1))) {
        streak++;
        currentDate = currentDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    
    return streak;
  }

  Future<int> getLongestStreak(int habitId) async {
    final completions = await getHabitCompletions(habitId);
    if (completions.isEmpty) return 0;
    
    // Group completions by date
    final Map<String, List<HabitCompletion>> completionsByDate = {};
    for (final completion in completions) {
      final dateKey = '${completion.completedAt.year}-${completion.completedAt.month}-${completion.completedAt.day}';
      completionsByDate[dateKey] ??= [];
      completionsByDate[dateKey]!.add(completion);
    }
    
    final sortedDates = completionsByDate.keys.toList()..sort();
    
    int longestStreak = 0;
    int currentStreak = 0;
    DateTime? lastDate;
    
    for (final dateKey in sortedDates) {
      final parts = dateKey.split('-');
      final date = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
      
      if (lastDate == null || date.difference(lastDate).inDays == 1) {
        currentStreak++;
      } else {
        longestStreak = longestStreak > currentStreak ? longestStreak : currentStreak;
        currentStreak = 1;
      }
      
      lastDate = date;
    }
    
    return longestStreak > currentStreak ? longestStreak : currentStreak;
  }
}
