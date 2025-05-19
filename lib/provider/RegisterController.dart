import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';

class RegisterController {
  // Singleton setup
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final List<userModel> _registeredUsers = [];

  Future<String?> signUp({
    required String phone,
    required String username,
    required String password,
    required String staffNumber,
    required String licenseNumber,
    required String role,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (_registeredUsers.any((user) => user.username == username)) {
      return "Username already exists";
    }

    if (phone.isEmpty || username.isEmpty || password.isEmpty) {
      return "Please fill in all required fields";
    }

    final newUser = userModel(
      phone: phone,
      username: username,
      password: password,
      staffNumber: staffNumber,
      licenseNumber: licenseNumber,
      role: role,
    );

    _registeredUsers.add(newUser);
    debugPrint("New user registered: ${newUser.toJson()}");
    return null;
  }

  List<userModel> get allUsers => _registeredUsers;
}
