import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

class AuthButton extends StatelessWidget {
  final String text;
  const AuthButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppPallete.primaryColor,
        ),
        onPressed: () {},
        child: Text(
          text,
          style: TextStyle(color: AppPallete.whiteColor, fontSize: 16),
        ),
      ),
    );
  }
}

