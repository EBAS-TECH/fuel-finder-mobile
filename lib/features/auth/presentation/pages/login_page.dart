import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/features/auth/presentation/pages/register_page.dart';
import 'package:fuel_finder/features/auth/presentation/widgets/auth_footer.dart';
import 'package:fuel_finder/features/map/presentation/pages/home_page.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isChecked = false;
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 600;
    final isMediumScreen = size.height >= 600 && size.height < 800;

    final horizontalPadding = size.width < 400 ? 16.0 : 24.0;
    final titleFontSize = size.width < 400 ? 24.0 : 28.0;
    final subtitleFontSize = size.width < 400 ? 14.0 : 16.0;
    final textFieldSpacing =
        isSmallScreen
            ? 12.0
            : isMediumScreen
            ? 16.0
            : 20.0;
    final sectionSpacing =
        isSmallScreen
            ? 16.0
            : isMediumScreen
            ? 24.0
            : 32.0;
    final buttonVerticalPadding = isSmallScreen ? 14.0 : 16.0;

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ShowSnackbar.show(context, state.message);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else if (state is AuthFailure) {
            ShowSnackbar.show(context, state.error, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: sectionSpacing / 2),
              Text(
                'Login',
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: textFieldSpacing / 2),
              Text(
                "Enter your email and password to sign in",
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: subtitleFontSize,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: textFieldSpacing),
              SizedBox(
                width: size.width * 0.9,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFEBF9F3),
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: buttonVerticalPadding,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/icons/google.png",
                        width: size.width * 0.06,
                        height: size.width * 0.06,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _userNameController,
                      label: 'Username',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Username is required';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _passwordController,
                      label: 'Password',
                      obscureText: _obscurePassword,
                      isPasswordField: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Password is required';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      onToggleObscure: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: sectionSpacing),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: AppPallete.whiteColor,
                          activeColor: AppPallete.primaryColor,
                          value: isChecked,
                          onChanged:
                              (value) => {
                                setState(() {
                                  isChecked = value ?? false;
                                }),
                              },
                        ),
                        Text("Keep me logged in"),
                        Spacer(),
                        Row(
                          children: [
                            Text(
                              "Forgot password?",
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppPallete.primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      width: size.width * 0.9,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: _submitForm,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                vertical: buttonVerticalPadding,
                              ),
                            ),

                            child:
                                state is AuthLoading
                                    ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                    : Text(
                                      'LOGIN',
                                      style: TextStyle(
                                        fontSize: subtitleFontSize,
                                      ),
                                    ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: textFieldSpacing),
                    authFooterText(
                      context,
                      "Not registerd yet? ",
                      "Register",
                      RegisterPage(),
                      false,
                    ),
                    SizedBox(height: sectionSpacing / 2),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
    bool obscureText = false,
    bool isPasswordField = false,
    TextInputType keyboardType = TextInputType.text,
    VoidCallback? onToggleObscure,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon:
            isPasswordField
                ? IconButton(
                  onPressed: onToggleObscure,
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                  ),
                )
                : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final userName = _userNameController.text.trim();
      final password = _passwordController.text.trim();

      context.read<AuthBloc>().add(
        AuthSignInEvent(userName: userName, password: password),
      );
    }
  }
}

