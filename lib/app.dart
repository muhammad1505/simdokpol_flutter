// lib/app.dart
import 'package:flutter/material.dart';
import 'package:simdokpol_flutter/config/app_router.dart';
import 'package:simdokpol_flutter/config/app_themes.dart';

class SimdokpolApp extends StatelessWidget {
  const SimdokpolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'SIMDOKPOL',
      theme: AppThemes.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}

