import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ExperienceFormResult {
  final String title;
  final String description;
  final Uint8List? image;

  const ExperienceFormResult({
    required this.title,
    required this.description,
    required this.image,
  });
}

class UploadExperiencePage extends StatefulWidget {
  final ValueChanged<ExperienceFormResult> onUpload;

  const UploadExperiencePage({super.key, required this.onUpload});

  @override
  State<UploadExperiencePage> createState() => _UploadExperiencePageState();
}

class _UploadExperiencePageState extends State<UploadExperiencePage> {
  final _picker = ImagePicker();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final bytes = await image.readAsBytes();
    if (!mounted) return;
    setState(() => _selectedImage = bytes);
  }

  void _uploadExperience() {
    widget.onUpload(
      ExperienceFormResult(
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        image: _selectedImage,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pengalaman berhasil diupload')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Pengalaman')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ExperienceImagePreview(image: _selectedImage, height: 180),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: _pickImage,
            icon: const Icon(Icons.upload_file),
            label: const Text('Upload Gambar Pengalaman'),
          ),
          const SizedBox(height: 24),
          ExperienceTextField(controller: _titleController, label: 'Judul'),
          ExperienceTextField(
            controller: _descriptionController,
            label: 'Deskripsi Singkat',
            maxLines: 4,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _uploadExperience,
            icon: const Icon(Icons.cloud_upload),
            label: const Text('Upload Pengalaman'),
          ),
        ],
      ),
    );
  }
}

class ExperienceTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final int maxLines;

  const ExperienceTextField({
    super.key,
    required this.controller,
    required this.label,
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
        ),
      ),
    );
  }
}

class ExperienceImagePreview extends StatelessWidget {
  final Uint8List? image;
  final double height;

  const ExperienceImagePreview({
    super.key,
    required this.image,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (image != null) {
      return Image.memory(
        image!,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return Container(
      height: height,
      width: double.infinity,
      color: Colors.blue.shade50,
      alignment: Alignment.center,
      child: Icon(Icons.image, size: 56, color: Colors.blue.shade300),
    );
  }
}
