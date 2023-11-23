import 'package:catatan/helper/notification_service.dart';
import 'package:catatan/models/user_task.dart';
import 'package:catatan/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TaskBuilder extends StatefulWidget {
  final String? filter;
  const TaskBuilder({required this.filter, super.key});

  @override
  State<TaskBuilder> createState() => _TaskBuilderState();
}

class _TaskBuilderState extends State<TaskBuilder> {
  var isInit = false;

  @override
  void initState() {
    isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) _fetchData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TaskProvider>(context);
    final userList = widget.filter! == 'Kosong'
        ? Provider.of<TaskProvider>(context).userTaskList
        : Provider.of<TaskProvider>(context).groupList(widget.filter!);
    final mediaQuery = MediaQuery.of(context);
    return userList.isEmpty
        ? Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Text(
                  'Tidak ada tugas',
                  style: TextStyle(
                      fontSize: mediaQuery.textScaleFactor * 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: mediaQuery.size.width * 0.7,
                  height: mediaQuery.size.width * 0.5,
                  child: Image.asset(
                    'assets/images/notask.png',
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          )
        : isInit
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Color.fromARGB(240, 95, 21, 214)),
                ),
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                primary: false,
                shrinkWrap: true,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  return TaskTile(user: user, userList: userList, index: index);
                },
              );
  }

  void _fetchData() async {
    Future.delayed(const Duration(seconds: 1), () {
      isInit = false;
    });
    await Provider.of<TaskProvider>(context).fetchData();
  }
}

class TaskTile extends StatefulWidget {
  const TaskTile(
      {super.key,
      required this.user,
      required this.userList,
      required this.index});

  final TaskProvider user;
  final List<UserTask> userList;
  final int index;

  @override
  State<TaskTile> createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  final NotificationService notificationService = NotificationService();

  @override
  void initState() {
    notificationService.initializeNotifications();
    notificationService.scheduleNotification('Pengingat', 'Jadwal anda', 1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          final tempIndex = Provider.of<TaskProvider>(context, listen: false)
              .userTaskList
              .indexWhere(
                (element) => element.id == widget.userList[widget.index].id,
              );
          widget.user.deleteTask(tempIndex);
        },
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Kamu yakin mau di hapus?'),
              content: const Text('Ini akan menghapus tugas ini!'),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No')),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Iya'))
              ],
            ),
          );
        },
        background: const Card(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
        child: Card(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25))),
            elevation: 4,
            margin: const EdgeInsets.all(5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                                widget.userList[widget.index].imagePath)))),
              ),
              title: Text(
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                widget.userList[widget.index].title,
                style: TextStyle(
                    decoration: widget.userList[widget.index].isDone
                        ? TextDecoration.lineThrough
                        : null),
              ),
              trailing: Wrap(
                direction: Axis.vertical,
                alignment: WrapAlignment.center,
                children: [
                  Text(widget.userList[widget.index].startingDate == null
                      ? ''
                      : DateFormat.MMMd('id_ID')
                          .format(widget.userList[widget.index].startingDate!)),
                  Consumer<TaskProvider>(
                    builder: (context, user, _) {
                      return Checkbox(
                        value: widget.userList[widget.index].isDone,
                        onChanged: (value) {
                          final String id = widget.userList[widget.index].id
                              .substring(
                                  20, widget.userList[widget.index].id.length);
                          final indexTemp = user.userTaskList
                              .indexOf(widget.userList[widget.index]);
                          final check = user.userTaskList[indexTemp].isDone;
                          user.taskDone(indexTemp, check);
                          if (widget.userList[widget.index].startingDate
                              .toString()
                              .isNotEmpty) {
                            if (value == false) {
                              notificationService.scheduleNotification(
                                  widget.userList[widget.index].title,
                                  'Tugas Pending',
                                  int.parse(id));
                            }
                          }
                        },
                      );
                    },
                  ),
                  IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Are you sure!'),
                            content: const Text(
                                'This will delete the current task!'),
                            actions: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('No')),
                              TextButton(
                                  onPressed: () {
                                    final String id = widget
                                        .userList[widget.index].id
                                        .substring(
                                            20,
                                            widget.userList[widget.index].id
                                                .length);
                                    final tempIndex = Provider.of<TaskProvider>(
                                            context,
                                            listen: false)
                                        .userTaskList
                                        .indexWhere((element) =>
                                            element.id ==
                                            widget.userList[widget.index].id);
                                    Navigator.of(context).pop(true);
                                    widget.user.deleteTask(tempIndex);
                                    if (widget
                                        .userList[widget.index].startingDate
                                        .toString()
                                        .isNotEmpty) {
                                      notificationService
                                          .stopNotication(int.parse(id));
                                    }
                                  },
                                  child: const Text('Yes'))
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ))
                ],
              ),
            )));
  }
}
