import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal_entry.dart';

class JournalService {
  final String baseUrl = 'https://jsonplaceholder.typicode.com'; // url API

// Nagłówki HTTP, udają przeglądarkę, aby uniknąć blokad serwera (error 403)
  final Map<String, String> _headers = {
    "Content-Type": "application/json; charset=UTF-8",
    "User-Agent": "FlutterGeoJournalApp/1.0 (Android emulator)",
  };

  // Pobieranie listy wpisów
  Future<List<JournalEntry>> getEntries() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/posts?_limit=5'),
        headers: _headers,
      );

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
        print("API zwróciło błąd ${response.statusCode}, ale dodaje lokalnie.");
        return null;
      }
    } 
    catch (e) {
      print("Brak sieci. Dodaję lokalnie. Błąd: $e");
      return null;
    }
  }

  // Edycja istniejącego wpisu
  Future<JournalEntry?> updateEntry(JournalEntry entry) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/posts/${entry.id}'),
        body: jsonEncode(entry.toJson()),
        headers: _headers
      );

      if (response.statusCode == 200) {
        return entry;
      } 
      else {
        print("Api nie rozpoznaje ID. (Aktlizauję loklanie).");
        return entry;
      }
    } 
    catch (e) {
      print("Błąd API przy edycji: $e. (Symulacja sukcesu.)");
      return entry;
    }
  }
}