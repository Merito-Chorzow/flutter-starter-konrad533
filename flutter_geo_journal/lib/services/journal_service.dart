import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal_entry.dart';

class JournalService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com'; // url API

  // Pobieranie listy wpisów
  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/posts?_limit=5'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((item) => JournalEntry.fromJson(item)).toList();
      } 
      else {
        throw Exception('Błąd serwera: ${response.statusCode}');
      }
    } 
    catch (e) {
      throw Exception('Błąd połączenia: $e');
    }
  }

  // Dodanie nowego wpisu
  // Future<bool> addEntry(JournalEntry entry) async {
  Future<JournalEntry?> addEntry(JournalEntry entry) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/posts'),
        body: jsonEncode(entry.toJson()),
        headers: {
          "Content-Type": "application/json; charset=UTF-8"
        },
      );

      if (response.statusCode == 201) {
        return entry;
      } 
      else {
        return null;
      }
    } 
    catch (e) {
      return null;
    }
  }

}