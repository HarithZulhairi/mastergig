// lib/pages/OwnerProfile.dart
import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/LoginAndProfile/userModel.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart';
import 'package:mastergig_app/provider/RegisterController.dart';
import 'package:mastergig_app/widgets/ownerFooter.dart';
import 'package:mastergig_app/widgets/ownerHeader.dart';

class OwnerProfile extends StatefulWidget {
  final String ownerEmail;

  const OwnerProfile({super.key, required this.ownerEmail});

  @override
  State<OwnerProfile> createState() => _OwnerProfileState();
}

class _OwnerProfileState extends State<OwnerProfile> {
  userModel? owner;
  bool isLoading = true;
  bool isEditing = false;
  bool obscurePassword = true;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final RegisterController _registerController = RegisterController();

  @override
  void initState() {
    super.initState();
    _loadOwnerProfile();
  }

  Future<void> _loadOwnerProfile() async {
    setState(() => isLoading = true);
    try {
      final user = await _registerController.getUserProfile(widget.ownerEmail);
      if (user != null) {
        _populateControllers(user);
      }
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _populateControllers(userModel user) {
    setState(() {
      owner = user;
      nameController.text = owner!.name;
      usernameController.text = owner!.username;
      phoneController.text = owner!.phone;
      licenseNumberController.text = owner!.licenseNumber;
      roleController.text = owner!.role;
      passwordController.text = owner!.password;
    });
  }

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) obscurePassword = true;
    });
  }

  Future<void> _updateProfile() async {
    final error = await _registerController.updateProfile(
      email: widget.ownerEmail,
      name: nameController.text,
      phone: phoneController.text,
      licenseNumber: licenseNumberController.text,
      password: passwordController.text,
      staffNumber: '', // Add empty string since it's required in the controller
    );

    if (error == null) {
      _registerController.showSuccessDialog(context, title: 'Profile Updated!');
      await _loadOwnerProfile();
      _toggleEdit();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirm Deletion"),
            content: const Text(
              "Are you sure you want to delete your account? This action cannot be undone.",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    final error = await _registerController.deleteAccount(widget.ownerEmail);
    if (error == null && context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
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
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    licenseNumberController.dispose();
    roleController.dispose();
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
      border: const OutlineInputBorder(),
    );
  }

  TextStyle _getTextStyle() {
    return const TextStyle(color: Colors.black, fontWeight: FontWeight.bold);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ownerHeader(context),
      bottomNavigationBar: ownerFooter(context),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : owner == null
              ? const Center(child: Text('Owner not found'))
              : SingleChildScrollView(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(24.0),
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Profile',
                          style: Theme.of(context).textTheme.titleLarge
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
                                decoration: _getFieldDecoration('Full Name'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: usernameController,
                                enabled: false,
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
                                controller: licenseNumberController,
                                enabled: isEditing,
                                style: _getTextStyle(),
                                decoration: _getFieldDecoration(
                                  'License Number',
                                ),
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
                                obscureText: obscurePassword,
                                style: _getTextStyle(),
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  labelStyle: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                  filled: true,
                                  fillColor: Colors.grey.shade200,
                                  border: const OutlineInputBorder(),
                                  suffixIcon:
                                      isEditing
                                          ? IconButton(
                                            icon: Icon(
                                              obscurePassword
                                                  ? Icons.visibility_off
                                                  : Icons.visibility,
                                              color: Colors.grey.shade700,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                obscurePassword =
                                                    !obscurePassword;
                                              });
                                            },
                                          )
                                          : null,
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
                                isEditing ? _updateProfile() : _toggleEdit();
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
                                backgroundColor: const Color(0xFFFFF18E),
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
                                  horizontal: 36,
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
