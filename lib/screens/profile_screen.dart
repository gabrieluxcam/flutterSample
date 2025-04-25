import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.email ?? 'User';
    final avatarPath = auth.avatarPath;
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 48,
              backgroundImage:
                  avatarPath != null ? FileImage(File(avatarPath)) : null,
              child:
                  avatarPath == null
                      ? Text(
                        email[0].toUpperCase(),
                        style: const TextStyle(fontSize: 40),
                      )
                      : null,
            ),
            const SizedBox(height: 16),
            Text(email, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<AuthProvider>().logout();
                context.go('/login');
              },
              child: const Text('Logout'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(
                  source: ImageSource.camera,
                  maxWidth: 600,
                );
                if (image != null) {
                  context.read<AuthProvider>().setAvatar(image.path);
                }
              },
              child: const Text('Change Avatar'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/home/my-cards'),
              child: const Text('My Cards'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final newEmail = await showDialog<String>(
                  context: context,
                  builder: (ctx) => _EmailEditDialog(initialEmail: email),
                );
                if (newEmail != null && newEmail.isNotEmpty) {
                  await context.read<AuthProvider>().updateEmail(newEmail);
                }
              },
              child: const Text('Edit Email'),
            ),
          ],
        ),
      ),
    );
  }
}

// Dialog for editing the user's email
class _EmailEditDialog extends StatefulWidget {
  final String initialEmail;
  const _EmailEditDialog({super.key, required this.initialEmail});

  @override
  _EmailEditDialogState createState() => _EmailEditDialogState();
}

class _EmailEditDialogState extends State<_EmailEditDialog> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Email'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(labelText: 'Email'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_controller.text),
          child: const Text('Save'),
        ),
      ],
    );
  }
}
