import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mastergig_app/LoginAndProfile/userModel.dart';

// Import header and footer
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

  // Controllers for the form fields
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController staffNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();
  final TextEditingController roleController = TextEditingController();

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
            username: data['username'],
            phone: data['phone'],
            password: data['password'],
            staffNumber: data['staffNumber'],
            licenseNumber: data['licenseNumber'],
            role: data['role'],
          );

          // Set text controllers values
          usernameController.text = foreman!.username;
          phoneController.text = foreman!.phone;
          staffNumberController.text = foreman!.staffNumber;
          licenseNumberController.text = foreman!.licenseNumber;
          roleController.text = foreman!.role;
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

  @override
  void dispose() {
    // Dispose controllers
    usernameController.dispose();
    phoneController.dispose();
    staffNumberController.dispose();
    licenseNumberController.dispose();
    roleController.dispose();
    super.dispose();
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

                        // Username field
                        TextFormField(
                          controller: usernameController,
                          enabled: isEditing,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Phone field
                        TextFormField(
                          controller: phoneController,
                          enabled: isEditing,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            labelText: 'Phone',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Staff Number field
                        TextFormField(
                          controller: staffNumberController,
                          enabled: isEditing,
                          decoration: const InputDecoration(
                            labelText: 'Staff Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // License Number field
                        TextFormField(
                          controller: licenseNumberController,
                          enabled: isEditing,
                          decoration: const InputDecoration(
                            labelText: 'License Number',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Role field
                        TextFormField(
                          controller: roleController,
                          enabled: false, // Typically role isn't editable
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Edit / Save button
                        ElevatedButton.icon(
                          onPressed: () {
                            if (isEditing) {
                              // Here you can implement save logic to Firestore
                              // For now just toggle editing off
                              toggleEdit();
                            } else {
                              toggleEdit();
                            }
                          },
                          icon: Icon(isEditing ? Icons.save : Icons.edit),
                          label: Text(isEditing ? 'Save' : 'Edit'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 36,
                              vertical: 14,
                            ),
                            textStyle: const TextStyle(fontSize: 18),
                          ),
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
  get headline5 => null;
}
