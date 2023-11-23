import 'package:catatan/provider/user_provider.dart';
import 'package:catatan/screens/note/add_note_screen.dart';
import 'package:catatan/screens/note/user_note_screen.dart';
import 'package:catatan/screens/tasks/add_task.dart';
import 'package:catatan/screens/tasks/all_task_screen.dart';
import 'package:catatan/screens/tasks/user_task_screen.dart';
import 'package:catatan/screens/user_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Tabs extends StatefulWidget {
  static const routeName = '/tabs-page';
  const Tabs({super.key});

  @override
  State<Tabs> createState() => _TabsState();
}

class _TabsState extends State<Tabs> with SingleTickerProviderStateMixin {
  int currentIndex = 0;
  final List tabs = [
    const UserTaskScreen(),
    const AllTask(),
    const UserNoteScreen(),
    const UserDetailScreen()
  ];

  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;
  late Animation<double> _translateButton;

  bool _isExpanded = false;
  bool isInit = false;

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000))
      ..addListener(() {
        setState(() {});
      });

    _buttonAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    _translateButton = Tween<double>(begin: 100, end: -5).animate(
        CurvedAnimation(
            parent: _animationController, curve: Curves.bounceInOut));
    isInit = true;
    super.initState();
  }

  void didChangeDependemcies() {
    if (isInit) {
      getThemeData();
      isInit = false;
    }
    super.didChangeDependencies();
  }

  _toggle() {
    if (_isExpanded) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    _isExpanded = !_isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final darkTheme = Provider.of<UserProvider>(context).isDark;
    return Scaffold(
      body: tabs[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: color,
        selectedItemColor: Colors.white,
        unselectedItemColor:
            darkTheme ? const Color.fromARGB(255, 0, 0, 0) : null,
        iconSize: isLandscape
            ? MediaQuery.of(context).size.height * 0.07
            : MediaQuery.of(context).size.width * 0.07,
        items: [
          BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'Home',
              backgroundColor: color),
          BottomNavigationBarItem(
              icon: const Icon(Icons.task),
              label: 'Tugas',
              backgroundColor: color),
          BottomNavigationBarItem(
              icon: const Icon(Icons.notes),
              label: 'Catatan',
              backgroundColor: color),
          BottomNavigationBarItem(
              icon: const Icon(Icons.account_circle),
              label: 'Profil',
              backgroundColor: color),
        ],
        onTap: (value) {
          setState(() {
            currentIndex = value;
          });
        },
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 3, 0.0),
              child: FloatingActionButton(
                heroTag: 'task-btn',
                onPressed: () {
                  Navigator.pushNamed(context, AddTask.routeName);
                  _toggle();
                },
                child: const Icon(Icons.task),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Transform(
              transform: Matrix4.translationValues(
                  0.0, _translateButton.value * 2, 0.0),
              child: FloatingActionButton(
                heroTag: 'note-btn',
                onPressed: () {
                  Navigator.pushNamed(context, AddNote.routeName);
                  _toggle();
                },
                child: const Icon(Icons.notes),
              ),
            ),
            FloatingActionButton(
              onPressed: _toggle,
              elevation: 5,
              child: AnimatedIcon(
                icon: AnimatedIcons.add_event,
                progress: _buttonAnimation,
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      resizeToAvoidBottomInset: false,
    );
  }

  void getThemeData() {
    Provider.of<UserProvider>(context).fetchTheme();
  }
}
