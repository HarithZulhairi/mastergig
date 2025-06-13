import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/domain/LoginAndProfile/userModel.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart';
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

  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController staffNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true; // <-- Added for password visibility toggle

  @override
  void initState() {
    super.initState();
    loadOwnerProfile();
  }

  Future<void> loadOwnerProfile() async {
    final email = widget.ownerEmail;

    if (email.isEmpty) {
      setState(() => isLoading = false);
      return;
    }

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: email)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs.first.data();
        setState(() {
          owner = userModel(
            name: data['name'] ?? '',
            username: data['username'] ?? '',
            phone: data['phone'] ?? '',
            password: data['password'] ?? '',
            staffNumber: data['staffNumber'] ?? '',
            licenseNumber: data['licenseNumber'] ?? '',
            role: data['role'] ?? '',
          );

          nameController.text = owner!.name;
          usernameController.text = owner!.username;
          phoneController.text = owner!.phone;
          staffNumberController.text = owner!.staffNumber;
          licenseNumberController.text = owner!.licenseNumber;
          roleController.text = owner!.role;
          passwordController.text = owner!.password;
        });
      }
    } catch (e) {
      debugPrint("Error retrieving owner data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
      if (!isEditing) {
        // Reset password field visibility when exiting edit mode
        obscurePassword = true;
      }
    });
  }

  Future<void> editProfile() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: widget.ownerEmail)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.docs.first.id)
            .update({
              'name': nameController.text,
              'phone': phoneController.text,
              'licenseNumber': licenseNumberController.text,
              'password': passwordController.text,
            });

        // Show dialog on successful update
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            Future.delayed(const Duration(milliseconds: 1000), () {
              Navigator.of(context).pop();
            });
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              title: const Center(
                child: Text(
                  'Successfully edited!',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
              content: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 100,
              ),
            );
          },
        );

        toggleEdit(); // Exit editing mode
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User not found in database")),
        );
      }
    } catch (e) {
      debugPrint("Error saving profile: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to save changes: $e")));
    }
  }

  Future<void> deleteAccount() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: widget.ownerEmail)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(snapshot.docs.first.id)
            .delete();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully")),
        );

        // Redirect to login page and remove all previous routes
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error deleting account: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to delete account: $e")));
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    staffNumberController.dispose();
    licenseNumberController.dispose();
    roleController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  InputDecoration getFieldDecoration(String label) {
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

  TextStyle getTextStyle() {
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
                                style: getTextStyle(),
                                decoration: getFieldDecoration('Name'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: usernameController,
                                enabled: false,
                                style: getTextStyle(),
                                decoration: getFieldDecoration('Email Address'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: phoneController,
                                enabled: isEditing,
                                keyboardType: TextInputType.phone,
                                style: getTextStyle(),
                                decoration: getFieldDecoration(
                                  'Contact Information',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: licenseNumberController,
                                enabled: isEditing,
                                style: getTextStyle(),
                                decoration: getFieldDecoration(
                                  'License Number',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: roleController,
                                enabled: false,
                                style: getTextStyle(),
                                decoration: getFieldDecoration('Role'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: passwordController,
                                enabled: isEditing,
                                obscureText: obscurePassword,
                                keyboardType: TextInputType.visiblePassword,
                                style: getTextStyle(),
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
                                isEditing ? editProfile() : toggleEdit();
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
                                backgroundColor: const Color(
                                  0xFFFFF18E,
                                ), // golden yellow
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
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text("Confirm Deletion"),
                                        content: const Text(
                                          "Are you sure you want to delete your account? This action cannot be undone.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              deleteAccount();
                                            },
                                            child: const Text(
                                              "Delete",
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.black,
                              ),
                              label: const Text(
                                'Delete',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(
                                  0xFFFF8E90,
                                ), // soft red-pink
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

// Fix for headline5 in older Flutter versions
extension on TextTheme {
  TextStyle? get headline5 => titleLarge;
}
