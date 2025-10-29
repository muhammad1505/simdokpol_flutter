// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simdokpol_flutter/app.dart';
import 'package:simdokpol_flutter/data/datasources/database_helper.dart';
import 'package:simdokpol_flutter/presentation/auth/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Database
  await DatabaseHelper().initDb();

  // Pastikan desktop bindings sudah diinisialisasi
  // if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
  //   // Tidak ada inisialisasi khusus di main untuk desktop,
  //   // inisialisasi FFI sudah dilakukan di DatabaseHelper
  // }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        // Tambahkan providers lain di sini seiring pengembangan
        // ChangeNotifierProvider(create: (_) => DocumentProvider()),
        // ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const SimdokpolApp(),
    ),
  );
}

