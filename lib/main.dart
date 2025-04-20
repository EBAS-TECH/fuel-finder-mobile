import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_theme.dart';
import 'package:fuel_finder/features/onboarding/onboarding_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(theme: AppTheme.lightThemeMode, home: OnboardingPage());
  }
}
