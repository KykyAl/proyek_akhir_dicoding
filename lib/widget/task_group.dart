import 'package:catatan/provider/tasks_provider.dart';
import 'package:catatan/screens/tasks/group_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskGroup extends StatelessWidget {
  const TaskGroup({super.key});

  @override
  Widget build(BuildContext context) {
    final groupMap = Provider.of<TaskProvider>(context).taskGroup;
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          group('Office', groupMap['office']!, context),
          group('Home', groupMap['home']!, context),
          group('Rencana', groupMap['rencana']!, context)
        ],
      ),
    );
  }

  Widget group(String title, String imagePath, BuildContext context) {
    final colorTheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) {
            return GroupScreen(title);
          },
        ));
      },
      child: Container(
        height: isLandscape
            ? mediaQuery.size.width * 0.13
            : mediaQuery.size.height * 0.13,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(20)),
            border: Border.all(
                color: colorTheme.secondary,
                width: mediaQuery.size.width * 0.01)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: isLandscape
                  ? mediaQuery.size.width * 0.05
                  : mediaQuery.size.height * 0.05,
              width: mediaQuery.size.width * 0.23,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(imagePath), fit: BoxFit.contain)),
            ),
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: mediaQuery.textScaleFactor * 20),
            )
          ],
        ),
      ),
    );
  }
}
