import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pertemuan5/main.dart';

void main() {
  testWidgets('Catatan form validates empty fields', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: CatatanFormPage()));

    expect(find.text('Tambah Catatan'), findsOneWidget);
    expect(find.text('Simpan'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.save_outlined));
    await tester.pump();

    expect(find.text('Judul wajib diisi'), findsOneWidget);
    expect(find.text('Isi catatan wajib diisi'), findsOneWidget);
  });
}
