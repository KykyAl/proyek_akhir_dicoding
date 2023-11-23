import 'package:catatan/widget/my_drawer.dart';
import 'package:catatan/widget/percentage_card.dart';
import 'package:catatan/widget/task_builder.dart';
import 'package:catatan/widget/task_group.dart';
import 'package:flutter/material.dart';

class UserTaskScreen extends StatelessWidget {
  const UserTaskScreen({super.key});
  static const routeName = '/user-task';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tugas'),
      ),
      drawer: const MyDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PrecentageCard(),
            const SizedBox(
              height: 10,
            ),
            textDecoration('Group', context),
            const TaskGroup(),
            const SizedBox(height: 10),
            textDecoration('Tugas', context),
            const TaskBuilder(filter: 'Kosong')
          ],
        ),
      ),
    );
  }

  Widget textDecoration(String text, BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      margin: const EdgeInsets.only(left: 10, bottom: 10),
      width: isLandscape
          ? mediaQuery.size.width * 0.2
          : mediaQuery.size.width * 0.4,
      height: isLandscape
          ? mediaQuery.size.height * 0.06
          : mediaQuery.size.height * 0.06,
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(15)),
          color: Theme.of(context).colorScheme.primary),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
              fontSize: mediaQuery.textScaleFactor * 20, color: Colors.white),
        ),
      ),
    );
  }
}
