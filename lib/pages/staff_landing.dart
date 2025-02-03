import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labproject/auth/login_page.dart';

class StaffLandingPage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _logout(BuildContext context) async {
    await _auth.signOut(); // Firebase sign out
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), // Navigate to login page
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Staff Dashboard"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to Staff Dashboard!", style: TextStyle(fontSize: 24)),
            SizedBox(height: 20), // Space between the welcome text and the logout button
            TextButton(
              onPressed: () => _logout(context),
              child: Text(
                "Logout",
                style: TextStyle(
                  color: Colors.red, // You can change the color
                  fontSize: 18, // You can adjust the font size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
