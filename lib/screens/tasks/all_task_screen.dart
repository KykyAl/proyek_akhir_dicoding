import 'package:catatan/widget/my_drawer.dart';
import 'package:catatan/widget/task_builder.dart';
import 'package:flutter/material.dart';

class AllTask extends StatelessWidget {
  const AllTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Semua Tugas'),
      ),
      drawer: const MyDrawer(),
      body: const SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: TaskBuilder(filter: 'Kosong')),
      ),
    );
  }
}
