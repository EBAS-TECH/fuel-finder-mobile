import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:fuel_finder/features/auth/presentation/bloc/auth_event.dart';
import 'package:fuel_finder/features/auth/presentation/pages/login_page.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
import 'package:fuel_finder/features/user/presentation/pages/edit_profile_page.dart';
import 'package:fuel_finder/l10n/app_localizations.dart';
import 'package:fuel_finder/shared/circular_progress_indicator.dart';
import 'package:fuel_finder/shared/lanuage_switcher.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();
  bool _isUploadingImage = false;
  File? _selectedImage;
  String? _currentProfilePicUrl;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  Future<void> _pickImage() async {
    try {
      Permission permission;
      if (Platform.isAndroid &&
          await DeviceInfoPlugin().androidInfo.then(
                (info) => info.version.sdkInt,
              ) >=
              33) {
        permission = Permission.photos;
      } else {
        permission = Permission.storage;
      }

      final status = await permission.request();

      if (status.isGranted) {
        final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 800,
          maxHeight: 800,
          imageQuality: 85,
        );

        if (pickedFile != null) {
          setState(() {
            _selectedImage = File(pickedFile.path);
          });
          await _uploadProfileImage();
        }
      } else if (status.isPermanentlyDenied) {
        await openAppSettings();
      } else {
        ShowSnackbar.show(
          context,
          AppLocalizations.of(context)?.storagePermissionDenied ??
              'Storage permission is required to select images',
          isError: true,
        );
      }
    } catch (e) {
      if (kDebugMode) print('Image picker error: $e');
      ShowSnackbar.show(
        context,
        AppLocalizations.of(context)?.imagePickerError ??
            'Failed to pick image',
        isError: true,
      );
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      context.read<UserBloc>().add(
        UploadProfilePicEvent(imageFile: _selectedImage!),
      );
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      ShowSnackbar.show(
        context,
        'Failed to upload profile picture',
        isError: true,
      );
    }
  }

  Future<void> _handleLogOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              l10n.logOut,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            content: Text(
              l10n.logOutConfirmation,
              style: TextStyle(color: theme.textTheme.bodyMedium?.color),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  l10n.cancel,
                  style: TextStyle(color: AppPallete.primaryColor),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  l10n.logOut,
                  style: TextStyle(color: Colors.redAccent),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<AuthBloc>().add(AuthLogOutEvent());
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return BlocConsumer<UserBloc, UserState>(
      listener: (context, state) {
        if (state is ImageFileUploadSucess) {
          setState(() {
            _isUploadingImage = false;
            _selectedImage = null;
          });
          ShowSnackbar.show(context, 'Profile picture updated successfully');
          _fetchUserData();
        } else if (state is ImageFileUploadFailure) {
          setState(() {
            _isUploadingImage = false;
          });
          ShowSnackbar.show(context, state.error, isError: true);
        } else if (state is UserSuccess) {
          final user = state.responseData["data"];
          if (user != null && user["profile_pic"] != null) {
            setState(() {
              _currentProfilePicUrl = user["profile_pic"];
            });
          }
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: CustomAppBar(
            title: l10n.myProfile,
            actions: [
              Container(
                padding: const EdgeInsets.only(right: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDarkMode ? theme.cardColor : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, size: 20),
                      ),
                      onPressed: () => _navigateToEditProfile(context),
                    ),
                    const SizedBox(width: 4),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: LanguageSwitcher(isSmall: true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: _ProfileContent(
            userId: widget.userId,
            isUploadingImage: _isUploadingImage,
            selectedImage: _selectedImage,
            currentProfilePicUrl: _currentProfilePicUrl,
            onPickImage: _pickImage,
            onLogOut: () => _handleLogOut(context),
            onRefresh: _fetchUserData,
          ),
        );
      },
    );
  }

  void _navigateToEditProfile(BuildContext context) {
    final state = context.read<UserBloc>().state;
    if (state is UserSuccess) {
      final user = state.responseData["data"];
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    EditProfilePage(userId: widget.userId, initialData: user),
          ),
        ).then((_) => _fetchUserData());
      }
    }
  }
}

class _ProfileContent extends StatelessWidget {
  final String userId;
  final bool isUploadingImage;
  final File? selectedImage;
  final String? currentProfilePicUrl;
  final VoidCallback onPickImage;
  final VoidCallback onLogOut;
  final VoidCallback onRefresh;

  const _ProfileContent({
    required this.userId,
    required this.isUploadingImage,
    required this.selectedImage,
    required this.currentProfilePicUrl,
    required this.onPickImage,
    required this.onLogOut,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => onRefresh(),
      child: BlocBuilder<UserBloc, UserState>(
        buildWhen: (previous, current) {
          return current is UserSuccess ||
              current is UserLoading ||
              current is UserFailure;
        },
        builder: (context, state) {
          if (state is UserLoading && state is! UserSuccess) {
            return const Center(
              child: CircularProgressIndicator(color: AppPallete.primaryColor),
            );
          } else if (state is UserSuccess) {
            final user = state.responseData["data"];
            if (user == null) {
              return _buildErrorState(context, "User data not found");
            }
            return _buildProfileContent(user, context);
          } else if (state is UserFailure) {
            return _buildErrorState(context, state.error);
          }
          return Center(child: AppLoader());
        },
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> user, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 10),
          _ProfileHeader(
            user: user,
            isUploadingImage: isUploadingImage,
            selectedImage: selectedImage,
            currentProfilePicUrl: currentProfilePicUrl,
            onPickImage: onPickImage,
          ),
          const SizedBox(height: 24),
          _buildUserInfoCard(context, user),
          const SizedBox(height: 24),
          _buildLogoutButton(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildUserInfoCard(BuildContext context, Map<String, dynamic> user) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor.withOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _buildInfoItem(
              context: context,
              icon: Icons.person_outline,
              label: l10n.username,
              value: user["username"] ?? 'Not provided',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            _buildInfoItem(
              context: context,
              icon: Icons.calendar_today_outlined,
              label: l10n.memberSince,
              value:
                  user["created_at"] != null
                      ? DateTime.parse(
                        user["created_at"],
                      ).toLocal().toString().split(' ')[0]
                      : 'Unknown',
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Divider(
                height: 1,
                color: theme.dividerColor.withOpacity(0.2),
              ),
            ),
            _buildInfoItem(
              context: context,
              icon: Icons.verified_outlined,
              label: l10n.accountStatus,
              value:
                  user["verified"] == true ? l10n.verified : l10n.notVerified,
              isVerified: user["verified"] == true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    bool isVerified = false,
  }) {
    final theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: isVerified ? Colors.green : theme.colorScheme.primary,
          size: 24,
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color:
                      isVerified
                          ? Colors.green
                          : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: Text(
          l10n.logOut,
          style: const TextStyle(color: Colors.redAccent),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Colors.redAccent),
          backgroundColor: Colors.redAccent.withOpacity(0.05),
        ),
        onPressed: onLogOut,
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 60,
              color: Colors.redAccent.withOpacity(0.8),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.errorLoadingProfile,
              style: TextStyle(
                fontSize: 18,
                color: theme.textTheme.bodyLarge?.color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onRefresh,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.tryAgain),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isUploadingImage;
  final File? selectedImage;
  final String? currentProfilePicUrl;
  final VoidCallback onPickImage;

  const _ProfileHeader({
    required this.user,
    required this.isUploadingImage,
    required this.selectedImage,
    required this.currentProfilePicUrl,
    required this.onPickImage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.colorScheme.primary.withOpacity(0.2),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipOval(
                child:
                    selectedImage != null
                        ? Image.file(selectedImage!, fit: BoxFit.cover)
                        : (currentProfilePicUrl ?? user["profile_pic"]) != null
                        ? Image.network(
                          currentProfilePicUrl ?? user["profile_pic"],
                          fit: BoxFit.cover,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  _buildDefaultAvatar(theme),
                        )
                        : _buildDefaultAvatar(theme),
              ),
            ),
            if (isUploadingImage)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onPickImage,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppPallete.primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Text(
          "${user["first_name"] ?? 'No name'} ${user["last_name"] ?? ''}",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          user["email"] ?? 'No email',
          style: TextStyle(
            fontSize: 16,
            color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: theme.colorScheme.primary.withOpacity(0.3),
            ),
          ),
          child: Text(
            user["role"]?.toString().toUpperCase() ?? 'USER',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDefaultAvatar(ThemeData theme) {
    return Container(
      color: theme.cardColor,
      child: Icon(Icons.person, size: 60, color: theme.iconTheme.color),
    );
  }
}

