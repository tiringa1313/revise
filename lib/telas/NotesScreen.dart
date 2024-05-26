import 'package:flutter/material.dart';
import 'camera_screen.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> _notes = [];

  void _addNoteFromCamera() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CameraScreen()),
    ).then((scannedText) {
      if (scannedText != null && scannedText.isNotEmpty) {
        setState(() {
          _notes.add(scannedText);
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minhas Anotações'),
      ),
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNoteFromCamera,
        child: Icon(Icons.add),
      ),
    );
  }
}
