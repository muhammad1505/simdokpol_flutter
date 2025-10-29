// lib/config/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:simdokpol_flutter/presentation/auth/pages/initial_setup_page.dart';
import 'package:simdokpol_flutter/presentation/auth/pages/login_page.dart';
import 'package:simdokpol_flutter/presentation/dashboard/pages/dashboard_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          // Logic untuk menentukan halaman awal
          // Misalnya, cek apakah user sudah login atau apakah ini first launch
          // Untuk saat ini, kita akan arahkan ke login_page atau initial_setup_page
          return const LoginPage(); // Akan diganti dengan logic cek kondisi
        },
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return const LoginPage();
        },
      ),
      GoRoute(
        path: '/setup',
        builder: (BuildContext context, GoRouterState state) {
          return const InitialSetupPage();
        },
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) {
          return const DashboardPage();
        },
      ),
      // Tambahkan rute lain di sini seiring pengembangan
      // GoRoute(
      //   path: '/documents',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const DocumentListPage();
      //   },
      // ),
      // GoRoute(
      //   path: '/users',
      //   builder: (BuildContext context, GoRouterState state) {
      //     return const UserListPage();
      //   },
      // ),
    ],
    // redirect: (BuildContext context, GoRouterState state) {
    //   // Contoh redirect logic
    //   // final authProvider = Provider.of<AuthProvider>(context, listen: false);
    //   // final loggedIn = authProvider.isLoggedIn;
    //   // final isOnLoginPage = state.location == '/login';
    //
    //   // if (!loggedIn && !isOnLoginPage) {
    //   //   return '/login';
    //   // }
    //   // if (loggedIn && isOnLoginPage) {
    //   //   return '/dashboard';
    //   // }
    //   return null;
    // },
    errorBuilder: (context, state) => const Text('Halaman tidak ditemukan!'), // Halaman error kustom
  );
}

