// lib/pages/Register.dart
import 'package:flutter/material.dart';
import 'package:mastergig_app/pages/Manage_login/Login.dart';
import 'package:mastergig_app/provider/RegisterController.dart' as provider;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final provider.RegisterController _registerController =
      provider.RegisterController();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController staffLicenseController = TextEditingController();
  final TextEditingController nameController = TextEditingController();

  String selectedRole = 'Owner';
  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign Up")),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: const Color(0xFFFFF18E),
            padding: const EdgeInsets.all(20),
            child: const Text(
              "Create Your Account",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Name Field
                            TextFormField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Full Name",
                                border: OutlineInputBorder(),
                              ),
                              validator: _registerController.validateName,
                            ),
                            const SizedBox(height: 15),

                            // Contact Information
                            const Text("Contact Information"),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: "Phone number",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: _registerController.validatePhone,
                            ),
                            const SizedBox(height: 15),

                            // Email Field
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _registerController.validateEmail,
                            ),
                            const SizedBox(height: 15),

                            // Password Field
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              validator: _registerController.validatePassword,
                            ),
                            const SizedBox(height: 15),

                            // Role Dropdown
                            DropdownButtonFormField<String>(
                              value: selectedRole,
                              items: const [
                                DropdownMenuItem(
                                  value: "Owner",
                                  child: Text("Owner"),
                                ),
                                DropdownMenuItem(
                                  value: "Foreman",
                                  child: Text("Foreman"),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() => selectedRole = value!);
                              },
                              decoration: const InputDecoration(
                                labelText: "Role",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Conditional Field
                            TextFormField(
                              controller: staffLicenseController,
                              decoration: InputDecoration(
                                labelText:
                                    selectedRole == "Owner"
                                        ? "License Number"
                                        : "Staff Number",
                                border: const OutlineInputBorder(),
                              ),
                              validator:
                                  (value) => _registerController
                                      .validateStaffLicenseNumber(
                                        value,
                                        selectedRole,
                                      ),
                            ),
                            const SizedBox(height: 15),

                            // Terms Checkbox
                            Row(
                              children: [
                                Checkbox(
                                  value: agreeToTerms,
                                  onChanged: (value) {
                                    setState(() => agreeToTerms = value!);
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    "Agree with terms and conditions",
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // Sign Up Button
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD8BB3B),
                                ),
                                onPressed: _handleSignUp,
                                child: const Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (!agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("You must agree to the terms.")),
      );
      return;
    }

    final error = await _registerController.signUp(
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      staffNumber:
          selectedRole == 'Foreman' ? staffLicenseController.text.trim() : '',
      licenseNumber:
          selectedRole == 'Owner' ? staffLicenseController.text.trim() : '',
      role: selectedRole,
      context: context,
    );

    if (error != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  void dispose() {
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    staffLicenseController.dispose();
    nameController.dispose();
    super.dispose();
  }
}
