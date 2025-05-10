import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/features/auth/presentation/pages/reset_password_page.dart';
import 'package:fuel_finder/shared/lanuage_switcher.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPasswordVerifyPage extends StatefulWidget {
  final String userId;

  const ForgotPasswordVerifyPage({super.key, required this.userId});

  @override
  State<ForgotPasswordVerifyPage> createState() =>
      _ForgotPasswordVerifyPageState();
}

class _ForgotPasswordVerifyPageState extends State<ForgotPasswordVerifyPage> {
  final _pinController = TextEditingController();

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageSwitcher()],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthVerifyForgotSucess) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ResetPasswordPage(userId: widget.userId),
              ),
            );
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
                  l10n.codeVerificationTitle,
                  style: theme.textTheme.headlineLarge?.copyWith(
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: textFieldSpacing / 2),
                Text(
                  l10n.codeVerificationSubtitle,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: subtitleFontSize,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: textFieldSpacing),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    fieldHeight: 50,
                    fieldWidth: 40,
                    activeFillColor: Colors.white,
                    activeColor: AppPallete.primaryColor,
                    selectedColor: AppPallete.primaryColor,
                    inactiveColor: Colors.grey.shade300,
                  ),
                  animationDuration: const Duration(milliseconds: 300),
                  enableActiveFill: false,
                  onChanged: (value) {},
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
                              if (_pinController.text.length == 6) {
                                context.read<AuthBloc>().add(
                                  AuthVerifyForgotEvent(
                                    userId: widget.userId,
                                    code: _pinController.text.trim(),
                                  ),
                                );
                              } else {
                                ShowSnackbar.show(
                                  context,
                                  l10n.codeVerificationError,
                                );
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        vertical: isSmallScreen ? 14.0 : 16.0,
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
                              l10n.verifyButton,
                              style: TextStyle(fontSize: subtitleFontSize),
                            ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

