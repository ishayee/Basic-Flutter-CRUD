import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labproject/auth/login_page.dart';
import 'package:labproject/pages/admin_view_books.dart'; // Manage books page

class AdminLandingPage extends StatefulWidget {
  @override
  _AdminLandingPageState createState() => _AdminLandingPageState();
}

class _AdminLandingPageState extends State<AdminLandingPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String adminName = "Loading...";

  @override
  void initState() {
    super.initState();
    _fetchAdminInfo();
  }

  Future<void> _fetchAdminInfo() async {
    String uid = _auth.currentUser!.uid;
    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userDoc.exists) {
      setState(() {
        adminName = userDoc['name'] ?? "No Name";
      });
    }
  }

  void _logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Admin Dashboard"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png', height: 100),
            const SizedBox(height: 20),


            SizedBox(height: 20),

            // Manage Books Button
            _buildOptionCard(
              icon: Icons.library_books,
              title: "Manage Books",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminViewBooksScreen()),
              ),
            ),

            SizedBox(height: 20), // Space between button and logout

            // Logout Button (Without Icon)
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({required IconData icon, required String title, required VoidCallback onTap}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        trailing: Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
