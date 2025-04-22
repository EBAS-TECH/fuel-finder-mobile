import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final bool isPrimary;
  final bool isIconButton;
  final VoidCallback onPressed;
  final double width;

  const OnboardingButton({
    super.key,
    required this.text,
    required this.isPrimary,
    this.isIconButton = false,
    required this.onPressed,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        child:
            isIconButton
                ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [Text(text)],
                )
                : Text(text),
      ),
    );
  }
}

