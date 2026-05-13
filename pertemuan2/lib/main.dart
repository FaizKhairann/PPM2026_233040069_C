import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text('Menu', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Beranda')),
            ListTile(leading: Icon(Icons.person), title: Text('Profil')),
            ListTile(leading: Icon(Icons.settings), title: Text('Pengaturan')),
            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),
              onTap: () {
                Navigator.pop(context); // tutup drawer dulu
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GalleryHome()),
                );
              },
            ),

          ],
        ),
      ),
      // --- PENEMPATAN LANGKAH 4 (BODY) ---
      body: SingleChildScrollView( // [cite: 1408]
        padding: const EdgeInsets.all(16), // [cite: 1409]
        child: Column( // [cite: 1410]
          crossAxisAlignment: CrossAxisAlignment.stretch, // [cite: 1411]
          children: [
            const Center(
              child: Column(
                children: [
                  CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)), // [cite: 1420]
                  SizedBox(height: 12), // [cite: 1425]
                  Text('Faiz Khairann', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), // [cite: 1427]
                  Text('Mahasiswa Teknik Informatika', style: TextStyle(color: Colors.grey)), // [cite: 1431]
                ],
              ),
            ),
            const SizedBox(height: 24), // [cite: 1433]
            const Row( // [cite: 1435]
              children: [
                Expanded(child: StatBox(label: 'Post', value: '12')), // [cite: 1437]
                Expanded(child: StatBox(label: 'Teman', value: '128')), // [cite: 1437]
                Expanded(child: StatBox(label: 'Like', value: '1.2K')), // [cite: 1437]
              ],
            ),
            const SizedBox(height: 24), // [cite: 1441]
            const SectionCard(icon: Icons.info, title: 'Tentang Saya', content: 'Belajar Flutter Modul 2.'), // [cite: 1443]
            const SectionCard(icon: Icons.school, title: 'Pendidikan', content: 'Universitas Pasundan'), // [cite: 1449]
            const SizedBox(height: 80), // [cite: 1465]
          ],
        ),
      ),
      // --- AKHIR BODY ---
      floatingActionButton: FloatingActionButton( // [cite: 1332]
        onPressed: () {},
        child: const Icon(Icons.edit),
      ),
      bottomNavigationBar: BottomNavigationBar( // [cite: 1336]
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
      ),
    ); // Penutup Scaffold
  }
} // <--- TUTUP KURUNG CLASS PROFILEPAGE

// --- TARUH HELPER WIDGET DI LUAR CLASS (PALING BAWAH) ---

class StatBox extends StatelessWidget { // [cite: 1470]
  final String label;
  final String value;
  const StatBox({super.key, required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // [cite: 1478]
        Text(label, style: const TextStyle(color: Colors.grey)), // [cite: 1482]
      ],
    );
  }
}

class SectionCard extends StatelessWidget { // [cite: 1487]
  final IconData icon;
  final String title;
  final String content;
  const SectionCard({super.key, required this.icon, required this.title, required this.content});
  @override
  Widget build(BuildContext context) {
    return Card( // [cite: 1494]
      margin: const EdgeInsets.only(bottom: 12), // [cite: 1495]
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(content),
      ),
    );
  }
}

class GalleryHome extends StatelessWidget { // [cite: 1547]
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [ // [cite: 1551]
      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')), // [cite: 1566]
      body: ListView.separated( // [cite: 1567]
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(height: 8),
        itemBuilder: (context, i) {
          final (name, icon, color) = categories[i]; // [cite: 1572]
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(icon, color: Colors.white),
              ),
              title: Text(name),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => CategoryPage(name: name)), // [cite: 1583]
                );
              },
            ),
          );
        },
      ),
    );
  }
}

//CLASS CATEGORYPAGE
class CategoryPage extends StatelessWidget { // [cite: 1591]
  final String name;
  const CategoryPage({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (name) { // [cite: 1597]
      case 'Display':
        body = const _DisplayDemo(); // [cite: 1600]
        break;
      default:
        body = Center(child: Text('Konten $name belum dibuat bang')); // [cite: 1612]
    }

    return Scaffold(
      appBar: AppBar(title: Text(name)), // [cite: 1614]
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    );
  }
}

//CLASS DISPLAY
class _DisplayDemo extends StatelessWidget {
  const _DisplayDemo();
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text('Card', style: TextStyle(fontWeight: FontWeight.bold)),
    const Card(
    child: ListTile(
    leading: Icon(Icons.album),
    title: Text('Judul Item'),
    subtitle: Text('Sub-judul'),
    ),
    ),
    const SizedBox(height: 16),
    const Text('Chip', style: TextStyle(fontWeight: FontWeight.bold)),
    Wrap(
    spacing: 8,
    children: const [
      Chip(label: Text('Flutter')),
      Chip(label: Text('Dart')),
      Chip(label: Text('Mobile')),
    ],
    ),
          const SizedBox(height: 16),
          const Text('Divider', style: TextStyle(fontWeight: FontWeight.bold)),
          const Divider(thickness: 2),
          const SizedBox(height: 16),
          const Text('CircleAvatar & Icon',
              style: TextStyle(fontWeight: FontWeight.bold)),
          Row(children: const [
            CircleAvatar(child: Text('A')),
            SizedBox(width: 12),
            CircleAvatar(backgroundColor: Colors.green, child: Icon(Icons.check)),
            SizedBox(width: 12),
            Icon(Icons.star, color: Colors.amber, size: 40),
          ]),
        ],
    );
  }
}

class _InputDemo extends StatefulWidget {
  const _InputDemo();
  @override
  State<_InputDemo> createState() => _InputDemoState();
}
class _InputDemoState extends State<_InputDemo> {
  bool _checked = false;
  bool _switched = true;
  double _slider = 0.5;
  String? _dropdown = 'Apel';
  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        const Text('TextField'),
    const SizedBox(height: 4),
    const TextField(
    decoration: InputDecoration(
    border: OutlineInputBorder(),
    labelText: 'Nama',
    hintText: 'Ketik nama Anda',
    ),
    ),
    const SizedBox(height: 16),
    CheckboxListTile(
    title: const Text('Checkbox'),
    value: _checked,
      onChanged: (v) => setState(() => _checked = v ?? false),
    ),
          SwitchListTile(
            title: const Text('Switch'),
            value: _switched,
            onChanged: (v) => setState(() => _switched = v),
          ),
          const Text('Slider'),
          Slider(value: _slider, onChanged: (v) => setState(() => _slider = v)),
          const SizedBox(height: 8),
          const Text('Dropdown'),
          DropdownButton<String>(
            value: _dropdown,
            items: ['Apel', 'Jeruk', 'Mangga']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (v) => setState(() => _dropdown = v),
          ),
        ],
    );
  }
}