import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/db_helper.dart';

class NoteFormScreen extends StatefulWidget {
  final Note? note; // this is an edit screen

  NoteFormScreen({this.note});

  @override
  _NoteFormScreenState createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final dbHelper = DatabaseHelper();
  String _title = '';
  String _content = '';
  bool _isImportant = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _title = widget.note!.title;
      _content = widget.note!.content;
      _isImportant = widget.note!.isImportant;
    }
  }

  void _saveNote() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final now = DateTime.now();
      final newNote = Note(
        id: widget.note?.id,
        title: _title,
        content: _content,
        createdDate: widget.note?.createdDate ?? now,
        modifiedDate: now,
        isImportant: _isImportant,
      );

      if (widget.note == null) {
        await dbHelper.insertNote(newNote);
      } else {
        await dbHelper.updateNote(newNote);
      }
      Navigator.pop(context); // Go back to the list screen
    }
  }

  Future<void> _deleteNote() async {
    if (widget.note?.id != null) {
      await dbHelper.deleteNote(widget.note!.id!);
      Navigator.pop(context); // Close the form after delete
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Note' : 'Edit Note'),
        actions: [
          if (widget.note != null) // Show delete button only if editing an existing note
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: _deleteNote,
            ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveNote,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _title,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },

                decoration: InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(), // Simple rectangular border
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.greenAccent), // Color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey), // Color when enabled
                  ),
                ),
                onSaved: (value) {
                  _title = value!;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(), // Simple rectangular border
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue), // Color when focused
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                maxLines: 8,
                onSaved: (value) {
                  _content = value!;
                },
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Mark as Important'),
                  Switch(
                    value: _isImportant,
                    onChanged: (value) {
                      setState(() {
                        _isImportant = value;
                      });
                    },activeColor: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
