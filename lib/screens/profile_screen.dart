import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final email = auth.email ?? 'User';
    final avatarPath = auth.avatarPath;
    final profileCompletion = 0.7; // Example: 70% complete
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 180,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF21CBF3)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final picker = ImagePicker();
                        final image = await picker.pickImage(
                          source: ImageSource.camera,
                          maxWidth: 600,
                        );
                        if (image != null) {
                          context.read<AuthProvider>().setAvatar(image.path);
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 12,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 56,
                          backgroundImage:
                              avatarPath != null
                                  ? FileImage(File(avatarPath))
                                  : null,
                          child:
                              avatarPath == null
                                  ? Text(
                                    email[0].toUpperCase(),
                                    style: const TextStyle(
                                      fontSize: 48,
                                      color: Colors.white,
                                    ),
                                  )
                                  : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      email,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Profile completion bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Profile Completion'),
                      Text('${(profileCompletion * 100).toInt()}%'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: profileCompletion,
                    minHeight: 8,
                    backgroundColor: Colors.grey[300],
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            // Action buttons row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _AnimatedProfileAction(
                    icon: Icons.credit_card,
                    label: 'My Cards',
                    onTap: () => context.go('/home/my-cards'),
                  ),
                  _AnimatedProfileAction(
                    icon: Icons.edit,
                    label: 'Edit Email',
                    onTap: () async {
                      final newEmail = await showDialog<String>(
                        context: context,
                        builder: (ctx) => _EmailEditDialog(initialEmail: email),
                      );
                      if (newEmail != null && newEmail.isNotEmpty) {
                        await context.read<AuthProvider>().updateEmail(
                          newEmail,
                        );
                      }
                    },
                  ),
                  _AnimatedProfileAction(
                    icon: Icons.logout,
                    label: 'Logout',
                    onTap: () {
                      context.read<AuthProvider>().logout();
                      context.go('/login');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Add more features below (e.g., activity, invite, theme switch)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activity',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.shopping_bag),
                      title: const Text('Order #12345'),
                      subtitle: const Text('Completed - 2 days ago'),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share Profile'),
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                      _AnimatedProfileAction(
                        icon: Icons.nightlight_round,
                        label: 'Toggle Theme',
                        onTap: () {
                          // Only toggle theme, do not navigate.
                          context.read<ThemeProvider>().toggleTheme();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// Animated action button widget for profile actions
class _AnimatedProfileAction extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AnimatedProfileAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_AnimatedProfileAction> createState() => _AnimatedProfileActionState();
}

class _AnimatedProfileActionState extends State<_AnimatedProfileAction>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.0,
      upperBound: 0.1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.95).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _controller,
        builder:
            (context, child) =>
                Transform.scale(scale: _scale.value, child: child),
        child: Column(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: Theme.of(
                context,
              ).colorScheme.primary.withOpacity(0.1),
              child: Icon(
                widget.icon,
                size: 28,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(widget.label, style: Theme.of(context).textTheme.bodySmall),
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
