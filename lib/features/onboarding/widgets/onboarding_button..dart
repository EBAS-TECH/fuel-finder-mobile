import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final VoidCallback onPressed;
  final double width;
  final bool? isShade;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.isPrimary,
    required this.onPressed,
    required this.width,
    this.isShade,
  });

  @override
  Widget build(BuildContext context) {
    final ButtonStyle? buttonStyle =
        isShade == true
            ? ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE7E7E7),
              foregroundColor: Colors.green,
              elevation: 0,
              shadowColor: Colors.transparent,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            )
            : null;

    return SizedBox(
      width: width,
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}

