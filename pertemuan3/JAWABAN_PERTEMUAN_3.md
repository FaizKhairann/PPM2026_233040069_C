# Jawaban Pertemuan 3

## Progress Latihan

Kode `lib/latihan/latihan.dart` sudah menyelesaikan Langkah 1 sampai Langkah 6.2:

- HomePage sudah menjadi StatefulWidget.
- List catatan berubah dengan setState.
- Form tambah catatan sudah memakai Form, TextFormField, validator, dan TextEditingController.
- Controller sudah dibersihkan dengan dispose.
- Navigasi sudah memakai named route.
- TambahCatatanPage mengirim Catatan baru dengan Navigator.pop.
- HomePage menangkap hasil form dan menambahkannya ke list.
- DetailCatatanPage menerima data Catatan lewat arguments route.
- HomePage punya empty state, tombol hapus, dan tanggal.

## Tugas Mandiri

Semua pilihan tugas mandiri dikerjakan.

File tugas: `lib/tugas/tugas.dart`

Implementasi:

- Fitur Edit Catatan: halaman tambah digunakan ulang untuk mode edit, field terisi data lama, dan hasil simpan memperbarui item lama.
- Dropdown kategori ditambahkan di AppBar Home.
- Opsi filter: Semua, Kuliah, Tugas, Pribadi, Lainnya.
- ListView hanya menampilkan catatan sesuai kategori yang dipilih.
- Jika hasil filter kosong, halaman menampilkan empty state.
- Validasi lanjutan: field Email Pengirim ditambahkan dan divalidasi dengan regex format email.

## Pertanyaan Refleksi

1. StatelessWidget dipakai untuk tampilan yang datanya tidak berubah dari dalam widget, contohnya halaman detail catatan. StatefulWidget dipakai saat data bisa berubah, contohnya HomePage yang list catatannya bisa bertambah atau berkurang.

2. setState dipakai untuk memberi tahu Flutter bahwa ada data yang berubah dan UI perlu dibangun ulang. Kalau lupa memanggil setState, data bisa berubah di memori tetapi tampilan tidak ikut refresh.

3. GlobalKey<FormState> berfungsi untuk mengakses state dari Form, misalnya menjalankan validate. TextEditingController hanya membaca atau mengubah isi field, tetapi tidak mengelola validasi seluruh Form.

4. TextEditingController perlu di-dispose karena controller menyimpan resource. Kalau tidak dibersihkan saat widget hilang, aplikasi bisa mengalami memory leak.

5. Navigator.push dipakai untuk membuka halaman dengan route langsung seperti MaterialPageRoute. Navigator.pushNamed dipakai untuk membuka halaman berdasarkan nama route yang sudah didaftarkan, sehingga struktur navigasi lebih rapi.

6. Data dikirim balik dari halaman B ke A dengan Navigator.pop(context, value). Di halaman A, hasilnya ditangkap memakai await Navigator.push atau await Navigator.pushNamed.

7. mounted perlu dicek setelah await karena widget bisa saja sudah tidak aktif ketika proses async selesai. Kalau context dipakai saat widget sudah disposed, aplikasi bisa error.
