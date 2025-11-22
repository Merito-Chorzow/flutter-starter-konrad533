import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';
import 'add_entry_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JournalService _journalService = JournalService();
  late Future<List<JournalEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _entriesFuture = _journalService.getEntries();
  }

  Future<void> _refreshEntries() async {
    setState(() {
      _entriesFuture = _journalService.getEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geo Journal'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<JournalEntry>>(
        future: _entriesFuture,
        builder: (context, snapshot) {
          
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 48),
                const SizedBox(height: 10),
                Text('Wystąpił błąd: ${snapshot.error}'),
                ElevatedButton(
                  onPressed: _refreshEntries,
                  child: const Text('Spróbuj ponownie'),
                ),
              ],
            ),
          );
        }

        final entries = snapshot.data ?? [];

        if (entries.isEmpty) {
          return const Center(child: Text('Brak wpisów w dzienniku. Dodaj pierwszy wpis!'));
        }

        return RefreshIndicator(
          onRefresh: _refreshEntries,
          child: ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.place)
                  ),
                  title: Text(
                    entry.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    DateFormat('dd.MM.yyyy – HH:mm').format(entry.date),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    print('Kliknięto wpis: ${entry.title}');
                    // tutaj później dodać przejście do szczegółów wpisu
                  },
                ),
              );
            },
          ),
        );
      },
    ),

    floatingActionButton: FloatingActionButton(
      onPressed: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddEntryScreen()),
        );
        if (result == true) {
          _refreshEntries();
        }
      },
      child: const Icon(Icons.add),
    ),
  );
  }
}