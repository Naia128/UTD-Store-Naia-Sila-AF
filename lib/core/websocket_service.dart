import 'dart:async';

class WebsocketService {
  // Broadcast agar bisa didengarkan banyak listener secara concurrent
  final _controller = StreamController<String>.broadcast();
  Stream<String> get stream => _controller.stream;

  WebsocketService() {
    _startSimulatedSocket();
  }

  void _startSimulatedSocket() {
    // Simulasi data real-time setiap 15 detik
    Timer.periodic(const Duration(seconds: 15), (timer) {
      _controller.add("Flash Sale Baru Terdeteksi!");
    });
  }
}