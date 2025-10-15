import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/streak_widget.dart';
import '../widgets/progress_chart.dart';

class HabitDetailScreen extends StatefulWidget {
  final Habit habit;

  const HabitDetailScreen({
    super.key,
    required this.habit,
  });

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                _buildHabitInfo(),
                const SizedBox(height: 20),
                _buildTabBar(),
                const SizedBox(height: 20),
                _buildTabContent(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _completeHabit,
        backgroundColor: widget.habit.color,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: widget.habit.color,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.habit.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.habit.color,
                widget.habit.color.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getHabitIcon(widget.habit.icon),
                    size: 48,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.habit.description,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: _editHabit,
          icon: const Icon(Icons.edit, color: Colors.white),
        ),
        IconButton(
          onPressed: _deleteHabit,
          icon: const Icon(Icons.delete, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildHabitInfo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Category',
                  _getCategoryName(widget.habit.category),
                  Icons.category,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  'Frequency',
                  _getFrequencyName(widget.habit.frequency),
                  Icons.repeat,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  'Target',
                  '${widget.habit.targetCount} ${widget.habit.unit}',
                  Icons.flag,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoCard(
                  'Reminder',
                  _formatTime(widget.habit.reminderTime),
                  Icons.notifications,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: widget.habit.color,
            size: 20,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildTabButton('Progress', 0),
          ),
          Expanded(
            child: _buildTabButton('Streaks', 1),
          ),
          Expanded(
            child: _buildTabButton('History', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, int index) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected ? widget.habit.color : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildTabContent() {
    switch (_selectedTabIndex) {
      case 0:
        return _buildProgressTab();
      case 1:
        return _buildStreaksTab();
      case 2:
        return _buildHistoryTab();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildProgressTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            'Weekly Progress',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: ProgressChart(habit: widget.habit),
          ),
        ],
      ),
    );
  }

  Widget _buildStreaksTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        children: [
          StreakWidget(habit: widget.habit),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
            'Recent Completions',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Consumer<HabitProvider>(
            builder: (context, habitProvider, child) {
              return FutureBuilder<List<HabitCompletion>>(
                future: habitProvider.getHabitCompletions(widget.habit.id!),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                      ),
                    );
                  }

                  final completions = snapshot.data ?? [];
                  if (completions.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          const SizedBox(height: 40),
                          Icon(
                            Icons.history,
                            size: 48,
                            color: AppColors.textTertiary,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No completions yet',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: completions.take(10).length,
                    itemBuilder: (context, index) {
                      final completion = completions[index];
                      return ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: widget.habit.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.check,
                            color: widget.habit.color,
                            size: 16,
                          ),
                        ),
                        title: Text(
                          DateFormat('MMM dd, yyyy').format(completion.completedAt),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: Text(
                          DateFormat('h:mm a').format(completion.completedAt),
                          style: GoogleFonts.poppins(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        trailing: Text(
                          '${completion.count} ${widget.habit.unit}',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: widget.habit.color,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  void _completeHabit() {
    context.read<HabitProvider>().completeHabit(widget.habit.id!);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Great job! You completed "${widget.habit.title}"'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _editHabit() {
    // TODO: Navigate to edit habit screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit functionality coming soon!'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _deleteHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Habit',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete "${widget.habit.title}"? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<HabitProvider>().deleteHabit(widget.habit.id!);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Habit "${widget.habit.title}" deleted'),
                  backgroundColor: AppColors.error,
                ),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: AppColors.error),
            ),
          ),
        ],
      ),
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

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}


