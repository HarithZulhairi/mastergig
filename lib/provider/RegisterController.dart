import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';

class RegisterController {
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String staffNumber,
    required String licenseNumber,
    required String role,
  }) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .get();

      if (query.docs.isNotEmpty) {
        return "Username already exists";
      }

      final newUser = userModel(
        name: name,
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

  Future<String?> signIn({
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final query =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .limit(1)
              .get();

      if (query.docs.isEmpty) {
        return "User not found";
      }

      final userData = query.docs.first.data();

      if (userData['password'] != password) {
        return "Incorrect password";
      }

      if (userData['role']?.toLowerCase() != role.toLowerCase()) {
        return "You are not registered as $role";
      }

      return null;
    } catch (e) {
      debugPrint("Error during login: $e");
      return "Login failed. Please try again.";
    }
  }

  Future<String?> updateUserProfile({
    required String username,
    required String phone,
    required String staffNumber,
    required String licenseNumber,
  }) async {
    // Basic validation examples
    if (username.isEmpty || phone.isEmpty) {
      return 'Username and phone cannot be empty';
    }

    try {
      // Find the user document by username
      final querySnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: username)
              .limit(1)
              .get();

      if (querySnapshot.docs.isEmpty) {
        return 'User not found';
      }

      final docId = querySnapshot.docs.first.id;

      // Update fields
      await FirebaseFirestore.instance.collection('users').doc(docId).update({
        'phone': phone,
        'staffNumber': staffNumber,
        'licenseNumber': licenseNumber,
      });

      return null; // success
    } catch (e) {
      return 'Failed to update profile: $e';
    }
  }

  Future<List<userModel>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return userModel(
        name: data['name'],
        username: data['email'],
        phone: data['phone'],
        password: data['password'],
        staffNumber: data['staffNumber'],
        licenseNumber: data['licenseNumber'],
        role: data['role'],
      );
    }).toList();
  }
}
