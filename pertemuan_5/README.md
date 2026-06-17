# pertemuan_5 - Catatan Mahasiswa (REST API + CRUD)

Mini app Flutter untuk praktikum Pertemuan 5. Data catatan disimpan di server
Laravel melalui REST API, sehingga bisa diakses dari banyak device.

## Materi

1. `package:http` untuk `GET`, `POST`, `PUT`, dan `DELETE`
2. Header kustom `X-API-Key`, `Content-Type`, dan `Accept`
3. Serialisasi `Catatan` lewat `toJson()` dan `fromJson()`
4. Repository sederhana lewat `ApiClient`
5. Penanganan timeout, koneksi internet, dan error HTTP

## Menjalankan

```bash
flutter pub get
flutter run
```
