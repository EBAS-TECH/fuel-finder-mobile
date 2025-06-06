import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_state.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/l10n/app_localizations.dart';
import 'package:fuel_finder/shared/lanuage_switcher.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class EmailVerification extends StatefulWidget {
  final bool? registerdVerifcation;
  final String email;
  final String userId;
  final Map<String, dynamic> userData;

  const EmailVerification({
    super.key,
    this.registerdVerifcation = false,
    required this.email,
    required this.userId,
    required this.userData,
  });

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  late final TextEditingController _pinController;
  Timer? _resendTimer;
  int _resendTimeout = 60;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    if (!mounted) return;

    setState(() {
      _canResend = false;
      _resendTimeout = 60;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendTimeout > 0) {
        setState(() {
          _resendTimeout--;
        });
      } else {
        setState(() {
          _canResend = true;
        });
        timer.cancel();
      }
    });
  }

  void _handleResendCode() {
    if (!_canResend || !mounted) return;

    context.read<AuthBloc>().add(AuthResendCodeEvent(userId: widget.userId));
    _startResendTimer();
  }

  void _verifyEmail() {
    if (!mounted || _isVerifying) return;

    final code = _pinController.text.trim();
    if (code.isEmpty || code.length != 6) {
      final l10n = AppLocalizations.of(context)!;
      ShowSnackbar.show(context, l10n.invalidCode);
      return;
    }

    setState(() {
      _isVerifying = true;
    });

    context.read<AuthBloc>().add(
      AuthVerifyEmailEvent(userId: widget.userId, token: code),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: const [LanguageSwitcher()],
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (!mounted) return;

          if (state is AuthSuccess) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ShowSnackbar.show(context, state.message);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              }
            });
          } else if (state is ResendCodeSuccess) {
            ShowSnackbar.show(context, state.message);
          } else if (state is AuthFailure) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _isVerifying = false;
                });
                ShowSnackbar.show(context, state.error);
              }
            });
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.05),
                Icon(
                  Icons.mark_email_unread_outlined,
                  size: 72,
                  color: AppPallete.primaryColor,
                ),
                const SizedBox(height: 24),
                Text(
                  widget.registerdVerifcation == true
                      ? l10n.verifyEmailTitleUnverified
                      : l10n.verifyEmailTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.registerdVerifcation == true
                      ? l10n.mustVerifyEmail
                      : l10n.verificationCodeSent,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
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
                  onCompleted: (code) {
                    if (mounted) {
                      _verifyEmail();
                    }
                  },
                  onChanged: (value) {},
                  beforeTextPaste: (text) => true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: AppPallete.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    onPressed: _isVerifying ? null : _verifyEmail,
                    child:
                        _isVerifying
                            ? const CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            )
                            : Text(
                              l10n.verifyAccount,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.didNotReceiveCode,
                      style: theme.textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: _canResend ? _handleResendCode : null,
                      child: Text(
                        _canResend
                            ? l10n.resend
                            : "${l10n.resend} $_resendTimeout",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color:
                              _canResend
                                  ? AppPallete.primaryColor
                                  : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    if (widget.registerdVerifcation == true) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                        (route) => false,
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(
                    widget.registerdVerifcation == true
                        ? l10n.backToLogin
                        : l10n.backToRegistration,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppPallete.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

