import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';
import 'package:mastergig_app/provider/RegisterController.dart';

class UserListScreen extends StatelessWidget {
  final RegisterController registerController;

  const UserListScreen({super.key, required this.registerController});

  @override
  Widget build(BuildContext context) {
    final List<userModel> users = registerController.allUsers;

    return Scaffold(
      appBar: AppBar(title: const Text("Registered Users")),
      body: users.isEmpty
          ? const Center(child: Text("No users registered yet."))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: const Icon(Icons.person),
                  title: Text(user.username),
                  subtitle: Text("Phone: ${user.phone} • Role: ${user.role}"),
                );
              },
            ),
    );
  }
}
