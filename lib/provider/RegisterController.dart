import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';

class RegisterController {
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String phone,
    required String email,
    required String password,
    required String staffNumber,
    required String licenseNumber,
    required String role,
  }) async {
    try {
      // Check if username already exists
      final query =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .get();

      if (query.docs.isNotEmpty) {
        return "Username already exists";
      }

      final newUser = userModel(
        phone: phone,
        username: email,
        password: password,
        staffNumber: staffNumber,
        licenseNumber: licenseNumber,
        role: role,
      );

      await _firestore.collection('users').add(newUser.toJson());
      debugPrint("New user added to Firestore: ${newUser.toJson()}");

      return null;
    } catch (e) {
      debugPrint("Error adding user to Firestore: $e");
      return "Failed to register user";
    }
  }

  Future<List<userModel>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return userModel(
        phone: data['phone'],
        username: data['username'],
        password: data['password'],
        staffNumber: data['staffNumber'],
        licenseNumber: data['licenseNumber'],
        role: data['role'],
      );
    }).toList();
  }
}
