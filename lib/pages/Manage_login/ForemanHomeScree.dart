import 'package:flutter/material.dart';

class ForemanHomeScreen extends StatelessWidget {
  const ForemanHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foreman Dashboard'),
        backgroundColor: const Color(0xFFFFF176),
      ),
      body: const Center(
        child: Text('Welcome Foreman!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
