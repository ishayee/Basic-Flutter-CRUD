import 'package:flutter/material.dart';
import '../services/book_service.dart';
import 'add_book.dart';
import 'edit_book.dart';

class BookList extends StatefulWidget {
  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List books = [];
  bool isLoading = true; // Added for UI

  void fetchBooks() async {
    final data = await BookService.getBooks();
    setState(() {
      books = data;
      isLoading = false; // Hide loading spinner
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Book List")),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Loading spinner
          : books.isEmpty
              ? Center(child: Text("No books available"))
              : ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 3,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(books[index]['title'], style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Author: ${books[index]['author']}"),
                            Text("Year: ${books[index]['year']}"),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookScreen(book: books[index]),
                                ),
                              ).then((_) => fetchBooks()),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                await BookService.deleteBook(books[index]['id']);
                                fetchBooks();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddBookScreen()),
        ).then((_) => fetchBooks()),
        child: Icon(Icons.add),
      ),
    );
  }
}
