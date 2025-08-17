import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final nameCtl = TextEditingController();
    final emailCtl = TextEditingController();
    final passCtl = TextEditingController();
    final confirmCtl = TextEditingController();

    void signup() {
      if (passCtl.text == confirmCtl.text && emailCtl.text.isNotEmpty && nameCtl.text.isNotEmpty) {
        Navigator.pushNamedAndRemoveUntil(context, '/home', (_) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields (passwords must match).')),
        );
      }
    }

    return Scaffold(
      body: Stack(children: [
        Image.asset('assets/images/minilogin.jpg', fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        Center(
          child: SingleChildScrollView(
            child: Card(
              color: Colors.white,
              elevation: 10,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text('Create Account',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Color(0xFF4A86E8))),
                  const SizedBox(height: 16),
                  TextField(decoration: _dec('Full Name'), controller: nameCtl),
                  const SizedBox(height: 12),
                  TextField(decoration: _dec('Email'), controller: emailCtl, keyboardType: TextInputType.emailAddress),
                  const SizedBox(height: 12),
                  TextField(decoration: _dec('Password'), controller: passCtl, obscureText: true),
                  const SizedBox(height: 12),
                  TextField(decoration: _dec('Confirm Password'), controller: confirmCtl, obscureText: true),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A86E8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Sign Up', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Text("Login", style: TextStyle(color: Color(0xFF4A86E8), fontWeight: FontWeight.bold)),
                    )
                  ]),
                ]),
              ),
            ),
          ),
        )
      ]),
    );
  }

  InputDecoration _dec(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
    prefixIconColor: const Color(0xFF4A86E8),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: Color(0xFF4A86E8), width: 2),
    ),
  );
}
