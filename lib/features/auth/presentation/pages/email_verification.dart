import 'package:flutter/material.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/pages/register_page.dart';
import 'package:fuel_finder/features/auth/presentation/pages/widgets/auth_footer.dart';
import 'package:fuel_finder/features/auth/presentation/pages/widgets/code_input_container.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({super.key});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Verification",
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "Enter a 5 digit code sent to your email",
            style: theme.textTheme.bodyMedium,
          ),
          SizedBox(height: 20),
          CodeInputContainer(),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            child: ElevatedButton(
              style: ButtonStyle(),
              onPressed: () {},
              child: Text("Verify Account"),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Back to registration page",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppPallete.primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

