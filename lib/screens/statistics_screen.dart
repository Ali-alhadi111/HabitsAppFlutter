import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/stat_card.dart';
import '../widgets/habit_progress_chart.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildOverviewStats(),
              const SizedBox(height: 24),
              _buildHabitsProgress(),
              const SizedBox(height: 24),
              _buildCategoryBreakdown(),
              const SizedBox(height: 24),
              _buildStreakLeaderboard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Statistics',
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Track your progress and achievements',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewStats() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.activeHabits;
        final totalHabits = habits.length;
        final completedToday = 0; // TODO: Calculate actual completions
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Total Habits',
                    value: totalHabits.toString(),
                    icon: Icons.checklist,
                    color: AppColors.primary,
                    trend: '+2 this week',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Completed Today',
                    value: completedToday.toString(),
                    icon: Icons.check_circle,
                    color: AppColors.success,
                    trend: totalHabits > 0 ? '${((completedToday / totalHabits) * 100).round()}% completion' : '0% completion',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Current Streak',
                    value: '7 days',
                    icon: Icons.local_fire_department,
                    color: AppColors.warning,
                    trend: 'Best: 21 days',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: 'Total Completions',
                    value: '156',
                    icon: Icons.trending_up,
                    color: AppColors.info,
                    trend: '+12 this week',
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildHabitsProgress() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.activeHabits;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habits Progress',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              if (habits.isEmpty)
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.analytics,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No habits to track yet',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...habits.take(5).map((habit) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: HabitProgressChart(habit: habit),
                )),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCategoryBreakdown() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.activeHabits;
        
        // Group habits by category
        final categoryCounts = <String, int>{};
        for (final habit in habits) {
          final categoryName = _getCategoryName(habit.category);
          categoryCounts[categoryName] = (categoryCounts[categoryName] ?? 0) + 1;
        }
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category Breakdown',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              if (categoryCounts.isEmpty)
                Center(
                  child: Text(
                    'No categories to display',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 200,
                  child: PieChart(
                    PieChartData(
                      sections: categoryCounts.entries.map((entry) {
                        final index = categoryCounts.keys.toList().indexOf(entry.key);
                        return PieChartSectionData(
                          color: AppColors.habitColors[index % AppColors.habitColors.length],
                          value: entry.value.toDouble(),
                          title: '${entry.value}',
                          radius: 60,
                          titleStyle: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        );
                      }).toList(),
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              ...categoryCounts.entries.map((entry) {
                final index = categoryCounts.keys.toList().indexOf(entry.key);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.habitColors[index % AppColors.habitColors.length],
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${entry.value} habits',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStreakLeaderboard() {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        final habits = habitProvider.activeHabits;
        
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Streak Leaderboard',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 20),
              if (habits.isEmpty)
                Center(
                  child: Text(
                    'No habits to display',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                    ),
                  ),
                )
              else
                ...habits.take(5).toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final habit = entry.value;
                  return FutureBuilder<int>(
                    future: habitProvider.getCurrentStreak(habit.id!),
                    builder: (context, snapshot) {
                      final streak = snapshot.data ?? 0;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: index < 3 
                              ? AppColors.habitColors[index].withOpacity(0.1)
                              : AppColors.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: index < 3 
                                ? AppColors.habitColors[index]
                                : AppColors.surfaceVariant,
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: index < 3 
                                    ? AppColors.habitColors[index]
                                    : AppColors.textTertiary,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '${index + 1}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: habit.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                _getHabitIcon(habit.icon),
                                color: habit.color,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    habit.title,
                                    style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Text(
                                    '${habit.targetCount} ${habit.unit} per day',
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: AppColors.warning,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '$streak days',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                }),
            ],
          ),
        );
      },
    );
  }

  String _getCategoryName(habitCategory) {
    switch (habitCategory.toString()) {
      case 'HabitCategory.health':
        return 'Health';
      case 'HabitCategory.fitness':
        return 'Fitness';
      case 'HabitCategory.learning':
        return 'Learning';
      case 'HabitCategory.productivity':
        return 'Productivity';
      case 'HabitCategory.mindfulness':
        return 'Mindfulness';
      case 'HabitCategory.social':
        return 'Social';
      case 'HabitCategory.creative':
        return 'Creative';
      case 'HabitCategory.other':
        return 'Other';
      default:
        return 'Other';
    }
  }

  IconData _getHabitIcon(String iconName) {
    switch (iconName) {
      case 'fitness':
        return Icons.fitness_center;
      case 'health':
        return Icons.health_and_safety;
      case 'learning':
        return Icons.school;
      case 'productivity':
        return Icons.work;
      case 'mindfulness':
        return Icons.self_improvement;
      case 'social':
        return Icons.people;
      case 'creative':
        return Icons.palette;
      case 'reading':
        return Icons.menu_book;
      case 'water':
        return Icons.water_drop;
      case 'sleep':
        return Icons.bedtime;
      case 'exercise':
        return Icons.directions_run;
      case 'meditation':
        return Icons.psychology;
      default:
        return Icons.task_alt;
    }
  }
}
