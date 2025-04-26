import 'package:flutter/material.dart';

class FavoritesShimmer extends StatelessWidget {
  const FavoritesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color baseColor =
        isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final Color highlightColor =
        isDark ? Colors.grey.shade700 : Colors.grey.shade100;
    final Color blockColor = isDark ? Colors.grey.shade900 : Colors.white;

    return Card(
      color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      
    );
  }
}

