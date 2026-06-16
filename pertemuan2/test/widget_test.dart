import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan2/main.dart';

void main() {
  testWidgets('menampilkan halaman profil dan membuka edit profile', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Profil Saya'), findsOneWidget);
    expect(find.text('Faiz Khairann'), findsOneWidget);
    expect(find.text('Tentang Saya'), findsOneWidget);
    expect(find.text('Skills'), findsOneWidget);
    expect(find.text('Praktikum Mobile'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('Edit Profile'), findsOneWidget);
    expect(find.text('Ubah Foto Profile'), findsOneWidget);

    await tester.drag(find.byType(ListView), const Offset(0, -500));
    await tester.pumpAndSettle();

    expect(find.text('Simpan Profile'), findsOneWidget);
  });

  testWidgets('membuka halaman upload pengalaman dari drawer', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    await tester.tap(find.byTooltip('Open navigation menu'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Upload Pengalaman').first);
    await tester.pumpAndSettle();

    expect(find.text('Upload Pengalaman'), findsNWidgets(2));
    expect(find.text('Upload Gambar Pengalaman'), findsOneWidget);
    expect(find.text('Judul'), findsOneWidget);
    expect(find.text('Deskripsi Singkat'), findsOneWidget);
  });
}
