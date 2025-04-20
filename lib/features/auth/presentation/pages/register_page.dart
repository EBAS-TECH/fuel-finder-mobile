import 'package:flutter/material.dart';
import 'package:fuel_finder/features/auth/presentation/widgets/auth_common_widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Create Account",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            Text(
              "Enter your email and create a password to sign up!",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 10),
            AuthCommonWidgets.orDividerWithGoogle("Sign up with google"),
            SizedBox(height: 10),
            AuthCommonWidgets.authInputField(
              "First Name",
              "assets/icons/profile.png",
            ),
            SizedBox(height: 10),
            AuthCommonWidgets.authInputField(
              "Last Name",
              "assets/icons/profile.png",
            ),
            SizedBox(height: 10),
            AuthCommonWidgets.authInputField("Email", "assets/icons/mail.png"),
            SizedBox(height: 10),
            AuthCommonWidgets.authInputField(
              "Password",
              "assets/icons/password.png",
            ),
            SizedBox(height: 10),
            AuthCommonWidgets.authInputField(
              "Confirm Password",
              "assets/icons/password.png",
            ),
            SizedBox(height: 10),
            AuthCommonWidgets.authButton("SIGN UP"),
            SizedBox(height: 20),
            /* AuthCommonWidgets.authFooterText(context,
                "Already have an account? ", "Sign in", LoginScreen(), true), */
          ],
        ),
      ),
    );
  }
}

