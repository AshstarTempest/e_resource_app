import 'package:flutter/material.dart';
import 'admin_auth.dart'; // Import the admin_auth.dart file

class AdminLoginPage extends StatefulWidget {
  @override
  _AdminLoginPageState createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final AdminAuthService _authService = AdminAuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  Future<void> _signIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    final user = await _authService.adminSignIn(email, password);

    if (user != null) {
      // Navigate to the admin dashboard or management page
      Navigator.pushReplacementNamed(context, '/admin_dashboard');
    } else {
      setState(() {
        _errorMessage = 'Invalid email or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
            ),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
