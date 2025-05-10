import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/shared/lanuage_switcher.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ResetPasswordPage extends StatefulWidget {
  final String userId;

  const ResetPasswordPage({super.key, required this.userId});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSetNewPasswordSucess) {
            ShowSnackbar.show(context, state.message);
            Navigator.popUntil(context, (route) => route.isFirst);
          } else if (state is AuthFailure) {
            ShowSnackbar.show(context, state.error, isError: true);
          }
        },

        builder: (context, state) {
          final isLoading = state is AuthLoading;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              children: [
                Image.asset("assets/images/logo.png", width: size.width * 0.5),
                Text(
                  l10n.resetPasswordTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: textFieldSpacing / 2),
                Text(
                  l10n.resetPasswordSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: subtitleFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: textFieldSpacing),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: sectionSpacing),
                      _buildTextField(
                        context,
                        controller: _passwordController,
                        label: l10n.newPasswordLabel,
                        obscureText: _obscurePassword,
                        isPasswordField: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.passwordErrorEmpty;
                          }
                          if (value.length < 6) {
                            return l10n.passwordErrorLength;
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
                        context,
                        controller: _confirmPasswordController,
                        label: l10n.confirmNewPasswordLabel,
                        obscureText: _obscureConfirmPassword,
                        isPasswordField: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.confirmPasswordError;
                          }
                          if (value != _passwordController.text) {
                            return l10n.confirmPasswordError;
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
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : () {
                                    FocusScope.of(context).unfocus();
                                    if (_formKey.currentState!.validate()) {
                                      context.read<AuthBloc>().add(
                                        AuthSetNewPasswordEvent(
                                          userId: widget.userId,
                                          newPassword:
                                              _passwordController.text.trim(),
                                        ),
                                      );
                                    }
                                  },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: buttonVerticalPadding,
                            ),
                          ),
                          child:
                              isLoading
                                  ? CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                  : Text(
                                    l10n.resetPasswordButton,
                                    style: TextStyle(
                                      fontSize: subtitleFontSize,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context, {
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
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
        errorStyle: const TextStyle(height: 0),
      ),
    );
  }
}

