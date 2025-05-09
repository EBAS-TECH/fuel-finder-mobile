import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/settings/locale_bloc.dart';

class LanguageSwitcher extends StatelessWidget {
  final bool isSmall;
  const LanguageSwitcher({super.key, this.isSmall = false});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<LocaleBloc>().state;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: isSmall ? 6 : 12.0),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey[850] : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: locale,
          icon: Icon(
            Icons.arrow_drop_down,
            size: isSmall ? 20 : 24,
            color: isDarkMode ? Colors.white70 : Colors.grey[700],
          ),
          dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black87,
            fontSize: isSmall ? 14 : 16,
          ),
          borderRadius: BorderRadius.circular(12),
          isDense: true,
          elevation: 2,
          items: const [
            DropdownMenuItem<Locale>(
              value: Locale('en'),
              child: Text('English'),
            ),
            DropdownMenuItem<Locale>(
              value: Locale('am'),
              child: Text('አማርኛ'),
            ),
          ],
          onChanged: (Locale? newLocale) {
            if (newLocale != null) {
              context.read<LocaleBloc>().changeLocale(newLocale);
            }
          },
        ),
      ),
    );
  }
}

