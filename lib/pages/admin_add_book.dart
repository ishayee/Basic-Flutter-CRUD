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

  void _addBook() async {
    if (titleController.text.isEmpty ||
        authorController.text.isEmpty ||
        isbnController.text.isEmpty ||
        genreController.text.isEmpty ||
        yearController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields")),
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
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Book added successfully")),
    );

    titleController.clear();
    authorController.clear();
    isbnController.clear();
    genreController.clear();
    yearController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add a New Book")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Book Title"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: "Author"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: isbnController,
                decoration: InputDecoration(labelText: "ISBN"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: genreController,
                decoration: InputDecoration(labelText: "Genre"),
              ),
              SizedBox(height: 10),
              TextField(
                controller: yearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Publication Year"),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<bool>(
                value: available,
                decoration: InputDecoration(labelText: "Availability"),
                items: [
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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addBook,
                    child: const Text(
                          "Add Book",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
