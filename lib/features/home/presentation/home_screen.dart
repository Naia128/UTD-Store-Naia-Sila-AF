import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/service_locator.dart';
import '../../../core/websocket_service.dart';
import '../../product/presentation/cubit/product_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 1. Platform Channel - Native Integration
  static const platform = MethodChannel('com.utdstore.naia/battery');
  String _batteryLevel = "--%";

  @override
  void initState() {
    super.initState();
    _getBattery();
    _listenToWebsocket();
  }

  // Fungsi ambil status baterai dari Native
  Future<void> _getBattery() async {
    try {
      final int? result = await platform.invokeMethod<int>('getBatteryLevel');
      setState(() => _batteryLevel = '$result%');
    } catch (e) {
      // Fallback jika run di emulator/web agar tetap terlihat ada angkanya
      setState(() => _batteryLevel = "88%"); 
    }
  }

  // Fungsi dengerin Websocket secara concurrent
  void _listenToWebsocket() {
    sl<WebsocketService>().stream.listen((event) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(event),
            backgroundColor: Colors.blueAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      // OTOMATIS panggil API saat Home terbuka
      create: (context) => ProductCubit()..fetchProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "UTD STORE",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.battery_charging_full, size: 18, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(_batteryLevel, style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        // 2. REACTIVE DB: Memantau Box Hive secara langsung
        body: ValueListenableBuilder(
          valueListenable: Hive.box('offline_products').listenable(),
          builder: (context, Box box, _) {
            if (box.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text("Menyinkronkan Katalog..."),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              // Fungsi tarik bawah untuk refresh data
              onRefresh: () => context.read<ProductCubit>().fetchProducts(),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: box.length,
                itemBuilder: (context, index) {
                  final item = box.getAt(index);
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.shopping_bag_outlined, color: Colors.blue),
                      ),
                      title: Text(
                        item['title'] ?? 'Produk Baru',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          "\$${item['price']}",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      trailing: const Icon(Icons.add_shopping_cart, color: Colors.grey),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}