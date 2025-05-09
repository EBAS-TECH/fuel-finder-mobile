import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/settings/locale_bloc.dart';

class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final locale = context.watch<LocaleBloc>().state;

    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[850] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
          ),
          boxShadow: [
            if (!isDarkMode)
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Locale>(
            value: locale,
            icon: const Icon(Icons.arrow_drop_down),
            dropdownColor: isDarkMode ? Colors.grey[900] : Colors.white,
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }
}

