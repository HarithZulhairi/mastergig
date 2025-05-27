class userModel {
  final String name;
  final String phone;
  final String username;
  final String password;
  final String staffNumber;
  final String licenseNumber;
  final String role;
  final String email; // Final field must be initialized

  userModel({
    required this.name,
    required this.phone,
    required this.username,
    required this.password,
    required this.staffNumber,
    required this.licenseNumber,
    required this.role,
  }) : email = username; // Initialize email using username

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'username': username,
      'password': password,
      'staffNumber': staffNumber,
      'licenseNumber': licenseNumber,
      'role': role,
      'name': name,
    };
  }
}
