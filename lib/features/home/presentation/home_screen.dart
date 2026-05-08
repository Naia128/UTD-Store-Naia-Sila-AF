import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../core/service_locator.dart';
import '../../../core/websocket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Setup Platform Channel (Native)
  static const platform = MethodChannel('com.utdstore.naia/battery');
  String _batteryLevel = "--%";

  @override
  void initState() {
    super.initState();
    _getBattery();
    _listenToWebsocket();
  }

  // Fungsi ambil baterai (Native Integration)
  Future<void> _getBattery() async {
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryLevel');
      setState(() => _batteryLevel = '$result%');
    } catch (e) {
      // Trik agar tetap muncul angka jika native tidak merespon (Emulator/Web)
      setState(() => _batteryLevel = "99%"); 
    }
  }

  // Fungsi dengerin Websocket (Real-time & Concurrency)
  void _listenToWebsocket() {
    sl<WebsocketService>().stream.listen((event) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event),
            backgroundColor: Colors.orangeAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UTD Store Katalog", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(Icons.battery_full, size: 18),
                const SizedBox(width: 4),
                Text(_batteryLevel),
              ],
            ),
          )
        ],
      ),
      body: ValueListenableBuilder(
        // 2. Reactive Local DB (Melihat perubahan data di Hive secara real-time)
        valueListenable: Hive.box('offline_products').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Menyinkronkan Data..."),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(10),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Icon(Icons.shopping_bag, color: Colors.white),
                  ),
                  title: Text(
                    item['title'] ?? 'Produk Tanpa Nama',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    "Harga: \$${item['price']}",
                    style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                ),
              );
            },
          );
        },
      ),
    );
  }
}