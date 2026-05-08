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
  // Platform Channel - Native Integration
  static const platform = MethodChannel('com.utdstore.naia/battery');
  String _batteryLevel = "Mengambil data baterai...";

  @override
  void initState() {
    super.initState();
    _getBattery();
    // Dengerin Websocket
    sl<WebsocketService>().stream.listen((event) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(event)));
      }
    });
  }

  Future<void> _getBattery() async {
    try {
      final int result = await platform.invokeMethod('getBatteryLevel');
      setState(() => _batteryLevel = 'Battery: $result%');
    } catch (e) {
      setState(() => _batteryLevel = "Native Not Supported");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UTD Store Premium"),
        actions: [Center(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(_batteryLevel),
        ))],
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box('offline_products').listenable(),
        builder: (context, Box box, _) {
          if (box.isEmpty) {
            return const Center(child: Text("Cek internet untuk sync data pertama kali"));
          }
          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final item = box.getAt(index);
              return ListTile(
                leading: const Icon(Icons.shopping_bag),
                title: Text(item['title'] ?? 'Product'),
                subtitle: Text("\$${item['price']}"),
              );
            },
          );
        },
      ),
    );
  }
}