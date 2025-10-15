import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class ReminderSelector extends StatelessWidget {
  final TimeOfDay reminderTime;
  final List<int> reminderDays;
  final Function(TimeOfDay) onTimeChanged;
  final Function(List<int>) onDaysChanged;

  const ReminderSelector({
    super.key,
    required this.reminderTime,
    required this.reminderDays,
    required this.onTimeChanged,
    required this.onDaysChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Time selector
        GestureDetector(
          onTap: () => _selectTime(context),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.surfaceVariant),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.access_time,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  'Reminder Time: ${_formatTime(reminderTime)}',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Days selector
        Text(
          'Reminder Days',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _buildDayButtons(),
        ),
      ],
    );
  }

  List<Widget> _buildDayButtons() {
    const days = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
    const dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    
    return List.generate(7, (index) {
      final isSelected = reminderDays.contains(index);
      return GestureDetector(
        onTap: () => _toggleDay(index),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                days[index],
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
              Text(
                dayNames[index],
                style: GoogleFonts.poppins(
                  fontSize: 8,
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _toggleDay(int day) {
    final newDays = List<int>.from(reminderDays);
    if (newDays.contains(day)) {
      newDays.remove(day);
    } else {
      newDays.add(day);
    }
    onDaysChanged(newDays);
  }

  Future<void> _selectTime(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );
    
    if (time != null) {
      onTimeChanged(time);
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}


