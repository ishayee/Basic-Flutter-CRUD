import 'package:flutter/material.dart';
import '../services/book_service.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();
  final TextEditingController yearController = TextEditingController();

  void saveBook() async {
    if (titleController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        yearController.text.isNotEmpty) {
      await BookService.addBook(
        titleController.text,
        authorController.text,
        int.tryParse(yearController.text) ?? 0, // Ensure integer parsing
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Book")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: authorController, decoration: InputDecoration(labelText: "Author")),
            TextField(controller: yearController, decoration: InputDecoration(labelText: "Year"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: saveBook, child: Text("Save Book")),
          ],
        ),
      ),
    );
  }
}
