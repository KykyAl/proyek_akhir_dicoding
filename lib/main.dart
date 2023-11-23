import 'package:catatan/helper/notification_service.dart';
import 'package:catatan/helper/scroll_behavior.dart';
import 'package:catatan/provider/auth.dart';
import 'package:catatan/provider/noter_provider.dart';
import 'package:catatan/provider/tasks_provider.dart';
import 'package:catatan/provider/user_provider.dart';
import 'package:catatan/screens/note/add_note_screen.dart';
import 'package:catatan/screens/note/user_note_screen.dart';
import 'package:catatan/screens/splash_screen.dart';
import 'package:catatan/screens/tabs_screen.dart';
import 'package:catatan/screens/tasks/add_task.dart';
import 'package:catatan/screens/tasks/user_task_screen.dart';
import 'package:catatan/screens/user_add_screen.dart';
import 'package:catatan/screens/user_detail_screen.dart';
import 'package:catatan/widget/app_theme.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting("id_ID", null);

  final NotificationService notificationService = NotificationService();
  final deviceInfo = await DeviceInfoPlugin().deviceInfo;
  final androidSdkVersion =
      deviceInfo is AndroidDeviceInfo ? deviceInfo.version.sdkInt : 1;
  notificationService.initializeNotifications;
  notificationService.sendNotification('Selemat Datang', 'di catet yah!!');
  runApp(Catatan(androidSdkVersion: androidSdkVersion));
}

class Catatan extends StatefulWidget {
  const Catatan({Key? key, required this.androidSdkVersion}) : super(key: key);
  final int androidSdkVersion;

  @override
  State<Catatan> createState() => _CatatanState();
}

class _CatatanState extends State<Catatan> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: TaskProvider()),
        ChangeNotifierProvider.value(value: Auth()),
        ChangeNotifierProvider.value(
          value: UserProvider(),
        ),
        ChangeNotifierProvider.value(
          value: NotesProvider(),
        )
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            scrollBehavior: CustomScrollBehavior(
                androidSdkVersion: widget.androidSdkVersion),
            theme: Provider.of<UserProvider>(context).isDark
                ? DarkTheme.darkThemeData
                : LightTheme.lightThemeData,
            home: auth.isAuth
                ? const SplashScreen()
                : FutureBuilder(
                    builder: (context, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? Container(
                                color: Colors.white,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SplashScreen(),
                    future: null,
                  ),
            routes: {
              UserAddScreen.routeName: (context) => const UserAddScreen(),
              UserNoteScreen.routeName: (context) => const UserNoteScreen(),
              UserTaskScreen.routeName: (context) => const UserTaskScreen(),
              AddTask.routeName: (context) => const AddTask(),
              Tabs.routeName: (context) => const Tabs(),
              AddNote.routeName: (context) => const AddNote(),
              UserDetailScreen.routeName: (context) => const UserDetailScreen(),
            },
          );
        },
      ),
    );
  }
}
