import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/db_helper.dart';
import 'note_form_screen.dart';
import '../services/theme_provider.dart';
import 'package:provider/provider.dart';

class NoteListScreen extends StatefulWidget {
  @override
  _NoteListScreenState createState() => _NoteListScreenState();
}

class _NoteListScreenState extends State<NoteListScreen> {
  List<Note> notes = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    final data = await dbHelper.getNotes();
    setState(() {
      notes = data;
    });
  }

  void _navigateToAddNote() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NoteFormScreen()),
    );
    _loadNotes(); // Reload notes after adding or editing
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('MySimpleNote'),

        actions: [
          Switch(
            value: themeProvider.isDarkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
            activeColor: Colors.greenAccent,
          ),
        ],
      ),
      body: notes.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'lib/assets/bg.png', // home screen pic
              width: 300,
              height: 300,
            ),
            SizedBox(height: 16), // Space between image and text
            Text(
              "No notes yet. Tap + to add a new note!",
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      )
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          final dateToShow = note.modifiedDate; // Show modified date
          final formattedDate =
              '${dateToShow.day}-${dateToShow.month}-${dateToShow.year}';

          return ListTile(
            title: Text(note.title),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(note.content,
                    maxLines: 1, overflow: TextOverflow.ellipsis),
                SizedBox(height: 4),
                Text(
                  'Last edited: $formattedDate',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            leading: Icon(
              Icons.circle,
              color: note.isImportant ? Colors.red : Colors.green,
            ),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NoteFormScreen(note: note),
                ),
              );
              _loadNotes(); // Reload notes after editing
            },

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddNote,
        child: Icon(Icons.add),
        backgroundColor: Colors.greenAccent,
        foregroundColor: Colors.black,
      ),
    );
  }
}
