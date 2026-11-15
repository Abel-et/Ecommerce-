import 'dart:io';

import 'package:ecommerce/core/di/injection_container.dart';
import 'package:ecommerce/core/settings/app_settings.dart';
import 'package:ecommerce/core/session/user_session.dart';
import 'package:ecommerce/features/auth/domain/entities/user_entity.dart';
import 'package:ecommerce/features/auth/domain/entities/user_image_entity.dart';
import 'package:ecommerce/features/auth/domain/use_case/user_use_case.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _imagePicker = ImagePicker();
  final _settings = sl<AppSettings>();
  XFile? _profileImage;
  bool _isEditing = false;
  bool _isSaving = false;

  UserEntity? get _user => sl<UserSession>().currentUser;

  @override
  void initState() {
    super.initState();
    _nameController.text = _user?.fullName ?? '';
    _emailController.text = _user?.email ?? '';
    final imagePath = _user?.profileImage?.path;
    if (imagePath != null && File(imagePath).existsSync()) {
      _profileImage = XFile(imagePath);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (image != null && mounted) {
      final updatedUser = _user?.copyWith(
        profileImage: UserImageEntity(path: image.path),
      );
      if (updatedUser == null) return;

      final result = await sl<UpdateUserUseCase>()(updatedUser);
      if (!mounted) return;
      result.match(
        (failure) =>
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(failure.message))),
        (_) {
          sl<UserSession>().setUser(updatedUser);
          setState(() => _profileImage = image);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(const SnackBar(content: Text('Profile image saved.')));
        },
      );
    }
  }

  Future<void> _saveInformation() async {
    if (!_formKey.currentState!.validate() || _user == null) return;

    setState(() => _isSaving = true);
    final updatedUser = _user!.copyWith(
      fullName: _nameController.text.trim(),
      email: _emailController.text.trim(),
      profileImage: _user!.profileImage,
    );
    final result = await sl<UpdateUserUseCase>()(updatedUser);

    if (!mounted) return;
    result.match(
      (failure) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(failure.message)));
      },
      (_) {
        sl<UserSession>().setUser(updatedUser);
        setState(() => _isEditing = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile information updated.')),
        );
      },
    );
    setState(() => _isSaving = false);
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _settings,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _buildProfileHeader(),
                  const SizedBox(height: 28),
                  _buildInformationSection(),
                  const SizedBox(height: 20),
                  _buildSettingsSection(),
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      sl<UserSession>().clearUser();
                      context.goNamed('login');
                    },
                    icon: const Icon(Icons.logout),
                    label: const Text('Sign out'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader() {
    final image = _profileImage;
    return Column(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 54,
              backgroundImage: image == null
                  ? null
                  : FileImage(File(image.path)),
              child: image == null ? const Icon(Icons.person, size: 54) : null,
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton.filled(
                onPressed: _pickImage,
                icon: const Icon(Icons.camera_alt),
                tooltip: 'Upload profile image',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          _user?.fullName ?? 'Guest user',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        Text(_user?.email ?? 'Sign in to manage your profile'),
      ],
    );
  }

  Widget _buildInformationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Personal information',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                IconButton(
                  onPressed: () => setState(() => _isEditing = !_isEditing),
                  icon: Icon(_isEditing ? Icons.close : Icons.edit),
                  tooltip: _isEditing ? 'Cancel editing' : 'Edit information',
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nameController,
              enabled: _isEditing,
              decoration: const InputDecoration(
                labelText: 'Full name',
                prefixIcon: Icon(Icons.person_outline),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Enter your name'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _emailController,
              enabled: _isEditing,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email_outlined),
              ),
              validator: (value) => value == null || !value.contains('@')
                  ? 'Enter a valid email'
                  : null,
            ),
            if (_isEditing) ...[
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _isSaving ? null : _saveInformation,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save changes'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            value: _settings.notificationsEnabled,
            onChanged: _settings.setNotificationsEnabled,
            title: const Text('Notifications'),
            subtitle: const Text('Receive order and account updates'),
            secondary: const Icon(Icons.notifications_outlined),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Font size'),
            subtitle: Slider(
              value: _settings.fontScale,
              min: .85,
              max: 1.2,
              divisions: 7,
              label: '${(_settings.fontScale * 100).round()}%',
              onChanged: _settings.setFontScale,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Theme'),
            trailing: DropdownButton<ThemeMode>(
              value: _settings.themeMode,
              onChanged: (mode) {
                if (mode != null) _settings.setThemeMode(mode);
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('System'),
                ),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
