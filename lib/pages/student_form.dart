import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentForm extends StatefulWidget {
  final String currentName;
  final String currentstudentId;
  final String currentEmail;
  final String currentProgramme;
  final String currentPhone;
  final String currentDOB;

  StudentForm({
    required this.currentName,
    required this.currentstudentId,
    required this.currentEmail,
    required this.currentProgramme,
    required this.currentPhone,
    required this.currentDOB,
  });

  @override
  _StudentFormState createState() => _StudentFormState();
}

class _StudentFormState extends State<StudentForm> {
  final _formKey = GlobalKey<FormState>();
  String? name;
  String? studentid;
  String? email;
  String? programme;
  String? phone;
  String? dob;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    name = widget.currentName;
    studentid = widget.currentstudentId;
    email = widget.currentEmail;
    programme = widget.currentProgramme;
    phone = widget.currentPhone;
    dob = widget.currentDOB;
  }

  Future<void> _updateStudentInfo() async {
    if (_formKey.currentState!.validate()) {
      String uid = _auth.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'name': name,
        'studentid': studentid,
        'email': email,
        'programme': programme,
        'phone': phone,
        'dob': dob,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Information Updated Successfully!')),
      );

      Navigator.pop(context, {
        'name': name,
        'studentid': studentid,
        'email': email,
        'programme': programme,
        'phone': phone,
        'dob': dob,
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: dob != null && dob!.isNotEmpty
          ? DateTime.tryParse(dob!) ?? DateTime.now()
          : DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        dob = "${pickedDate.toLocal()}".split(' ')[0]; // Format YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Student Info"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: InputDecoration(labelText: "Name"),
                onChanged: (value) => name = value,
                validator: (value) => value!.isEmpty ? "Name cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: studentid,
                decoration: InputDecoration(labelText: "Student ID"),
                onChanged: (value) => studentid = value,
                validator: (value) => value!.isEmpty ? "Student ID cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: email,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (value) => email = value,
                validator: (value) => value!.isEmpty ? "Email cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: programme,
                decoration: InputDecoration(labelText: "Programme"),
                onChanged: (value) => programme = value,
                validator: (value) => value!.isEmpty ? "Programme cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                initialValue: phone,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (value) => phone = value,
                validator: (value) => value!.isEmpty ? "Phone cannot be empty" : null,
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: TextEditingController(text: dob),
                readOnly: true,
                decoration: InputDecoration(
                  labelText: "Date Of Birth",
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () => _selectDate(context),
                validator: (value) => value!.isEmpty ? "Date Of Birth cannot be empty" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudentInfo,
                child: Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
