class SplashService {
  // Logika Personal: Delay 1 detik karena digit terakhir NIM adalah 1
  Future<void> setupDelay() async {
    await Future.delayed(const Duration(seconds: 1));
  }
}