import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import 'add_entry_screen.dart';

// class EntryDetailsScreen extends StatelessWidget { 
class EntryDetailsScreen extends StatefulWidget {
  final JournalEntry entry;

  const EntryDetailsScreen({super.key, required this.entry});

  @override
  State<EntryDetailsScreen> createState() => _EntryDetailsScreenState();
}

class _EntryDetailsScreenState extends State<EntryDetailsScreen> {
  late JournalEntry _currentEntry;

  @override
  void initState() {
    super.initState();
    _currentEntry = widget.entry;
  }

  Future<void> _editEntry() async {
    final updatedEntry = await Navigator.push(
      context,
      MaterialPageRoute(
        builder:(context) => AddEntryScreen(entryToEdit: _currentEntry),
      ),
    );

    if (updatedEntry != null && updatedEntry is JournalEntry) {
      setState(() {
        _currentEntry = updatedEntry;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_currentEntry.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _editEntry,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (_currentEntry.imagePath != null)
              Image.file(
                File(_currentEntry.imagePath!),
                height: 300,
                fit: BoxFit.cover,
              )
            else
              Container(
                height: 200,
                color: Colors.grey[200],
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
                    Text('Brak obrazu', style: TextStyle(color: Colors.grey)),
                  ],
                )
              ),
            
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_month, color: Colors.teal),
                      const SizedBox(width: 8.0),
                      Text(
                        DateFormat('dd-MMM-yyyy, HH:mm', 'pl_PL').format(_currentEntry.date),
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.grey, // może zmienić na tael, zobaczyć na emulatorze
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),

                  Text(
                    _currentEntry.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),

                  Text(
                    _currentEntry.description,
                    style: const TextStyle(fontSize: 16.0, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}