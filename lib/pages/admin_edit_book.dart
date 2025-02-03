import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminEditBookScreen extends StatefulWidget {
  final String bookId;
  final Map<String, dynamic> bookData;

  const AdminEditBookScreen({
    Key? key,
    required this.bookId,
    required this.bookData,
  }) : super(key: key);

  @override
  _AdminEditBookScreenState createState() => _AdminEditBookScreenState();
}

class _AdminEditBookScreenState extends State<AdminEditBookScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _genreController;
  late TextEditingController _yearController;
  late TextEditingController _isbnController;
  bool _available = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.bookData['title']);
    _authorController = TextEditingController(text: widget.bookData['author']);
    _genreController = TextEditingController(text: widget.bookData['genre']);
    _yearController = TextEditingController(text: widget.bookData['year'].toString());
    _isbnController = TextEditingController(text: widget.bookData['isbn'] ?? '');
    _available = widget.bookData['available'] is bool
        ? widget.bookData['available']
        : (widget.bookData['available'].toString().toLowerCase() == 'true');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _genreController.dispose();
    _yearController.dispose();
    _isbnController.dispose();
    super.dispose();
  }

  Future<void> _updateBook() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('books').doc(widget.bookId).update({
          'title': _titleController.text,
          'author': _authorController.text,
          'genre': _genreController.text,
          'year': _yearController.text, // Keep as string to match Firestore
          'isbn': _isbnController.text,  // Update ISBN
          'available': _available,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Book updated successfully")),
        );

        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error updating book: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Book"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextField(_titleController, "Book Title"),
                    const SizedBox(height: 10),
                    _buildTextField(_authorController, "Author"),
                    const SizedBox(height: 10),
                    _buildTextField(_genreController, "Genre"),
                    const SizedBox(height: 10),
                    _buildTextField(_yearController, "Publication Year"),
                    const SizedBox(height: 10),
                    _buildTextField(_isbnController, "ISBN"), // Add ISBN field
                    const SizedBox(height: 15),
                    SwitchListTile(
                      title: const Text("Available"),
                      value: _available,
                      activeColor: Colors.deepPurple,
                      onChanged: (bool value) {
                        setState(() {
                          _available = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateBook,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Update Book",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label cannot be empty";
        }
        return null;
      },
    );
  }
}
