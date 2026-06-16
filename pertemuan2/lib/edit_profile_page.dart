import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormResult {
  final String name;
  final String role;
  final String about;
  final String education;
  final String location;
  final String contact;
  final List<String> skills;
  final Uint8List? image;

  const ProfileFormResult({
    required this.name,
    required this.role,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    required this.skills,
    required this.image,
  });
}

class EditProfilePage extends StatefulWidget {
  final String name;
  final String role;
  final String about;
  final String education;
  final String location;
  final String contact;
  final List<String> skills;
  final Uint8List? profileImage;
  final ValueChanged<ProfileFormResult> onSave;

  const EditProfilePage({
    super.key,
    required this.name,
    required this.role,
    required this.about,
    required this.education,
    required this.location,
    required this.contact,
    required this.skills,
    required this.profileImage,
    required this.onSave,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _picker = ImagePicker();
  late final TextEditingController _nameController;
  late final TextEditingController _roleController;
  late final TextEditingController _aboutController;
  late final TextEditingController _educationController;
  late final TextEditingController _locationController;
  late final TextEditingController _contactController;
  late final TextEditingController _skillsController;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _roleController = TextEditingController(text: widget.role);
    _aboutController = TextEditingController(text: widget.about);
    _educationController = TextEditingController(text: widget.education);
    _locationController = TextEditingController(text: widget.location);
    _contactController = TextEditingController(text: widget.contact);
    _skillsController = TextEditingController(text: widget.skills.join(', '));
    _selectedImage = widget.profileImage;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roleController.dispose();
    _aboutController.dispose();
    _educationController.dispose();
    _locationController.dispose();
    _contactController.dispose();
    _skillsController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() => _selectedImage = bytes);
  }

  void _saveProfile() {
    final skills = _skillsController.text
        .split(',')
        .map((skill) => skill.trim())
        .where((skill) => skill.isNotEmpty)
        .toList();

    widget.onSave(
      ProfileFormResult(
        name: _nameController.text.trim(),
        role: _roleController.text.trim(),
        about: _aboutController.text.trim(),
        education: _educationController.text.trim(),
        location: _locationController.text.trim(),
        contact: _contactController.text.trim(),
        skills: skills.isEmpty ? ['Flutter'] : skills,
        image: _selectedImage,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundImage: _selectedImage == null
                      ? const AssetImage('asset/kumcing.jpg')
                      : MemoryImage(_selectedImage!),
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.photo_camera),
                  label: const Text('Ubah Foto Profile'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ProfileTextField(controller: _nameController, label: 'Nama'),
          ProfileTextField(controller: _roleController, label: 'Status'),
          ProfileTextField(
            controller: _aboutController,
            label: 'Tentang',
            maxLines: 3,
          ),
          ProfileTextField(
            controller: _educationController,
            label: 'Pendidikan',
          ),
          ProfileTextField(controller: _locationController, label: 'Lokasi'),
          ProfileTextField(controller: _contactController, label: 'Kontak'),
          ProfileTextField(
            controller: _skillsController,
            label: 'Skills',
            helperText: 'Pisahkan dengan koma',
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _saveProfile,
            icon: const Icon(Icons.save),
            label: const Text('Simpan Profile'),
          ),
        ],
      ),
    );
  }
}

class ProfileTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? helperText;
  final int maxLines;

  const ProfileTextField({
    super.key,
    required this.controller,
    required this.label,
    this.helperText,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          helperText: helperText,
        ),
      ),
    );
  }
}
