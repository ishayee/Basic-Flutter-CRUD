import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDeletedBooksScreen extends StatefulWidget {
  @override
  _AdminDeletedBooksScreenState createState() => _AdminDeletedBooksScreenState();
}

class _AdminDeletedBooksScreenState extends State<AdminDeletedBooksScreen> {
  Set<String> selectedBooks = {}; // Store selected books' IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Deleted Books"),
        actions: [
          if (selectedBooks.isNotEmpty)
            IconButton(
              icon: Icon(Icons.restore),
              onPressed: _restoreSelectedBooks,
            ),
          if (selectedBooks.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.red),
              onPressed: _confirmDeleteSelectedBooks,
            ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('isDeleted', isEqualTo: true)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No deleted books"));
          }

          var deletedBooks = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: deletedBooks.length,
            itemBuilder: (context, index) {
              var bookData = deletedBooks[index].data() as Map<String, dynamic>;
              String bookId = deletedBooks[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  leading: Checkbox(
                    value: selectedBooks.contains(bookId),
                    onChanged: (bool? checked) {
                      setState(() {
                        if (checked == true) {
                          selectedBooks.add(bookId);
                        } else {
                          selectedBooks.remove(bookId);
                        }
                      });
                    },
                  ),
                  title: Text(
                    bookData['title'] ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Author: ${bookData['author'] ?? 'Unknown'}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.restore, color: Colors.green),
                        onPressed: () => _restoreBook(bookId),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () => _confirmDeleteBook(bookId),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _restoreBook(String bookId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).update({
      'isDeleted': false,
    });
    _showSnackBar("Book restored successfully");
  }

  void _restoreSelectedBooks() async {
    for (String bookId in selectedBooks) {
      await FirebaseFirestore.instance.collection('books').doc(bookId).update({
        'isDeleted': false,
      });
    }
    setState(() => selectedBooks.clear());
    _showSnackBar("Selected books restored successfully");
  }

  void _confirmDeleteBook(String bookId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Book"),
        content: Text("Are you sure you want to permanently delete this book?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _permanentlyDeleteBook(bookId);
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSelectedBooks() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Delete Selected Books"),
        content: Text("Are you sure you want to permanently delete the selected books?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _permanentlyDeleteSelectedBooks();
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _permanentlyDeleteBook(String bookId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
    _showSnackBar("Book permanently deleted");
  }

  void _permanentlyDeleteSelectedBooks() async {
    for (String bookId in selectedBooks) {
      await FirebaseFirestore.instance.collection('books').doc(bookId).delete();
    }
    setState(() => selectedBooks.clear());
    _showSnackBar("Selected books permanently deleted");
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: Duration(seconds: 2)),
    );
  }
}
