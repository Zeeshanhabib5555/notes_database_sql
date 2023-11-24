import 'package:flutter/material.dart';
import 'package:notes_database_sql/NoteKeeperApp/screens/note_list_page.dart';
import 'package:notes_database_sql/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: NoteList(),
    );
  }
}
