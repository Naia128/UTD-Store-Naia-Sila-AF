import 'dart:async';

class SplashService {
  // Pastikan namanya "initializeApp" (tanpa typo)
  Future<void> initializeApp() async {
    // Delay 1 detik sesuai NIM ganjil (1)
    await Future.delayed(const Duration(milliseconds: 1000));
  }
}