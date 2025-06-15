// lib/provider/RegisterController.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/LoginAndProfile/userModel.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart';

class RegisterController {
  static final RegisterController _instance = RegisterController._internal();
  factory RegisterController() => _instance;
  RegisterController._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ==================== AUTHENTICATION METHODS ====================

  // Sign Up with full validation
  Future<String?> signUp({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String staffNumber,
    required String licenseNumber,
    required String role,
    required BuildContext context,
  }) async {
    try {
      // Validate required fields
      if (name.isEmpty || phone.isEmpty || email.isEmpty || password.isEmpty) {
        return 'All fields are required';
      }

      // Check if email already exists
      final emailQuery =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .get();

      if (emailQuery.docs.isNotEmpty) {
        return 'Email already exists';
      }

      // Create new user model
      final newUser = userModel(
        name: name,
        phone: phone,
        username: email,
        password: password,
        staffNumber: staffNumber,
        licenseNumber: licenseNumber,
        role: role,
      );

      // Add to Firestore
      await _firestore.collection('users').add(newUser.toJson());
      debugPrint("New user added: ${newUser.toJson()}");

      // Show success dialog
      await _showSuccessDialog(
        context,
        title: 'Sign Up Successful!',
        onComplete: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          );
        },
      );

      return null;
    } catch (e) {
      debugPrint("Sign up error: $e");
      return "Failed to register: ${e.toString()}";
    }
  }

  // Sign In
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

  // ==================== PROFILE MANAGEMENT METHODS ====================

  // Get User Profile by Email
  Future<userModel?> getUserProfile(String email) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        debugPrint("No user found with email: $email");
        return null;
      }

      final doc = snapshot.docs.first;
      final data = doc.data();

      debugPrint("Retrieved user data: ${data.toString()}");

      return userModel(
        name: data['name'] ?? '',
        username: data['username'] ?? data['email'] ?? '',
        phone: data['phone'] ?? '',
        password: data['password'] ?? '',
        staffNumber: data['staffNumber'] ?? '',
        licenseNumber: data['licenseNumber'] ?? '',
        role: data['role'] ?? '',
      );
    } catch (e) {
      debugPrint("Error retrieving user data: $e");
      return null;
    }
  }

  // Update User Profile
  Future<String?> updateProfile({
    required String email,
    required String name,
    required String phone,
    required String staffNumber,
    required String licenseNumber,
    required String password,
  }) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        return "User not found";
      }

      await _firestore.collection('users').doc(snapshot.docs.first.id).update({
        'name': name,
        'phone': phone,
        'staffNumber': staffNumber,
        'licenseNumber': licenseNumber,
        'password': password,
      });

      return null;
    } catch (e) {
      debugPrint("Error updating profile: $e");
      return "Failed to update profile: $e";
    }
  }

  // Delete Account
  Future<String?> deleteAccount(String email) async {
    try {
      final snapshot =
          await _firestore
              .collection('users')
              .where('username', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isEmpty) {
        return "Account not found";
      }

      await _firestore.collection('users').doc(snapshot.docs.first.id).delete();
      return null;
    } catch (e) {
      debugPrint("Error deleting account: $e");
      return "Failed to delete account: $e";
    }
  }

  // ==================== VALIDATION METHODS ====================

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  // Name validation
  String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }

  // Phone validation
  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    return null;
  }

  // Staff/License number validation
  String? validateStaffLicenseNumber(String? value, String role) {
    if (role == 'Owner' && (value == null || value.isEmpty)) {
      return 'License number is required';
    } else if (role == 'Foreman' && (value == null || value.isEmpty)) {
      return 'Staff number is required';
    }
    return null;
  }

  // ==================== UI HELPERS ====================

  // Show Success Dialog
  Future<void> _showSuccessDialog(
    BuildContext context, {
    required String title,
    required VoidCallback onComplete,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
          onComplete();
        });
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
        );
      },
    );
  }

  // Show Generic Success Dialog
  void showSuccessDialog(BuildContext context, {String title = 'Success!'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.of(context).pop();
        });
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: Center(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
          content: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 80,
          ),
        );
      },
    );
  }

  // ==================== USER MANAGEMENT ====================

  // Get All Users
  Future<List<userModel>> getAllUsers() async {
    final snapshot = await _firestore.collection('users').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return userModel(
        name: data['name'] ?? '',
        username: data['username'] ?? '',
        phone: data['phone'] ?? '',
        password: data['password'] ?? '',
        staffNumber: data['staffNumber'] ?? '',
        licenseNumber: data['licenseNumber'] ?? '',
        role: data['role'] ?? '',
      );
    }).toList();
  }
}
