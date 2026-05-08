import 'package:flutter/material.dart';
import 'core/app_router.dart';
import 'core/service_locator.dart';

void main() {
  // 1. Inisialisasi Service Locator (Dependency Injection)
  setupLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 2. Gunakan MaterialApp.router sesuai syarat GoRouter
    return MaterialApp.router(
      title: 'UTD Store Naia Sila AF',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // 3. Hubungkan dengan router yang kita buat di core/app_router.dart
      routerConfig: router, 
    );
  }
}