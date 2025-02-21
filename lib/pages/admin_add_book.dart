import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminAddBookScreen extends StatefulWidget {
  @override
  _AdminAddBookScreenState createState() => _AdminAddBookScreenState();
}

class _AdminAddBookScreenState extends State<AdminAddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController isbnController = TextEditingController();
  final TextEditingController genreController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  bool available = true;

  /// **Add Book to Firestore**
  void _addBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        isbnController.text.isEmpty ||
        genreController.text.isEmpty ||
        yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all fields")),
      );
      return;
    }

    await FirebaseFirestore.instance.collection('books').add({
      'title': titleController.text,
      'author': authorController.text,
      'isbn': isbnController.text,
      'genre': genreController.text,
      'year': yearController.text,
      'available': available,
      'isDeleted': false, // ✅ Ensure 'isDeleted' is set to a boolean value
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Book added successfully")),
    );

    // Clear input fields
    titleController.clear();
    authorController.clear();
    isbnController.clear();
    genreController.clear();
    yearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add a New Book")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Book Title"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: "Author"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: isbnController,
                decoration: const InputDecoration(labelText: "ISBN"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: genreController,
                decoration: const InputDecoration(labelText: "Genre"),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Publication Year"),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<bool>(
                value: available,
                decoration: const InputDecoration(labelText: "Availability"),
                items: const [
                  DropdownMenuItem(
                    child: Text("Available"),
                    value: true,
                  ),
                  DropdownMenuItem(
                    child: Text("Not Available"),
                    value: false,
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    available = value!;
                  });
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Add Book",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
