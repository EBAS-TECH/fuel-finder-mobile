import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class BottomNavBarItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final Function onTap;
  
  const BottomNavBarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              width: isSelected ? 80 : 30,
              height: 35,
              duration: const Duration(milliseconds: 50),
              decoration: BoxDecoration(
                color: isSelected 
                  ? isDarkMode 
                    ? AppPallete.darkCardColor 
                    : AppPallete.lightCardColor
                  : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected 
                  ? AppPallete.primaryColor 
                  : isDarkMode 
                    ? AppPallete.darkIconColor 
                    : AppPallete.lightIconColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected 
                  ? AppPallete.primaryColor 
                  : isDarkMode 
                    ? AppPallete.darkTextColor 
                    : AppPallete.lightTextColor,
                fontWeight: FontWeight.w500,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

