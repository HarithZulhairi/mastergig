// lib/pages/ForemanProfile.dart
import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/LoginAndProfile/userModel.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart';
import 'package:mastergig_app/provider/RegisterController.dart';
import 'package:mastergig_app/widgets/foremanFooter.dart';
import 'package:mastergig_app/widgets/foremanHeader.dart';

class ForemanProfile extends StatefulWidget {
  final String foremanEmail;

  const ForemanProfile({super.key, required this.foremanEmail});

  @override
  State<ForemanProfile> createState() => _ForemanProfilePageState();
}

class _ForemanProfilePageState extends State<ForemanProfile> {
  userModel? foreman;
  bool isLoading = true;
  bool isEditing = false;
  bool _showPassword = false;

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController staffNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();
    _loadForemanProfile();
  }

  Future<void> _loadForemanProfile() async {
    setState(() => isLoading = true);

    try {
      final user = await _registerController.getUserProfile(
        widget.foremanEmail,
      );

      if (user != null) {
        setState(() {
          foreman = user;
          nameController.text = foreman!.name;
          usernameController.text = foreman!.username;
          phoneController.text = foreman!.phone;
          staffNumberController.text = foreman!.staffNumber;
          licenseNumberController.text = foreman!.licenseNumber;
          roleController.text = foreman!.role;
          passwordController.text = foreman!.password;
        });
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _toggleEdit() {
    setState(() => isEditing = !isEditing);
  }

  Future<void> _editProfile() async {
    final errorMsg = await _registerController.updateProfile(
      email: usernameController.text,
      name: nameController.text,
      phone: phoneController.text,
      staffNumber: staffNumberController.text,
      licenseNumber: licenseNumberController.text,
      password: passwordController.text,
    );

    if (errorMsg == null) {
      _registerController.showSuccessDialog(context);
      await _loadForemanProfile(); // Refresh data
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }

    _toggleEdit();
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Delete"),
            content: const Text(
              "Are you sure you want to delete this account? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Delete"),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    final error = await _registerController.deleteAccount(widget.foremanEmail);

    if (error == null && context.mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
        (Route<dynamic> route) => false,
      );
    } else if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    phoneController.dispose();
    staffNumberController.dispose();
    licenseNumberController.dispose();
    roleController.dispose();
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration _getFieldDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      filled: true,
      fillColor: Colors.grey.shade200,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    );
  }

  TextStyle _getTextStyle() {
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: foremanHeader(context),
      bottomNavigationBar: foremanFooter(context),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : foreman == null
              ? const Center(child: Text('Foreman not found'))
              : SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Foreman Profile',
                          style: Theme.of(context).textTheme.headline5
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                          ),
                          child: Column(
                            children: [
                              TextFormField(
                                controller: nameController,
                                enabled: isEditing,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration('Name'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: usernameController,
                                enabled: isEditing,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration(
                                  'Email Address',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: phoneController,
                                enabled: isEditing,
                                keyboardType: TextInputType.phone,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration(
                                  'Contact Information',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: staffNumberController,
                                enabled: isEditing,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration('Staff Number'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: roleController,
                                enabled: false,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration('Role'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: passwordController,
                                enabled: isEditing,
                                obscureText: !_showPassword,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration(
                                  'Password',
                                ).copyWith(
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _showPassword = !_showPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                isEditing ? _editProfile() : _toggleEdit();
                              },
                              icon: Icon(
                                isEditing ? Icons.save : Icons.edit,
                                color: Colors.black,
                              ),
                              label: Text(
                                isEditing ? 'Save' : 'Edit',
                                style: const TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFFC100),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 36,
                                  vertical: 14,
                                ),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton.icon(
                              onPressed: _deleteAccount,
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF8E90),
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 14,
                                ),
                                textStyle: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

extension on TextTheme {
  TextStyle? get headline5 => titleLarge;
}
