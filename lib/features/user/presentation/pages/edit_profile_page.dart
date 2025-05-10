import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
import 'package:fuel_finder/shared/circular_progress_indicator.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  final Map<String, dynamic> initialData;

  const EditProfilePage({
    super.key,
    required this.userId,
    required this.initialData,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _usernameController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;

  bool _showPasswordSection = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(
      text: widget.initialData["first_name"] ?? '',
    );
    _lastNameController = TextEditingController(
      text: widget.initialData["last_name"] ?? '',
    );
    _usernameController = TextEditingController(
      text: widget.initialData["username"] ?? '',
    );
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state is UserLoading) {
          AppLoader();
        } else if (state is UserUpdated) {
          ShowSnackbar.show(
            context,
            localizations?.profileUpdateSuccess ??
                'Profile updated successfully',
          );
        } else if (state is PasswordChanged) {
          ShowSnackbar.show(
            context,
            localizations?.passwordChangeSuccess ??
                'Password changed successfully',
          );
          context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
          setState(() {
            _showPasswordSection = false;
            _currentPasswordController.clear();
            _newPasswordController.clear();
            _confirmPasswordController.clear();
          });
        } else if (state is PasswordChangeError) {
          ShowSnackbar.show(context, state.message, isError: true);
        } else if (state is UserError) {
          ShowSnackbar.show(context, state.message, isError: true);
        } else if (state is UserValidationError) {
          ShowSnackbar.show(context, state.message, isError: true);
        } else if (state is UserConflictError) {
          ShowSnackbar.show(context, state.message, isError: true);
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          title: localizations?.editProfileTitle ?? 'Edit Profile',
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 16),
              _buildProfileInfoSection(localizations),
              const SizedBox(height: 24),
              _buildPasswordSection(localizations),
              const SizedBox(height: 24),
              _buildSaveButton(localizations),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfoSection(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.profileInformation ?? 'Profile Information',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppPallete.primaryColor,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _firstNameController,
          decoration: InputDecoration(
            labelText: localizations?.firstNameLabel ?? 'First Name',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _lastNameController,
          decoration: InputDecoration(
            labelText: localizations?.lastNameLabel ?? 'Last Name',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.person_outline),
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: localizations?.usernameLabel ?? 'Username',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.alternate_email),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordSection(AppLocalizations? localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.changePassword ?? 'Change Password',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppPallete.primaryColor,
              ),
            ),
            Transform.scale(
              scale: 0.6,
              child: Switch(
                value: _showPasswordSection,
                onChanged: (value) {
                  setState(() {
                    _showPasswordSection = value;
                    if (!value) {
                      _currentPasswordController.clear();
                      _newPasswordController.clear();
                      _confirmPasswordController.clear();
                    }
                  });
                },
                activeColor: AppPallete.primaryColor,
              ),
            ),
          ],
        ),
        if (_showPasswordSection) ...[
          const SizedBox(height: 16),
          TextFormField(
            controller: _currentPasswordController,
            obscureText: _obscureCurrentPassword,
            decoration: InputDecoration(
              labelText: localizations?.currentPassword ?? 'Current Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureCurrentPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureCurrentPassword = !_obscureCurrentPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNewPassword,
            decoration: InputDecoration(
              labelText: localizations?.newPassword ?? 'New Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureNewPassword = !_obscureNewPassword;
                  });
                },
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              labelText:
                  localizations?.confirmNewPassword ?? 'Confirm New Password',
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _obscureConfirmPassword = !_obscureConfirmPassword;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value != _newPasswordController.text) {
                return localizations?.passwordsDontMatch ??
                    'Passwords do not match';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            localizations?.passwordRequirement ??
                'Password must be at least 6 characters long',
            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ],
    );
  }

  Widget _buildSaveButton(AppLocalizations? localizations) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: state is UserLoading ? null : _saveChanges,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppPallete.primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child:
                state is UserLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(localizations?.saveChanges ?? 'SAVE CHANGES'),
          ),
        );
      },
    );
  }

  void _saveChanges() {
    final localizations = AppLocalizations.of(context);

    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ShowSnackbar.show(
        context,
        localizations?.fillAllFields ?? "Please fill all profile fields",
        isError: true,
      );
      return;
    }

    context.read<UserBloc>().add(
      UpdateUserByIdEvent(
        _firstNameController.text,
        _lastNameController.text,
        _usernameController.text,
        widget.userId,
      ),
    );

    if (_showPasswordSection) {
      _handlePasswordChange();
    }
  }

  void _handlePasswordChange() {
    final localizations = AppLocalizations.of(context);

    if (_currentPasswordController.text.isEmpty ||
        _newPasswordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      ShowSnackbar.show(
        context,
        localizations?.fillAllFields ?? "Please fill all password fields",
        isError: true,
      );
      return;
    }

    if (_newPasswordController.text.length < 6) {
      ShowSnackbar.show(
        context,
        localizations?.passwordTooShort ??
            "Password must be at least 6 characters long",
        isError: true,
      );
      return;
    }

    if (_newPasswordController.text != _confirmPasswordController.text) {
      ShowSnackbar.show(
        context,
        localizations?.passwordsDontMatch ?? "New passwords do not match",
        isError: true,
      );
      return;
    }

    context.read<UserBloc>().add(
      ChangePasswordEvent(
        oldPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      ),
    );
  }
}

