import 'package:flutter/material.dart';
import 'package:fuel_finder/features/map/presentation/widgets/bottom_nav_bar_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void updateIndex(int index) {
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    
    final List<String> bottomNavigationBarLabels = [
      l10n.home,
      l10n.favorite,
      l10n.price,
      l10n.profile,
    ];

    final List<IconData> bottomNavigationBarIcons = [
      Icons.home,
      Icons.favorite,
      Icons.price_change,
      Icons.person,
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      width: double.infinity,
      height: 80,
      decoration: BoxDecoration(
        color: isDarkMode 
          ? AppPallete.darkBackgroundColor 
          : AppPallete.lightCardColor,
        boxShadow: [
          if (isDarkMode)
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, -5),
            )
          else
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
        ],
      ),
      child: Row(
        children: List.generate(
          bottomNavigationBarLabels.length,
          (index) => BottomNavBarItem(
            label: bottomNavigationBarLabels[index],
            icon: bottomNavigationBarIcons[index],
            isSelected: widget.currentIndex == index,
            onTap: () => updateIndex(index),
          ),
        ),
      ),
    );
  }
}

