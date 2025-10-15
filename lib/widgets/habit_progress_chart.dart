import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';

class HabitProgressChart extends StatelessWidget {
  final Habit habit;

  const HabitProgressChart({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return FutureBuilder<int>(
          future: habitProvider.getHabitCompletionsForDate(
            habit.id!,
            DateTime.now(),
          ),
          builder: (context, snapshot) {
            final completedToday = snapshot.data ?? 0;
            final progress = habit.targetCount > 0 
                ? (completedToday / habit.targetCount).clamp(0.0, 1.0)
                : (completedToday > 0 ? 1.0 : 0.0);

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: habit.color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getHabitIcon(habit.icon),
                      color: habit.color,
                      size: 20,
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
                        const SizedBox(height: 4),
                        Text(
                          '$completedToday/${habit.targetCount} ${habit.unit}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        LinearProgressIndicator(
                          value: progress,
                          backgroundColor: Colors.white,
                          valueColor: AlwaysStoppedAnimation<Color>(habit.color),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${(progress * 100).round().clamp(0, 100)}%',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: habit.color,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
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
