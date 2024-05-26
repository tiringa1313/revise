import 'package:flutter/material.dart';

import 'telas/NotesScreen.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(BookNotesApp());
}

class BookNotesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Book Notes Review',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revise'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 24), // Espaço entre o AppBar e o botão

          Center(
            child: SizedBox(
              width: 360, // Largura do botão
              height: 60, // Altura do botão
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotesScreen()),
                  );
                },
                child: Text('Adicionar Anotação'),
              ),
            ),
          ),

          SizedBox(height: 24), // Espaço entre o AppBar e o botão
          Center(
            child: SizedBox(
              width: 360, // Largura do botão
              height: 60, // Altura do botão
              child: ElevatedButton(
                onPressed: () {},
                child: Text('Cadastrar Livro'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
