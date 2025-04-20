import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/widgets/auth_button.dart';
import 'package:fuel_finder/features/auth/presentation/widgets/auth_input_field.dart';

class AuthCommonWidgets {
  static Widget authInputField(String hintText, String iconPath) {
    return AuthInputField(hintText: hintText, icon: Image.asset(iconPath));
  }

  static Widget authButton(String text) {
    return AuthButton(text: text);
  }

  static Widget orDividerWithGoogle(String text) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/icons/google.png"),
            SizedBox(width: 8),
            Text(text, style: TextStyle(fontSize: 15)),
          ],
        ),
        Text("Or"),
        SizedBox(height: 15),
      ],
    );
  }

  static Widget authFooterText(
    BuildContext context,
    String text,
    String actionText,
    Widget navigateTo,
    bool popCurrentPage,
  ) {
    return GestureDetector(
      onTap: () {
        if (popCurrentPage) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => navigateTo));
        }
      },
      child: RichText(
        text: TextSpan(
          text: text,
          style: TextStyle(color: AppPalette.primaryColor, fontSize: 14),
          children: [
            TextSpan(
              text: actionText,
              style: TextStyle(color: AppPalette.secondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}

