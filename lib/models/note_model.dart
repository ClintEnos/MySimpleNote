class Note {
  int? id;
  String title;
  String content;
  DateTime createdDate;
  DateTime modifiedDate;
  bool isImportant;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.createdDate,
    required this.modifiedDate,
    this.isImportant = false,
  });

  // Convert a Note into a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdDate': createdDate.toIso8601String(),
      'modifiedDate': modifiedDate.toIso8601String(),
      'isImportant': isImportant ? 1 : 0,
    };
  }

  // Convert a Map into a Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      content: map['content'],
      createdDate: DateTime.parse(map['createdDate']),
      modifiedDate: DateTime.parse(map['modifiedDate']),
      isImportant: map['isImportant'] == 1,
    );
  }
}
