import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final String emailPengirim;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.emailPengirim,
    required this.dibuatPada,
  });
}

class DetailCatatanArguments {
  final Catatan catatan;
  final VoidCallback onEdit;

  DetailCatatanArguments({required this.catatan, required this.onEdit});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      routes: {'/': (context) => const HomePage()},
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/tambah':
            return MaterialPageRoute(builder: (_) => const TambahCatatanPage());
          case '/edit':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatanAwal: catatan),
            );
          case '/detail':
            final args = settings.arguments as DetailCatatanArguments;
            return MaterialPageRoute(
              builder: (_) =>
                  DetailCatatanPage(catatan: args.catatan, onEdit: args.onEdit),
            );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> _kategoriOpsi = const [
    'Semua',
    'Kuliah',
    'Tugas',
    'Pribadi',
    'Lainnya',
  ];

  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      emailPengirim: 'mahasiswa@example.com',
      dibuatPada: DateTime.now(),
    ),
  ];

  String _filterKategori = 'Semua';

  List<Catatan> get _catatanTampil {
    if (_filterKategori == 'Semua') return _catatan;
    return _catatan.where((c) => c.kategori == _filterKategori).toList();
  }

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  Future<void> _bukaEditCatatan(Catatan catatan) async {
    final hasil = await Navigator.pushNamed(
      context,
      '/edit',
      arguments: catatan,
    );

    if (hasil is Catatan) {
      final index = _catatan.indexOf(catatan);
      if (index == -1) return;

      setState(() => _catatan[index] = hasil);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" diperbarui')),
      );
    }
  }

  void _hapusCatatan(Catatan catatan) {
    setState(() => _catatan.remove(catatan));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "${catatan.judul}" dihapus')),
    );
  }

  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final tahun = tanggal.year;
    return '$hari/$bulan/$tahun';
  }

  @override
  Widget build(BuildContext context) {
    final catatanTampil = _catatanTampil;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Mahasiswa'),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _filterKategori,
              items: _kategoriOpsi
                  .map(
                    (kategori) => DropdownMenuItem(
                      value: kategori,
                      child: Text(kategori),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _filterKategori = value);
              },
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: catatanTampil.isEmpty
          ? const _EmptyState()
          : ListView.builder(
              itemCount: catatanTampil.length,
              itemBuilder: (context, i) {
                final c = catatanTampil[i];
                return ListTile(
                  title: Text(c.judul),
                  subtitle: Text(
                    '${c.kategori} - ${c.emailPengirim} - ${_formatTanggal(c.dibuatPada)}',
                  ),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/detail',
                      arguments: DetailCatatanArguments(
                        catatan: c,
                        onEdit: () => _bukaEditCatatan(c),
                      ),
                    );
                  },
                  trailing: IconButton(
                    tooltip: 'Hapus',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _hapusCatatan(c),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Belum ada catatan', style: TextStyle(fontSize: 18)),
    );
  }
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatanAwal;

  const TambahCatatanPage({super.key, this.catatanAwal});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  final _judulCtrl = TextEditingController();
  final _isiCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();

  String _kategori = 'Kuliah';
  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  bool get _modeEdit => widget.catatanAwal != null;

  @override
  void initState() {
    super.initState();

    final catatanAwal = widget.catatanAwal;
    if (catatanAwal != null) {
      _judulCtrl.text = catatanAwal.judul;
      _isiCtrl.text = catatanAwal.isi;
      _emailCtrl.text = catatanAwal.emailPengirim;
      _kategori = catatanAwal.kategori;
    }
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  String? _validasiEmail(String? value) {
    final email = value?.trim() ?? '';
    final emailRegex = RegExp(r'^[\w\.-]+@([\w-]+\.)+[\w-]{2,}$');

    if (email.isEmpty) return 'Email pengirim wajib diisi';
    if (!emailRegex.hasMatch(email)) return 'Format email tidak valid';
    return null;
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      emailPengirim: _emailCtrl.text.trim(),
      dibuatPada: widget.catatanAwal?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_modeEdit ? 'Edit Catatan' : 'Tambah Catatan'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pengirim',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              validator: _validasiEmail,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: const Icon(Icons.save),
              label: Text(_modeEdit ? 'Update' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;
  final VoidCallback onEdit;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
    required this.onEdit,
  });

  String _formatTanggal(DateTime tanggal) {
    final hari = tanggal.day.toString().padLeft(2, '0');
    final bulan = tanggal.month.toString().padLeft(2, '0');
    final tahun = tanggal.year;
    return '$hari/$bulan/$tahun';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              catatan.judul,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Chip(label: Text(catatan.kategori)),
            const SizedBox(height: 8),
            Text(
              'Dibuat pada ${_formatTanggal(catatan.dibuatPada)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Email: ${catatan.emailPengirim}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Divider(height: 32),
            Text(
              catatan.isi,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                Navigator.pop(context);
                onEdit();
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit'),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Kembali ke Daftar'),
            ),
          ],
        ),
      ),
    );
  }
}
