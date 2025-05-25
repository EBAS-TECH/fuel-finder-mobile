import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/features/auth/presentation/pages/email_verification.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/features/auth/presentation/widgets/auth_footer.dart';
import 'package:fuel_finder/l10n/app_localizations.dart';
import 'package:fuel_finder/shared/lanuage_switcher.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageSwitcher()],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyEmail) {
            debugPrint(state.message);
            ShowSnackbar.show(context, "Verifcation code sent to your email");
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => EmailVerification(
                      userData: state.user,
                      email: _emailController.text.trim(),
                      userId: state.userId,
                      registerdVerifcation: false,
                    ),
              ),
            );
          } else if (state is AuthFailure) {
            final message =
                state.error.contains("email already exists")
                    ? "Email already registered. Please login or use a different email"
                    : state.error.contains("username already exists")
                    ? "Username already taken. Please choose a different one"
                    : state.error;

            ShowSnackbar.show(context, message, isError: true);
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            children: [
              SizedBox(height: sectionSpacing / 2),
              Text(
                l10n.registerTitle,
                style: theme.textTheme.headlineLarge?.copyWith(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: textFieldSpacing / 2),
              Text(
                l10n.registerSubtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: subtitleFontSize,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: textFieldSpacing),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: sectionSpacing),
                    _buildTextField(
                      controller: _firstNameController,
                      label: l10n.firstNameLabel,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.firstNameError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _lastNameController,
                      label: l10n.lastNameLabel,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.lastNameError;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _usernameController,
                      label: l10n.usernameLabel,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.usernameError;
                        }
                        if (value.length < 4) {
                          return l10n.usernameErrorLength;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _emailController,
                      label: l10n.emailLabel,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.emailError;
                        }
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) {
                          return l10n.emailInvalid;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _passwordController,
                      label: l10n.passwordLabel,
                      isPasswordField: true,
                      obscureText: _obscurePassword,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.passwordErrorEmpty;
                        }
                        if (value.length < 6) {
                          return l10n.passwordErrorLength;
                        }
                        final hasSpecialChar = RegExp(
                          r'[!@#$%^&*()\-_=+{};:,<.>?]',
                        ).hasMatch(value);
                        final hasLetterAndNumber = RegExp(
                          r'^(?=.*[a-zA-Z])(?=.*[0-9])',
                        ).hasMatch(value);
                        final commonPasswords = [
                          'password',
                          '123456',
                          'qwerty123',
                          'letmein',
                          'welcome',
                          'admin123',
                          'password1',
                          'abc123',
                          'football',
                          'iloveyou',
                        ];

                        String errorMessage = '';

                        if (!hasLetterAndNumber) {
                          errorMessage = l10n.passwordErrorLetterNumberCombo;
                        } else if (commonPasswords.contains(
                          value.toLowerCase(),
                        )) {
                          errorMessage = l10n.passwordErrorTooCommon;
                        } else {
                          if (!hasSpecialChar) {
                            errorMessage +=
                                (errorMessage.isNotEmpty ? '\n' : '') +
                                l10n.passwordErrorSpecialChar;
                          }
                        }

                        if (errorMessage.isNotEmpty) {
                          return errorMessage;
                        }

                        return null;
                      },
                      onToggleObscure: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                    SizedBox(height: textFieldSpacing),
                    _buildTextField(
                      controller: _confirmPasswordController,
                      label: l10n.confirmPasswordLabel,
                      obscureText: _obscureConfirmPassword,
                      isPasswordField: true,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return l10n.confirmPasswordError;
                        } else if (value == null || value.trim().isEmpty) {
                          return l10n.passwordErrorEmpty;
                        }
                        return null;
                      },
                      onToggleObscure: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    SizedBox(height: sectionSpacing),
                    SizedBox(
                      width: size.width * 0.9,
                      child: BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed:
                                state is AuthLoading ? null : _submitForm,
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
                                      l10n.registerButton,
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
                      l10n.alreadyHaveAccount,
                      l10n.login,
                      LoginPage(),
                      true,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.red),
        ),
        errorStyle: TextStyle(height: 0),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();
      final username = _usernameController.text.trim();
      final email = _emailController.text.trim();
      final password = _passwordController.text;
      final role = "DRIVER";

      context.read<AuthBloc>().add(
        AuthSignUpEvent(
          firstName: firstName,
          lastName: lastName,
          userName: username,
          email: email,
          password: password,
          role: role,
        ),
      );
    }
  }
}

