import 'dart:convert';
import 'package:http/http.dart' as http;

class BookService {
  static const String baseUrl = 'http://10.0.2.2:8000/api/books';

  // ✅ Fetch all books
  static Future<List<dynamic>> getBooks() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> books = jsonDecode(response.body);
      return books.map((book) => {
        "id": book["id"],
        "title": book["title"],
        "author": book["author"],
        "year": int.tryParse(book["year"].toString()) ?? 0, // Ensure it's an int
      }).toList();
    } else {
      throw Exception('Failed to load books');
    }
  }

  // ✅ Add a new book
  static Future<void> addBook(String title, String author, int year) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "author": author, "year": year}),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add book');
    }
  }

  // ✅ Update a book
  static Future<void> editBook(int id, String title, String author, int year) async {
    final response = await http.put(
      Uri.parse("$baseUrl/$id"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"title": title, "author": author, "year": year}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update book');
    }
  }

  // ✅ Delete a book
  static Future<void> deleteBook(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete book');
    }
  }
}
