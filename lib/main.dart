import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/app_router.dart';
import 'core/service_locator.dart';

void main() async {
  // Wajib untuk Native Integration & Hive
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Reactive Local Database Initialization
  await Hive.initFlutter();
  await Hive.openBox('offline_products'); 

  // 2. Dependency Injection
  await setupLocator();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'UTD Store Premium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routerConfig: router,
    );
  }
}