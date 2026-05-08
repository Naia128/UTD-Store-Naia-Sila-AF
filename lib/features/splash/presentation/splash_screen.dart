import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/service_locator.dart';
import '../domain/splash_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startSplash();
  }

  Future<void> _startSplash() async {
    // 1. Panggil Service dari Locator
    final splashService = sl<SplashService>();
    
    // 2. Jalankan delay 1 detik (Logika NIM Akhiran 1)
    await splashService.setupDelay();
    
    // 3. Pindah ke halaman Home menggunakan GoRouter
    if (mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo atau Icon Store
            const Icon(Icons.store, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            // Nama dan NIM Kamu
            const Text(
              "UTD Store Naia Sila AF",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "NIM: 20123061",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 50),
            const CircularProgressIndicator(), // Loading kecil biar keren
          ],
        ),
      ),
    );
  }
}