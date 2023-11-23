import 'package:catatan/widget/my_drawer.dart';
import 'package:catatan/widget/notes_builder.dart';
import 'package:flutter/material.dart';

class UserNoteScreen extends StatelessWidget {
  static const routeName = '/user-notes';
  const UserNoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Catatan'),
        ),
        drawer: const MyDrawer(),
        body: const NotesBuilder());
  }
}
