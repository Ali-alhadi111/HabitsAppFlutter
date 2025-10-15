import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';

class StreakWidget extends StatelessWidget {
  final Habit habit;

  const StreakWidget({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return FutureBuilder<Map<String, int>>(
          future: _getStreakData(habitProvider),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            final streakData = snapshot.data ?? {'current': 0, 'longest': 0};
            final currentStreak = streakData['current'] ?? 0;
            final longestStreak = streakData['longest'] ?? 0;

            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildStreakCard(
                        'Current Streak',
                        currentStreak.toString(),
                        Icons.local_fire_department,
                        AppColors.warning,
                        'Keep it up!',
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildStreakCard(
                        'Longest Streak',
                        longestStreak.toString(),
                        Icons.emoji_events,
                        AppColors.primary,
                        'Personal best!',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _buildStreakVisualization(currentStreak),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStreakCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String subtitle,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStreakVisualization(int currentStreak) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Streak Progress',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(7, (index) {
              final isActive = index < currentStreak;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.warning : AppColors.textTertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      isActive ? Icons.local_fire_department : Icons.circle_outlined,
                      color: isActive ? Colors.white : AppColors.textTertiary,
                      size: 16,
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 12),
          Text(
            currentStreak > 0 
                ? 'You\'re on fire! ${currentStreak} day streak!'
                : 'Start your streak today!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: currentStreak > 0 ? AppColors.warning : AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Future<Map<String, int>> _getStreakData(HabitProvider habitProvider) async {
    final currentStreak = await habitProvider.getCurrentStreak(habit.id!);
    final longestStreak = await habitProvider.getLongestStreak(habit.id!);
    
    return {
      'current': currentStreak,
      'longest': longestStreak,
    };
  }
}


