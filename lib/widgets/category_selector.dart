import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';

class CategorySelector extends StatelessWidget {
  final HabitCategory selectedCategory;
  final Function(HabitCategory) onCategorySelected;

  const CategorySelector({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: HabitCategory.values.map((category) {
        final isSelected = category == selectedCategory;
        return GestureDetector(
          onTap: () => onCategorySelected(category),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getCategoryIcon(category),
                  size: 16,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  _getCategoryName(category),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getCategoryIcon(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return Icons.health_and_safety;
      case HabitCategory.fitness:
        return Icons.fitness_center;
      case HabitCategory.learning:
        return Icons.school;
      case HabitCategory.productivity:
        return Icons.work;
      case HabitCategory.mindfulness:
        return Icons.self_improvement;
      case HabitCategory.social:
        return Icons.people;
      case HabitCategory.creative:
        return Icons.palette;
      case HabitCategory.other:
        return Icons.category;
    }
  }

  String _getCategoryName(HabitCategory category) {
    switch (category) {
      case HabitCategory.health:
        return 'Health';
      case HabitCategory.fitness:
        return 'Fitness';
      case HabitCategory.learning:
        return 'Learning';
      case HabitCategory.productivity:
        return 'Productivity';
      case HabitCategory.mindfulness:
        return 'Mindfulness';
      case HabitCategory.social:
        return 'Social';
      case HabitCategory.creative:
        return 'Creative';
      case HabitCategory.other:
        return 'Other';
    }
  }
}


