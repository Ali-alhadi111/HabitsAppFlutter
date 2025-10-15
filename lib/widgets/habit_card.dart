import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';

class HabitCard extends StatefulWidget {
  final Habit habit;
  final DateTime selectedDate;
  final VoidCallback onTap;
  final VoidCallback onComplete;

  const HabitCard({
    super.key,
    required this.habit,
    required this.selectedDate,
    required this.onTap,
    required this.onComplete,
  });

  @override
  State<HabitCard> createState() => _HabitCardState();
}

class _HabitCardState extends State<HabitCard> {
  bool _isCompleting = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return FutureBuilder<int>(
          future: habitProvider.getHabitCompletionsForDate(
            widget.habit.id!,
            widget.selectedDate,
          ),
          builder: (context, snapshot) {
            final completedCount = snapshot.data ?? 0;
            final isCompleted = completedCount >= widget.habit.targetCount;
            final progress = widget.habit.targetCount > 0 
                ? (completedCount / widget.habit.targetCount).clamp(0.0, 1.0)
                : (completedCount > 0 ? 1.0 : 0.0);

            return GestureDetector(
              onTap: widget.onTap,
              child: Container(
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
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: widget.habit.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _getHabitIcon(widget.habit.icon),
                            color: widget.habit.color,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.habit.title,
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (widget.habit.description.isNotEmpty)
                                Text(
                                  widget.habit.description,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                        if (isCompleted)
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: const BoxDecoration(
                              color: AppColors.success,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (widget.habit.targetCount > 1) ...[
                      Row(
                        children: [
                          Text(
                            'Progress: $completedCount/${widget.habit.targetCount} ${widget.habit.unit}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${(progress * 100).round().clamp(0, 100)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: AppColors.surfaceVariant,
                        valueColor: AlwaysStoppedAnimation<Color>(widget.habit.color),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Row(
                      children: [
                        Expanded(
                          child: _buildStreakInfo(habitProvider),
                        ),
                        const SizedBox(width: 12),
                        _buildCompleteButton(isCompleted),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStreakInfo(HabitProvider habitProvider) {
    return FutureBuilder<int>(
      future: habitProvider.getCurrentStreak(widget.habit.id!),
      builder: (context, snapshot) {
        final streak = snapshot.data ?? 0;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.local_fire_department,
                size: 16,
                color: AppColors.warning,
              ),
              const SizedBox(width: 4),
              Text(
                '$streak day streak',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCompleteButton(bool isCompleted) {
    return GestureDetector(
      onTap: _isCompleting ? null : () => _handleComplete(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isCompleted 
              ? AppColors.success 
              : widget.habit.color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: _isCompleting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isCompleted ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isCompleted ? 'Done' : 'Complete',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Future<void> _handleComplete() async {
    setState(() {
      _isCompleting = true;
    });

    try {
      await context.read<HabitProvider>().completeHabit(widget.habit.id!);
      widget.onComplete();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error completing habit: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCompleting = false;
        });
      }
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
