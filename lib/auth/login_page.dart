import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labproject/pages/student_landing.dart';
import 'package:labproject/pages/staff_landing.dart';
import 'package:labproject/pages/admin_landing.dart';
import 'package:labproject/auth/register_page.dart';
import 'package:labproject/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  String? errorMessage; // Store error message

  void loginUser() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    setState(() {
      errorMessage = null; // Clear previous errors
    });

    try {
      var user = await _authService.loginUser(email, password);
      if (user != null) {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          String role = userDoc['role'];

          if (role == 'student') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StudentLandingPage()));
          } else if (role == 'staff') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => StaffLandingPage()));
          } else if (role == 'admin') {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => AdminLandingPage()));
          }
        } else {
          showErrorMessage("User role not found.");
        }
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showErrorMessage("No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showErrorMessage("Incorrect password. Please try again.");
      } else {
        showErrorMessage("Login failed. Please try again.");
      }
    } catch (e) {
      showErrorMessage("An unexpected error occurred.");
    }
  }

  void showErrorMessage(String message) {
    setState(() {
      errorMessage = message;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6200EA), Color(0xFF03DAC5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/logo.png', height: 100), // Replace with your logo
                      const SizedBox(height: 20),
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Login to continue",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "Password",
                          prefixIcon: Icon(Icons.lock),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      if (errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: loginUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => RegisterPage()),
                        ),
                        child: const Text(
                          "Don't have an account? Sign up",
                          style: TextStyle(color: Colors.deepPurple, fontSize: 16),
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
    );
  }
}
