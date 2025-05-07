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
import 'package:fuel_finder/shared/show_snackbar.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({super.key, required this.userId});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() {
    context.read<UserBloc>().add(GetUserByIdEvent(userId: widget.userId));
  }

  Future<void> _handleLogOut(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
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
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () => _navigateToEditProfile(context),
          ),
        ],
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserFailure) {
            ShowSnackbar.show(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserSuccess) {
            final user = state.responseData["data"];
            if (user == null) {
              return _buildErrorState("User data not found");
            }
            return _buildProfileContent(user, context);
          } else if (state is UserFailure) {
            return _buildErrorState(state.error);
          }
          return const Center(child: Icon(Icons.person, size: 80));
        },
      ),
    );
  }

  Widget _buildProfileContent(Map<String, dynamic> user, BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _buildProfileHeader(user),
          const SizedBox(height: 24),
          _buildUserInfoCard(user),
          const SizedBox(height: 24),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(Map<String, dynamic> user) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppPallete.primaryColor, width: 3),
          ),
          child: ClipOval(
            child: Image.network(
              user["profile_pic"] ??
                  'https://avatar.iran.liara.run/public/boy?username=user',
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.person, size: 60),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "${user["first_name"] ?? 'No name'} ${user["last_name"] ?? ''}",
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          user["email"] ?? 'No email',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
        const SizedBox(height: 8),
        Chip(
          label: Text(
            user["role"]?.toString().toUpperCase() ?? 'USER',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: AppPallete.primaryColor,
        ),
      ],
    );
  }

  Widget _buildUserInfoCard(Map<String, dynamic> user) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildInfoItem(
              icon: Icons.person,
              label: "Username",
              value: user["username"] ?? 'Not provided',
            ),
            const Divider(height: 24),
            _buildInfoItem(
              icon: Icons.calendar_today,
              label: "Member Since",
              value:
                  user["created_at"] != null
                      ? DateTime.parse(
                        user["created_at"],
                      ).toLocal().toString().split(' ')[0]
                      : 'Unknown',
            ),
            const Divider(height: 24),
            _buildInfoItem(
              icon: Icons.verified,
              label: "Account Status",
              value: user["verified"] == true ? "Verified" : "Not Verified",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: AppPallete.primaryColor, size: 24),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.logout, color: Colors.white),
        label: const Text('Log Out', style: TextStyle(color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.redAccent,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () => _handleLogOut(context),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            "Error loading profile",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              error,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _fetchUserData,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppPallete.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text("Retry"),
          ),
        ],
      ),
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

