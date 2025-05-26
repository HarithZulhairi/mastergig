class userModel {
  final String username;
  final String phone;
  final String password;
  final String staffNumber;
  final String licenseNumber;
  final String role;

  userModel({
    required this.username,
    required this.phone,
    required this.password,
    required this.staffNumber,
    required this.licenseNumber,
    required this.role,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'phone': phone,
    'password': password,
    'staffNumber': staffNumber,
    'licenseNumber': licenseNumber,
    'role': role,
  };

  factory userModel.fromJson(Map<String, dynamic> json) {
    return userModel(
      username: json['username'],
      phone: json['phone'],
      password: json['password'],
      staffNumber: json['staffNumber'],
      licenseNumber: json['licenseNumber'],
      role: json['role'],
    );
  }
}
