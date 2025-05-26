import 'package:flutter/material.dart';
import 'package:mastergig_app/widgets/foremanHeader.dart';
import 'package:mastergig_app/widgets/foremanFooter.dart';

class ForemanHomeScreen extends StatelessWidget {
  const ForemanHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: foremanHeader(context),
      bottomNavigationBar: foremanFooter(context),
      body: const Center(
        child: Text('Welcome Foreman!', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
