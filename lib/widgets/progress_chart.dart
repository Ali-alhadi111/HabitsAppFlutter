import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/habit.dart';
import '../providers/habit_provider.dart';
import '../utils/app_colors.dart';

class ProgressChart extends StatelessWidget {
  final Habit habit;

  const ProgressChart({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitProvider>(
      builder: (context, habitProvider, child) {
        return FutureBuilder<List<HabitCompletion>>(
          future: _getWeeklyCompletions(habitProvider),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              );
            }

            final completions = snapshot.data ?? [];
            final chartData = _prepareChartData(completions);

            return LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: AppColors.surfaceVariant,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Text(
                            days[value.toInt()],
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.surfaceVariant,
                    width: 1,
                  ),
                ),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: _getMaxY(chartData),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [
                        habit.color,
                        habit.color.withOpacity(0.3),
                      ],
                    ),
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: habit.color,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          habit.color.withOpacity(0.3),
                          habit.color.withOpacity(0.1),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
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

  Future<List<HabitCompletion>> _getWeeklyCompletions(HabitProvider habitProvider) async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    
    return await habitProvider.getCompletionsInRange(
      habit.id!,
      startOfWeek,
      endOfWeek,
    );
  }

  List<FlSpot> _prepareChartData(List<HabitCompletion> completions) {
    final spots = <FlSpot>[];
    
    // Group completions by day of week (0 = Monday, 6 = Sunday)
    final completionsByDay = <int, int>{};
    for (final completion in completions) {
      final dayOfWeek = completion.completedAt.weekday - 1; // Convert to 0-based
      completionsByDay[dayOfWeek] = (completionsByDay[dayOfWeek] ?? 0) + completion.count;
    }
    
    // Create spots for each day of the week
    for (int day = 0; day < 7; day++) {
      final count = completionsByDay[day] ?? 0;
      spots.add(FlSpot(day.toDouble(), count.toDouble()));
    }
    
    return spots;
  }

  double _getMaxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 5;
    final maxValue = spots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);
    if (maxValue.isInfinite || maxValue.isNaN) return 5;
    return (maxValue + 1).ceil().toDouble();
  }
}
