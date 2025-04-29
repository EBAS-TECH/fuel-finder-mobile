import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_state.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Profile", centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 24),
            _buildUserInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserSucess) {
          final user = state.responseData["data"];
          return Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                  user["profile_pic"] ??
                      'https://avatar.iran.liara.run/public/boy?username=user',
                ),
                radius: 50,
              ),
              const SizedBox(height: 16),
              Text(
                "${user["first_name"]} ${user["last_name"]}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                user["email"],
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              const SizedBox(height: 16),
              /*   Chip(
                label: Text(
                  user["role"] ?? 'USER',
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blue,
              ), */
            ],
          );
        } else if (state is UserLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const Center(child: Icon(Icons.person, size: 80));
      },
    );
  }

  Widget _buildUserInfoCard() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserSucess) {
          final user = state.responseData["data"];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildInfoRow(
                    icon: Icons.person,
                    label: "First Name",
                    value: user["first_name"],
                    onEdit: () => _editField("First Name", user["first_name"]),
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.person_outline,
                    label: "Last Name",
                    value: user["last_name"],
                    onEdit: () => _editField("Last Name", user["last_name"]),
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.email,
                    label: "Email",
                    value: user["email"],
                    onEdit: () => _editField("Email", user["email"]),
                  ),
                  const Divider(),
                  _buildInfoRow(
                    icon: Icons.lock,
                    label: "Password",
                    value: "********",
                    onEdit: () => _editPassword(),
                  ),
                ],
              ),
            ),
          );
        }
        return const Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppPallete.primaryColor),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
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
          IconButton(
            icon: const Icon(Icons.edit, color: AppPallete.primaryColor70),
            onPressed: onEdit,
          ),
        ],
      ),
    );
  }

  void _editField(String field, String currentValue) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text("Edit $field"),
            content: TextField(
              controller: TextEditingController(text: currentValue),
              decoration: InputDecoration(hintText: "Enter new $field"),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement update logic
                  Navigator.pop(context);
                  ShowSnackbar.show(context, "$field updated successfully");
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }

  void _editPassword() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Change Password"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Current Password",
                  ),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(hintText: "New Password"),
                ),
                const SizedBox(height: 10),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: "Confirm New Password",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implement password update logic
                  Navigator.pop(context);
                  ShowSnackbar.show(context, "Password updated successfully");
                },
                child: const Text("Save"),
              ),
            ],
          ),
    );
  }
}

