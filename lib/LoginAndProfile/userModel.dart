class userModel {
  final String phone;
  final String username;
  final String password;
  final String staffNumber;
  final String licenseNumber;
  final String role;

  userModel({
    required this.phone,
    required this.username,
    required this.password,
    required this.staffNumber,
    required this.licenseNumber,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'username': username,
      'password': password,
      'staffNumber': staffNumber,
      'licenseNumber': licenseNumber,
      'role': role,
    };
  }
}
