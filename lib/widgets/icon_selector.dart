import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class IconSelector extends StatelessWidget {
  final String selectedIcon;
  final Function(String) onIconSelected;

  const IconSelector({
    super.key,
    required this.selectedIcon,
    required this.onIconSelected,
  });

  @override
  Widget build(BuildContext context) {
    final icons = [
      'task_alt',
      'fitness_center',
      'health_and_safety',
      'school',
      'work',
      'self_improvement',
      'people',
      'palette',
      'menu_book',
      'water_drop',
      'bedtime',
      'directions_run',
      'psychology',
      'restaurant',
      'local_drink',
      'smoke_free',
      'phone_android',
      'computer',
      'music_note',
      'camera_alt',
      'brush',
      'code',
      'language',
      'translate',
      'sports_esports',
      'movie',
      'headphones',
      'pets',
      'eco',
      'spa',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose an icon for your habit',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: icons.length,
          itemBuilder: (context, index) {
            final icon = icons[index];
            final isSelected = icon == selectedIcon;
            
            return GestureDetector(
              onTap: () => onIconSelected(icon),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Icon(
                  _getIconData(icon),
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'task_alt':
        return Icons.task_alt;
      case 'fitness_center':
        return Icons.fitness_center;
      case 'health_and_safety':
        return Icons.health_and_safety;
      case 'school':
        return Icons.school;
      case 'work':
        return Icons.work;
      case 'self_improvement':
        return Icons.self_improvement;
      case 'people':
        return Icons.people;
      case 'palette':
        return Icons.palette;
      case 'menu_book':
        return Icons.menu_book;
      case 'water_drop':
        return Icons.water_drop;
      case 'bedtime':
        return Icons.bedtime;
      case 'directions_run':
        return Icons.directions_run;
      case 'psychology':
        return Icons.psychology;
      case 'restaurant':
        return Icons.restaurant;
      case 'local_drink':
        return Icons.local_drink;
      case 'smoke_free':
        return Icons.smoke_free;
      case 'phone_android':
        return Icons.phone_android;
      case 'computer':
        return Icons.computer;
      case 'music_note':
        return Icons.music_note;
      case 'camera_alt':
        return Icons.camera_alt;
      case 'brush':
        return Icons.brush;
      case 'code':
        return Icons.code;
      case 'language':
        return Icons.language;
      case 'translate':
        return Icons.translate;
      case 'sports_esports':
        return Icons.sports_esports;
      case 'movie':
        return Icons.movie;
      case 'headphones':
        return Icons.headphones;
      case 'pets':
        return Icons.pets;
      case 'eco':
        return Icons.eco;
      case 'spa':
        return Icons.spa;
      default:
        return Icons.task_alt;
    }
  }
}


