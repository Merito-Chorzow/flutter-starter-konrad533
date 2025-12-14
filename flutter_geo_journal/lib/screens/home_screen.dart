import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import 'add_entry_screen.dart';
import 'entry_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JournalService _journalService = JournalService();
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final entries = await _journalService.getEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // --- ZADANIE 3: Funkcja z błędem ---
  String _calculateStats() {
    // BŁĄD: Inicjalizacja jako String "0", co sugeruje tekst
    String total = "0"; 

    print("DEBUG: Rozpoczynam liczenie znaków w tytułach...");

    for (var entry in _entries) {
      // BŁĄD LOGICZNY: Zamiast dodawać liczby, zamieniamy je na tekst i sklejamy
      // W Darcie '+' dla Stringów łączy napisy.
      total += entry.title.length.toString();
    }

    print("DEBUG: Obliczona suma znaków: $total");
    return total;
  }
  // -----------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newEntry = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEntryScreen()),
          );

          if (newEntry != null && newEntry is JournalEntry) {
            setState(() {
              _entries.insert(0, newEntry);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(child: Text('Błąd: $_errorMessage'));
    }

    return RefreshIndicator(
      onRefresh: _loadInitialData,
      child: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          // --- ZADANIE 3: Wyświetlenie błędnych statystyk ---
          Card(
            color: Colors.red.shade100,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Statystyki (Zadanie 3):", 
                    style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 5),
                  Text("Suma znaków w tytułach:"),
                  Text(
                    _calculateStats(), // Wywołanie funkcji z błędem
                    style: const TextStyle(
                      color: Colors.red, 
                      fontWeight: FontWeight.bold, 
                      fontSize: 18
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // --------------------------------------------------

          if (_entries.isEmpty)
            const Center(child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Text('Brak wpisów. Dodaj pierwszy!'),
            ))
          else
            ..._entries.map((entry) => Card(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: ListTile(
                leading: entry.imagePath != null
                    ? const CircleAvatar(child: Icon(Icons.camera_alt))
                    : const CircleAvatar(child: Icon(Icons.place)),
                title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(DateFormat('dd.MM.yyyy – HH:mm').format(entry.date)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EntryDetailsScreen(entry: entry)),
                  );
                },
              ),
            )),
        ],
      ),
    );
  }
}