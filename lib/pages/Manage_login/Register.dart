import 'package:flutter/material.dart';
import 'package:mastergig_app/pages/Manage_login/UserListScreen.dart'
    as user_list;
import 'package:mastergig_app/provider/RegisterController.dart' as provider;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController staffNumberController = TextEditingController();
  final TextEditingController licenseNumberController = TextEditingController();

  final provider.RegisterController _registerController =
      provider.RegisterController();

  String selectedRole = 'Owner';
  bool agreeToTerms = false;

  Future<void> _signUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final phone = phoneController.text.trim();
    final staffNumber = staffNumberController.text.trim();
    final licenseNumber = licenseNumberController.text.trim();

    final errorMessage = await _registerController.signUp(
      phone: phone,
      email: email, // assuming backend still uses "username"
      password: password,
      staffNumber: staffNumber,
      licenseNumber: licenseNumber,
      role: selectedRole,
    );

    if (context.mounted) {
      if (errorMessage == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("User successfully registered")),
        );
        _formKey.currentState?.reset();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const user_list.UserListScreen(),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $errorMessage")));
      }
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

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
                            const Text("Contact Information"),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: phoneController,
                              decoration: const InputDecoration(
                                labelText: "Phone number",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.phone,
                              validator: (value) => value == null || value.isEmpty
                                  ? "Phone number is required"
                                  : null,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              validator: _validateEmail,
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                labelText: "Password",
                                border: OutlineInputBorder(),
                              ),
                              validator: (value) => value == null || value.length < 6
                                  ? "Password must be at least 6 characters"
                                  : null,
                            ),
                            const SizedBox(height: 15),
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
                                setState(() {
                                  selectedRole = value!;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: "Role",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: staffNumberController,
                              decoration: const InputDecoration(
                                labelText: "Staff Number",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            TextFormField(
                              controller: licenseNumberController,
                              decoration: const InputDecoration(
                                labelText: "License Number",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Row(
                              children: [
                                Checkbox(
                                  value: agreeToTerms,
                                  onChanged: (value) {
                                    setState(() {
                                      agreeToTerms = value!;
                                    });
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
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD8BB3B),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate() &&
                                      agreeToTerms) {
                                    _signUp();
                                  } else if (!agreeToTerms) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          "You must agree to the terms.",
                                        ),
                                      ),
                                    );
                                  }
                                },
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
}
