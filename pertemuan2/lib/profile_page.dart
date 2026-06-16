import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'edit_profile_page.dart';
import 'galery_widget.dart';
import 'upload_experience_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Uint8List? _profileImage;

  String _name = 'Faiz Khairann';
  String _role = 'Mahasiswa Teknik Informatika';
  String _about = 'Belajar Flutter Modul 2.';
  String _education = 'Universitas Pasundan';
  String _location = 'Bandung, Indonesia';
  String _contact = 'faiz@example.com';
  List<String> _skills = ['Java', 'Laravel', 'Flutter', 'Dart', 'SQL'];

  final List<ExperienceItem> _experiences = [
    const ExperienceItem(
      title: 'Praktikum Mobile',
      description:
          'Membuat aplikasi profil Flutter dengan navigasi, form, dan galeri widget.',
    ),
  ];

  void _openEditProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfilePage(
          name: _name,
          role: _role,
          about: _about,
          education: _education,
          location: _location,
          contact: _contact,
          skills: _skills,
          profileImage: _profileImage,
          onSave: (result) {
            setState(() {
              _name = result.name;
              _role = result.role;
              _about = result.about;
              _education = result.education;
              _location = result.location;
              _contact = result.contact;
              _skills = result.skills;
              _profileImage = result.image;
            });
          },
        ),
      ),
    );
  }

  void _openUploadExperience() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UploadExperiencePage(
          onUpload: (result) {
            setState(() {
              _experiences.add(
                ExperienceItem(
                  title: result.title,
                  description: result.description,
                  image: result.image,
                ),
              );
            });
          },
        ),
      ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Pengaturan'),
        content: const Text('Halaman pengaturan sedang dalam pengembangan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        actions: [
          IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            const ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Edit Profil'),
              onTap: () {
                Navigator.pop(context);
                _openEditProfile();
              },
            ),
            ListTile(
              leading: const Icon(Icons.work),
              title: const Text('Upload Pengalaman'),
              onTap: () {
                Navigator.pop(context);
                _openUploadExperience();
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),
              onTap: () {
                Navigator.pop(context);
                _showSettingsDialog();
              },
            ),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: _profileImage == null
                        ? const AssetImage('asset/kumcing.jpg')
                        : MemoryImage(_profileImage!),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(_role, style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Row(
              children: [
                Expanded(
                  child: StatBox(label: 'Post', value: '12'),
                ),
                Expanded(
                  child: StatBox(label: 'Teman', value: '128'),
                ),
                Expanded(
                  child: StatBox(label: 'Like', value: '1.2K'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SectionCard(
              icon: Icons.info,
              title: 'Tentang Saya',
              content: _about,
            ),
            SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content: _education,
            ),
            SectionCard(
              icon: Icons.location_on,
              title: 'Lokasi',
              content: _location,
            ),
            SectionCard(icon: Icons.email, title: 'Kontak', content: _contact),
            const Text(
              'Skills',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _skills
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Pengalaman',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ..._experiences.map(
              (experience) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExperienceCard(
                  image: experience.image,
                  title: experience.title,
                  description: experience.description,
                ),
              ),
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openEditProfile,
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        onDestinationSelected: (index) {
          if (index == 2) {
            _showSettingsDialog();
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],
      ),
    );
  }
}

class ExperienceItem {
  final String title;
  final String description;
  final Uint8List? image;

  const ExperienceItem({
    required this.title,
    required this.description,
    this.image,
  });
}

class StatBox extends StatelessWidget {
  final String label;
  final String value;

  const StatBox({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const SectionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content.isEmpty ? '-' : content),
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final Uint8List? image;
  final String title;
  final String description;

  const ExperienceCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ExperienceImagePreview(image: image, height: 170),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isEmpty ? 'Pengalaman' : title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(description.isEmpty ? '-' : description),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceImagePreview extends StatelessWidget {
  final Uint8List? image;
  final double height;

  const _ExperienceImagePreview({required this.image, required this.height});

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
