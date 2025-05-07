import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuel_finder/core/themes/app_palette.dart';
import 'package:fuel_finder/features/map/presentation/widgets/custom_app_bar.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_bloc.dart';
import 'package:fuel_finder/features/user/presentation/bloc/user_event.dart';
import 'package:fuel_finder/shared/show_snackbar.dart';

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
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: "Edit Profile", centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.alternate_email),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveChanges,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppPallete.primaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text('SAVE CHANGES'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    if (_firstNameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _usernameController.text.isEmpty) {
      ShowSnackbar.show(context, "Please fill all fields");
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

    Navigator.pop(context);
  }
}

