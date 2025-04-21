import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';

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
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: width,
        padding: EdgeInsets.symmetric(
          horizontal: isIconButton ? 16 : 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color:
              isPrimary
                  ? AppPallete.primaryColor
                  : AppPallete.greyColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child:
            isIconButton
                ? Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppPallete.whiteColor,
                    fontWeight: FontWeight.w600,
                  ),
                )
                : Text(
                  text,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color:
                        isPrimary
                            ? AppPallete.whiteColor
                            : AppPallete.primaryColor,
                  ),
                ),
      ),
    );
  }
}

