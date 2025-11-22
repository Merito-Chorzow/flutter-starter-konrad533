import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const GeoJournalApp());
}

class GeoJournalApp extends StatelessWidget {
  const GeoJournalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geo Journal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}