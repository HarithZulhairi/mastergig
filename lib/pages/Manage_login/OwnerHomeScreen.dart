import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';

class OwnerHomeScreen extends StatelessWidget {
  const OwnerHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body: const Center(
        child: Text('Welcome Owner!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
