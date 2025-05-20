import 'package:flutter/material.dart';
import 'package:mastergig_app/provider/RegisterController.dart';
import 'Register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _Login();
}

class _Login extends State<Login> {
  final RegisterController _controller = RegisterController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? errorText;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    final result = await _controller.signUp(
      email: email.split('@').first,
      password: password,
      phone: '0000000000',
      staffNumber: '12345',
      licenseNumber: 'LIC123',
      role: 'staff',
    );

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Registration successful!')));
    } else {
      setState(() {
        errorText = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF176),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        _borderedText('M'),
                        _borderedText('aster'),
                        _borderedText('G'),
                        _borderedText('ig'),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        _filledText('M', color: Colors.orange),
                        _filledText('aster', color: Colors.white),
                        _filledText('G', color: Colors.orange),
                        _filledText('ig', color: Colors.white),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Secure Access for Efficient\nManagement',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 40),
              if (errorText != null)
                Text(errorText!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 10),

              SizedBox(
                width: 250,
                child: TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: _handleRegister,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Register'),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Register(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextSpan _borderedText(String text) {
    return TextSpan(
      text: text,
      style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.bold,
        foreground:
            Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = 2.5
              ..color = Colors.black,
      ),
    );
  }

  TextSpan _filledText(String text, {Color color = Colors.orange}) {
    return TextSpan(
      text: text,
      style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color),
    );
  }
}
