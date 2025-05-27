import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';
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

  @override
  void initState() {
    super.initState();
    loadForemanProfile();
  }

  Future<void> loadForemanProfile() async {
    final email = widget.foremanEmail;

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
          foreman = userModel(
            name: data['name'] ?? '',
            username: data['username'] ?? '',
            phone: data['phone'] ?? '',
            password: data['password'] ?? '',
            staffNumber: data['staffNumber'] ?? '',
            licenseNumber: data['licenseNumber'] ?? '',
            role: data['role'] ?? '',
          );

          nameController.text = foreman!.name;
          usernameController.text = foreman!.username;
          phoneController.text = foreman!.phone;
          staffNumberController.text = foreman!.staffNumber;
          licenseNumberController.text = foreman!.licenseNumber;
          roleController.text = foreman!.role;
          passwordController.text = foreman!.password;
        });
      } else {
        debugPrint("No foreman found for email: $email");
      }
    } catch (e) {
      debugPrint("Error retrieving foreman data: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  void toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  Future<void> saveChanges() async {
    final errorMsg = await RegisterController().updateUserProfile(
      username: usernameController.text,
      phone: phoneController.text,
      staffNumber: staffNumberController.text,
      licenseNumber: licenseNumberController.text,
    );

    if (errorMsg == null) {
      try {
        final snapshot =
            await FirebaseFirestore.instance
                .collection('users')
                .where('username', isEqualTo: widget.foremanEmail)
                .limit(1)
                .get();

        if (snapshot.docs.isNotEmpty) {
          final docId = snapshot.docs.first.id;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(docId)
              .update({
                'name': nameController.text,
                'username': usernameController.text,
                'phone': phoneController.text,
                'staffNumber': staffNumberController.text,
                'licenseNumber': licenseNumberController.text,
                'password': passwordController.text,
                'role': roleController.text,
              });

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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("User not found in database")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating Firestore: $e")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMsg)));
    }

    toggleEdit();
  }

  Future<void> deleteAccount() async {
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

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .where('username', isEqualTo: widget.foremanEmail)
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

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const Login()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Account not found")));
      }
    } catch (e) {
      debugPrint("Error deleting account: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error deleting account: $e")));
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

  InputDecoration getFieldDecoration(String label) {
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

  TextStyle getTextStyle() {
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
                                style: getTextStyle(),
                                decoration: getFieldDecoration('Name'),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: usernameController,
                                enabled: isEditing,
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
                                controller: staffNumberController,
                                enabled: isEditing,
                                style: getTextStyle(),
                                decoration: getFieldDecoration('Staff Number'),
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
                                obscureText: !_showPassword,
                                style: getTextStyle(),
                                decoration: getFieldDecoration(
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
                                isEditing ? saveChanges() : toggleEdit();
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
                              onPressed: deleteAccount,
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
