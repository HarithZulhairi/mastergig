import 'package:flutter/material.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Dashboard'),
        backgroundColor: const Color(0xFFFFF176),
      ),
      body: const Center(
        child: Text('Welcome Owner!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}