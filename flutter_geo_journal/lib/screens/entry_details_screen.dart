import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';

class EntryDetailsScreen extends StatelessWidget { 
  final JournalEntry entry;

  const EntryDetailsScreen({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (entry.imagePath != null)
              Image.file(
                File(entry.imagePath!),
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
                        DateFormat('dd-MMM-yyyy, HH:mm', 'pl_PL').format(entry.date),
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
                    entry.title,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 10.0),

                  Text(
                    entry.description,
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