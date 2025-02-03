import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:labproject/pages/admin_add_book.dart';
import 'package:labproject/pages/admin_edit_book.dart';


class AdminViewBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book List")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('books').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var books = snapshot.data!.docs;

          return ListView.builder(
            padding: EdgeInsets.all(8.0),
            itemCount: books.length,
            itemBuilder: (context, index) {
              var book = books[index].data() as Map<String, dynamic>;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                child: ListTile(
                  contentPadding: EdgeInsets.all(10),
                  leading: Icon(
                    Icons.book,
                    size: 40,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    book['title'] ?? 'No Title',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Author: ${book['author'] ?? 'Unknown'}"),
                      Text("Genre: ${book['genre'] ?? 'N/A'}"),
                      Text("Year: ${book['year'] ?? 'N/A'}"),
                      SizedBox(height: 5),
                      Text(
                        book['available'] == true
                            ? "Available ✅"
                            : "Not Available ❌",
                        style: TextStyle(
                          color: book['available'] == true
                              ? Colors.green
                              : Colors.red,
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
                                bookId: books[index].id, // ✅ Pass Book ID
                                bookData: book, // ✅ Pass Book Data
                              ),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          FirebaseFirestore.instance
                              .collection('books')
                              .doc(books[index].id)
                              .delete();
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
}
