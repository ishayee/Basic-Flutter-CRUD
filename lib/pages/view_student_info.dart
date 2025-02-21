import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labproject/pages/student_form.dart';

class ViewStudentInfo extends StatefulWidget {
  @override
  _ViewStudentInfoState createState() => _ViewStudentInfoState();
}

class _ViewStudentInfoState extends State<ViewStudentInfo> {
  String? studentName;
  String? studentId;
  String? studentEmail;
  String? studentProgramme;
  String? studentPhone;
  String? studentDOB;
  bool isLoading = true;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _fetchStudentInfo();
  }

  Future<void> _fetchStudentInfo() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        setState(() {
          studentName = "No User Logged In";
          studentId = "Not Provided";
          studentEmail = "No Email";
          studentProgramme = "Not Provided";
          studentPhone = "Not Provided";
          studentDOB = "Not Provided";
          isLoading = false;
        });
        return;
      }

      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('users').doc(user.uid).get();

      if (userDoc.exists) {
        setState(() {
          studentName = userDoc['name'] ?? "No Name";
          studentId = userDoc.data().toString().contains('studentid') 
                      ? userDoc['studentid'] ?? "Not Provided" 
                      : "Not Provided";
          studentEmail = userDoc['email'] ?? "No Email";
          studentProgramme = userDoc.data().toString().contains('programme')
                      ? userDoc['programme'] ?? "Not Provided"
                      : "Not Provided";
          studentPhone = userDoc.data().toString().contains('phone') 
                      ? userDoc['phone'] ?? "Not Provided" 
                      : "Not Provided";
          studentDOB = userDoc.data().toString().contains('dob')
                      ? userDoc['dob'] ?? "Not Provided"
                      : "Not Provided";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching student info: $e");
      setState(() => isLoading = false);
    }
  }

  void _navigateToEditForm() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentForm(
          currentName: studentName ?? '',
          currentstudentId: studentId ?? '',
          currentEmail: studentEmail ?? '',
          currentProgramme: studentProgramme ?? '',
          currentPhone: studentPhone ?? '',
          currentDOB: studentDOB ?? '',
        ),
      ),
    );

    if (result != null) {
      setState(() {
        studentName = result['name'];
        studentId = result['studentid'];
        studentEmail = result['email'];
        studentProgramme = result['programme'];
        studentPhone = result['phone'];
        studentDOB = result['dob'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Student Information"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow("Name", studentName),
                          _infoRow("Student ID", studentId),
                          _infoRow("Email", studentEmail),
                          _infoRow("Programme", studentProgramme),
                          _infoRow("Phone", studentPhone),
                          _infoRow("Date of Birth", studentDOB),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: _navigateToEditForm,
                    icon: const Icon(Icons.edit, color: Colors.white),
                    label: const Text("Edit Info", style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _infoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          Expanded(child: Text(value ?? "Not Provided", style: const TextStyle(fontSize: 16, color: Colors.black87))),
        ],
      ),
    );
  }
}
