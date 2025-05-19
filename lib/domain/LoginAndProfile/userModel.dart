import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String username,
    required String password,
    required String phone,
    required String role,
    required String staffNumber,
    required String licenseNumber,
  }) async {
    try {
      final email = "$username@example.com"; // auto email from username

      // Create Firebase user
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      // Save user info to Firestore
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'username': username,
        'email': email,
        'phone': phone,
        'role': role,
        'staffNumber': staffNumber,
        'licenseNumber': licenseNumber,
        'uid': userCredential.user!.uid,
      });
    } on FirebaseAuthException catch (e) {
      // Handle common FirebaseAuth errors
      if (e.code == 'email-already-in-use') {
        throw 'Username already registered. Try a different one.';
      } else if (e.code == 'weak-password') {
        throw 'The password is too weak. Please choose a stronger password.';
      } else {
        throw 'Authentication error: ${e.message}';
      }
    } on FirebaseException catch (e) {
      throw 'Database error: ${e.message}';
    } catch (e) {
      throw 'Unexpected error: ${e.toString()}';
    }
  }
}
