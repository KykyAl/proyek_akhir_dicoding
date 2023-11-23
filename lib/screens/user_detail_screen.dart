import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:catatan/helper/notification_service.dart';
import 'package:catatan/provider/auth.dart';
import 'package:catatan/provider/noter_provider.dart';
import 'package:catatan/provider/tasks_provider.dart';
import 'package:catatan/provider/user_provider.dart';
import 'package:catatan/screens/splash_screen.dart';
import 'package:catatan/screens/tabs_screen.dart';
import 'package:catatan/widget/my_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetailScreen extends StatefulWidget {
  static const routeName = '/user-detail';
  const UserDetailScreen({super.key});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  @override
  void initState() {
    Provider.of<UserProvider>(context, listen: false).fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context).colorScheme.secondary;
    final mediaQuery = MediaQuery.of(context);
    final userData = Provider.of<UserProvider>(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
        appBar: AppBar(
          title: const Text('User Details'),
        ),
        drawer: const MyDrawer(),
        extendBodyBehindAppBar: true,
        body: isLandscape
            ? _landscapeView(mediaQuery, themeData, userData, context)
            : _potraitView(mediaQuery, themeData, userData, context));
  }

  Widget _potraitView(MediaQueryData mediaQuery, Color themeData,
      UserProvider userData, BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
        child: SizedBox(
          height: mediaQuery.size.height * 1.0,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    const Padding(padding: EdgeInsets.only(top: 50)),
                    CircleAvatar(
                      backgroundColor: themeData,
                      maxRadius: mediaQuery.size.height * 0.1,
                      minRadius: mediaQuery.size.height * 0.05,
                      backgroundImage: userData.user.image.isEmpty
                          ? null
                          : FileImage(File(userData.user.image)),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.03,
                    ),
                    Text(
                      userData.user.name,
                      style: TextStyle(
                          fontSize: mediaQuery.textScaleFactor * 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: mediaQuery.size.height * 0.02,
                    ),
                    InkWell(
                      onTap: () {
                        changeAbout(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          userData.user.about != ''
                              ? userData.user.about
                              : ' Tap tambahkan deskripsi',
                          style: TextStyle(
                              fontSize: mediaQuery.textScaleFactor * 20,
                              color: Colors.grey[700]),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    customButton('Home', () {
                      Navigator.of(context)
                          .pushReplacementNamed(Tabs.routeName);
                    }, const Icon(Icons.home), themeData),
                    customButton('Mode Terang', () {
                      userData.setTheme(false);
                    }, const Icon(Icons.sunny), themeData),
                    customButton('Mode Gelap', () {
                      userData.setTheme(true);
                    }, const Icon(Icons.nightlight), themeData)
                  ],
                ),
                customButton('Logout', () {
                  confrimDialog(context);
                }, const Icon(Icons.logout), Colors.red[300]!)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _landscapeView(MediaQueryData mediaQuery, Color themeData,
      UserProvider userData, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: mediaQuery.size.width * 0.05,
        ),
        SingleChildScrollView(
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.only(top: 90)),
              FutureBuilder<File>(
                future: Future.value(File(userData.user.image)),
                builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
                  final avatarSize = mediaQuery.size.width * 0.1;
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    return CircleAvatar(
                      backgroundColor: themeData,
                      maxRadius: avatarSize,
                      backgroundImage: FileImage(snapshot.data!),
                    );
                  } else {
                    return CircleAvatar(
                      backgroundColor: themeData,
                      maxRadius: avatarSize,
                    );
                  }
                },
              ),
              Text(
                userData.user.name,
                style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 30,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: mediaQuery.size.height * 0.02,
              ),
            ],
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.1,
        ),
        SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(padding: EdgeInsets.only(top: 90)),
              customButton('Home', () {
                Navigator.of(context).pushReplacementNamed(Tabs.routeName);
              }, const Icon(Icons.home), themeData)
            ],
          ),
        )
      ],
    );
  }

  Widget customButton(String title, Function fx, Icon icon, Color color) {
    final mediaQuery = MediaQuery.of(context);
    final islandScape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      width: islandScape ? mediaQuery.size.width * 0.5 : double.infinity,
      height: islandScape
          ? mediaQuery.size.width * 0.075
          : mediaQuery.size.height * 0.075,
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)))),
        onPressed: () {
          fx();
        },
        icon: icon,
        label: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: TextStyle(
                fontSize: mediaQuery.textScaleFactor * 20,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  void changeAbout(BuildContext context) async {
    final about = TextEditingController();
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    bool check = false;
    showModalBottomSheet(
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return Container(
          padding: EdgeInsets.only(bottom: mediaQuery.viewInsets.bottom),
          child: SizedBox(
            height: isLandscape
                ? mediaQuery.size.width * 0.3
                : mediaQuery.size.height * 0.3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  height: isLandscape
                      ? mediaQuery.size.width * 0.15
                      : mediaQuery.size.height * 0.15,
                  padding: const EdgeInsets.all(5.0),
                  child: TextField(
                    maxLength: 30,
                    maxLines: 1,
                    decoration: const InputDecoration(
                        label: Text('Tambah Deskripsi'),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20)))),
                    textCapitalization: TextCapitalization.sentences,
                    controller: about,
                  ),
                ),
                SizedBox(
                  height: mediaQuery.size.height * 0.02,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    height: isLandscape
                        ? mediaQuery.size.width * 0.075
                        : mediaQuery.size.height * 0.075,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () {
                        if (about.text.isEmpty) {
                          return;
                        }
                        check = true;
                        Provider.of<UserProvider>(context, listen: false)
                            .updateAbout(about.text.trim());
                        Navigator.of(context).pop();
                      },
                      icon: const Icon(Icons.done_all_sharp),
                      color: Colors.white,
                      iconSize: isLandscape
                          ? mediaQuery.size.width * 0.05
                          : mediaQuery.size.height * 0.05,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (check) {
      about.dispose();
    }
  }

  void confrimDialog(BuildContext context) {
    final NotificationService notificationService = NotificationService();
    AwesomeDialog(
            dismissOnBackKeyPress: false,
            dismissOnTouchOutside: false,
            context: context,
            dialogType: DialogType.warning,
            title: 'Keluar akan menghapus semua data kamu!',
            btnOkOnPress: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const SplashScreen(),
              ));
              Navigator.of(context).pop;
              Provider.of<TaskProvider>(context, listen: false).logout();
              Provider.of<UserProvider>(context, listen: false).logout();
              Provider.of<Auth>(context, listen: false).logout();
              Provider.of<NotesProvider>(context, listen: false);
              Provider.of<UserProvider>(context, listen: false)
                  .deleteThemeData();
              notificationService.stopAllNotification();
            },
            btnOkText: 'Siap',
            btnOkColor: Colors.red[300],
            btnCancelText: 'Tidak',
            btnCancelOnPress: () {
              Navigator.of(context);
            },
            btnCancelColor: Theme.of(context).colorScheme.primary,
            buttonsTextStyle: const TextStyle(color: Colors.white))
        .show();
  }
}
