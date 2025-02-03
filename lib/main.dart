import 'package:flutter/material.dart';  // UI components
import 'package:firebase_core/firebase_core.dart';  // Firebase initialization
import 'package:flutter/foundation.dart';  // Platform checking (for Web/Mobile)
import 'auth/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:labproject/pages/student_landing.dart';
import 'package:labproject/pages/staff_landing.dart';
import 'package:labproject/pages/admin_landing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async{
WidgetsFlutterBinding.ensureInitialized();

if (kIsWeb){  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "",
        authDomain: "",
        projectId: "",
        storageBucket: "",
        messagingSenderId: "",
        appId: ""));}
        else {
          await Firebase.initializeApp();
        }


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PTAR Library',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[100], // Light background
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 18, color: Colors.black87),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black54),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[900],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
       home: AuthWrapper(), // Check authentication status
    );
  }
}

class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show loading while checking auth
        }

        if (snapshot.hasData && snapshot.data != null) {
          User user = snapshot.data!;
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(user.uid).get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator()); 
              }

              if (userSnapshot.hasData && userSnapshot.data!.exists) {
                String role = userSnapshot.data!['role'];

                if (role == 'student') {
                  return StudentLandingPage();
                } else if (role == 'staff') {
                  return StaffLandingPage();
                } else if (role == 'admin') {
                  return AdminLandingPage();
                }
              }

              return LoginPage(); // Default to login if role not found
            },
          );
        } 
        
        return LoginPage(); // Show login page if not authenticated
      },
    );
  }
}
