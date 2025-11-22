class JournalEntry {
  final String id;
  final String title;
  final String description;
  final DateTime date;
  final String? imagePath;

  JournalEntry({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    this.imagePath,
  });

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'].toString(),
      title: json['title'] ?? 'Bez tytułu',
      description: json['description'] ?? '',
      date: DateTime.now(),
      imagePath: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': description,
      'userId': 1,
    };
  }
}