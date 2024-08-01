import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String email = '';
  String phoneNumber = '';
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      Map<String, dynamic>? userDetails =
          await _authService.getUserDetails(user.uid);
      if (userDetails != null) {
        setState(() {
          email = userDetails['email'] ?? '';
          phoneNumber = userDetails['phoneNumber'] ?? '';
          _phoneController.text = phoneNumber;
        });
      }
    }
  }

  void _updatePhoneNumber() async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      await _authService.updatePhoneNumber(user.uid, _phoneController.text);
      setState(() {
        phoneNumber = _phoneController.text;
      });
    }
  }

  void _signOut() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: $email'),
            SizedBox(height: 10),
            Text('Phone Number: $phoneNumber'),
            SizedBox(height: 20),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: 'Update Phone Number'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updatePhoneNumber,
              child: Text('Update Phone Number'),
            ),
          ],
        ),
      ),
    );
  }
}
