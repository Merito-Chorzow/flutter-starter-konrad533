import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import '../models/journal_entry.dart';
import '../services/journal_service.dart';

class AddEntryScreen extends StatefulWidget {
  const AddEntryScreen({super.key});

  @override
  State<AddEntryScreen> createState() => _AddEntryScreenState();
}

class _AddEntryScreenState extends State<AddEntryScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  File? _selectedImage;

  bool _isSubmitting = false;

  final JournalService _journalService = JournalService();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: source);

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    }
    catch (e) {
      print('Błąd przy wybieraniu obrazu: $e');
    }
  }


  Future<void> _submitForm() async {
    if (_titleController.text.isEmpty || _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Proszę wypełnić pole tytułu i opisu.')),
      );
      return;
    }
    
    setState(() {
      _isSubmitting = true;
    });

    final newEntry = JournalEntry(
      id: const Uuid().v4(),
      title: _titleController.text,
      description: _descriptionController.text,
      date: DateTime.now(),
      imagePath: _selectedImage?.path,
    );

    // final success = await _journalService.addEntry(newEntry);
    final createdEntry = await _journalService.addEntry(newEntry);

    setState(() {
      _isSubmitting = false;
    });

    // if (success) {
    if (createdEntry != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wpis dodany pomyślnie! (testowo)')),
        );
        // Navigator.of(context).pop(true);
        Navigator.of(context).pop(createdEntry);
      }
    } 
    else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Błąd przy dodawaniu wpisu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dodaj nowy wpis')
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Tytuł',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            TextField(
              controller: _descriptionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Opis wydarzenia',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),

            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: _selectedImage != null
                ? Image.file(_selectedImage!, fit: BoxFit.cover)
                : const Center(child: Text('Brak obrazu')),
            ),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera), 
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Aparat'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery), 
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Galeria'),
                ),
              ],
            ),
            const SizedBox(height: 30),

            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                  ? const CircularProgressIndicator(
                    color: Colors.white
                  )
                  : const Text(
                    'Zapisz wpis',
                    style: TextStyle(fontSize: 18)
                  ),
              ),
            )
          ],
        )
      )
    );
  }
}