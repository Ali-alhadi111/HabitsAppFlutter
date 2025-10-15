import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../utils/app_colors.dart';

class FrequencySelector extends StatelessWidget {
  final HabitFrequency selectedFrequency;
  final Function(HabitFrequency) onFrequencySelected;

  const FrequencySelector({
    super.key,
    required this.selectedFrequency,
    required this.onFrequencySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: HabitFrequency.values.map((frequency) {
        final isSelected = frequency == selectedFrequency;
        return GestureDetector(
          onTap: () => onFrequencySelected(frequency),
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _getFrequencyIcon(frequency),
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getFrequencyName(frequency),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        _getFrequencyDescription(frequency),
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  IconData _getFrequencyIcon(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return Icons.today;
      case HabitFrequency.weekly:
        return Icons.date_range;
      case HabitFrequency.monthly:
        return Icons.calendar_month;
    }
  }

  String _getFrequencyName(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Daily';
      case HabitFrequency.weekly:
        return 'Weekly';
      case HabitFrequency.monthly:
        return 'Monthly';
    }
  }

  String _getFrequencyDescription(HabitFrequency frequency) {
    switch (frequency) {
      case HabitFrequency.daily:
        return 'Complete this habit every day';
      case HabitFrequency.weekly:
        return 'Complete this habit once per week';
      case HabitFrequency.monthly:
        return 'Complete this habit once per month';
    }
  }
}


