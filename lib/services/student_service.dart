import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StudentService {
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  Future<void> addStudentInfo(String name, String phone, String studentId) async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    try {
      // Update the student document with name, phone, and studentId
      await users.doc(uid).update({
        'name': name,
        'phone': phone,
        'studentid': studentId,  // Use the passed studentId
        'borrowedBooks': [],  // Initialize with an empty list
      });

      print("Student info updated successfully");
    } catch (e) {
      print("Error updating student info: $e");
      throw e; // Handle any error
    }
  }
}
