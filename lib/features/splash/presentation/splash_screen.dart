import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("UTD Store NAIA SILA AF", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text("NIM: 20123061"),
          ],
        ),
      ),
    );
  }
}