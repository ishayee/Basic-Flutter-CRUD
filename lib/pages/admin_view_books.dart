import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labproject/pages/admin_add_book.dart';
import 'package:labproject/pages/admin_edit_book.dart';
import 'package:labproject/pages/admin_deleted_books.dart'; // New Page for Deleted Books

class AdminViewBooksScreen extends StatefulWidget {
  @override
  _AdminViewBooksScreenState createState() => _AdminViewBooksScreenState();
}

class _AdminViewBooksScreenState extends State<AdminViewBooksScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Book List"),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            tooltip: "View Deleted Books",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AdminDeletedBooksScreen()),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('isDeleted', isEqualTo: false) // Show only non-deleted books
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("No books found"));
          }

          var books = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              var bookData = books[index].data() as Map<String, dynamic>;
              String bookId = books[index].id;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  title: Text(
                    bookData['title'] ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Author: ${bookData['author'] ?? 'Unknown'}"),
                      Text("Genre: ${bookData['genre'] ?? 'N/A'}"),
                      Text("Year: ${bookData['year'] ?? 'N/A'}"),
                      SizedBox(height: 5),
                      Text(
                        bookData['available'] == true ? "Available ✅" : "Not Available ❌",
                        style: TextStyle(
                          color: bookData['available'] == true ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.orange),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminEditBookScreen(
                                bookId: bookId,
                                bookData: bookData,
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _moveToDeletedBooks(bookId);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminAddBookScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: "Add a New Book",
      ),
    );
  }

  /// **Move book to deleted list (Soft Delete)**
  void _moveToDeletedBooks(String bookId) async {
    await FirebaseFirestore.instance.collection('books').doc(bookId).update({
      'isDeleted': true, // Mark as deleted
    });
  }
}
