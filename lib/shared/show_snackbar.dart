import 'package:flutter/material.dart';

class ShowSnackbar {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
    bool isError = false,
  }) {
    if (!context.mounted) return;

    final backgroundColor =
        isError ? const Color(0xFFFFDDDD) : const Color(0xFFE8F7E6);

    final textColor =
        isError ? const Color(0xFFD32F2F) : const Color(0xFF388E3C);

    final icon =
        isError ? Icons.error_outline_rounded : Icons.check_circle_outlined;

    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color:
              isError
                  ? const Color(0xFFD32F2F).withOpacity(0.2)
                  : const Color(0xFF388E3C).withOpacity(0.2),
          width: 1,
        ),
      ),
      backgroundColor: backgroundColor,
      content: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: textColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 22, color: textColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      duration: duration,
      elevation: 0,
      showCloseIcon: true,
      closeIconColor: textColor.withOpacity(0.7),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }
}

