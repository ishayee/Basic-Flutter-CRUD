import 'package:flutter/material.dart';
import '../services/book_service.dart';

class EditBookScreen extends StatefulWidget {
  final Map book;
  EditBookScreen({required this.book});

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  late TextEditingController titleController;
  late TextEditingController authorController;
  late TextEditingController yearController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.book["title"]);
    authorController = TextEditingController(text: widget.book["author"]);
    yearController = TextEditingController(text: widget.book["year"].toString()); // Ensure it's a string
  }

  void updateBook() async {
    if (titleController.text.isNotEmpty &&
        authorController.text.isNotEmpty &&
        yearController.text.isNotEmpty) {
      await BookService.editBook(
        widget.book["id"],
        titleController.text,
        authorController.text,
        int.tryParse(yearController.text) ?? 0, // Fix String -> Int issue
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Book")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: titleController, decoration: InputDecoration(labelText: "Title")),
            TextField(controller: authorController, decoration: InputDecoration(labelText: "Author")),
            TextField(controller: yearController, decoration: InputDecoration(labelText: "Year"), keyboardType: TextInputType.number),
            SizedBox(height: 20),
            ElevatedButton(onPressed: updateBook, child: Text("Update Book")),
          ],
        ),
      ),
    );
  }
}
