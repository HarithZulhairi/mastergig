import 'package:mastergig_app/domain/LoginAndProfile/userModel.dart';

class RegisterController {
  final UserModel _userModel = UserModel();

  Future<String?> signUp({
    required String phone,
    required String username,
    required String password,
    required String staffNumber,
    required String licenseNumber,
    required String role,
  }) async {
    try {
      await _userModel.registerUser(
        username: username,
        password: password,
        phone: phone,
        role: role,
        staffNumber: staffNumber,
        licenseNumber: licenseNumber,
      );
      return null;
    } catch (e) {
      return e.toString(); // Already returns error to view
    }
  }
}
