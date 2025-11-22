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
  // late Future<List<JournalEntry>> _entriesFuture;

  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // _entriesFuture = _journalService.getEntries();
    _loadInitialData();
  }


  // Future<void> _refreshEntries() async {
  Future<void> _loadInitialData() async {
    setState(() {
      // _entriesFuture = _journalService.getEntries();
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final entries = await _journalService.getEntries();
      setState(() {
        _entries = entries;
        _isLoading = false;
      });
    } 
    catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        centerTitle: true,
      ),
      // body: FutureBuilder<List<JournalEntry>>(
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
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 10.0),
            Text('Błąd: $_errorMessage'),
            ElevatedButton(
              onPressed: _loadInitialData, 
              child: const Text('Spróbuj ponownie')
            )
          ],
        ),
      );
    }

    // final entries = snapshot.data ?? [];

    if (_entries.isEmpty) {
      return const Center(child: Text('Brak wpisów w dzienniku. Dodaj pierwszy wpis!'));
    }

    return RefreshIndicator(
      // onRefresh: _refreshEntries,
      onRefresh: _loadInitialData,
      child: ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: entry.imagePath != null
              ? const CircleAvatar(
                child: Icon(Icons.camera_alt))
              : const CircleAvatar(
                child: Icon(Icons.place)),
              title: Text(
                entry.title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                DateFormat('dd.MM.yyyy – HH:mm').format(entry.date),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // print('Kliknięto wpis: ${entry.title}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EntryDetailsScreen(entry: entry)
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}