import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:catatan/helper/notification_service.dart';
import 'package:catatan/provider/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddTask extends StatefulWidget {
  static const routeName = '/add-task';
  const AddTask({super.key});

  @override
  State<AddTask> createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  DateTime? startDate;
  final titleText = TextEditingController();
  final descText = TextEditingController();
  String dropDownValue = 'Rencana';
  bool isSterchedDropDown = false;
  final DateTime _date = DateTime.now();
  var listItems = ['Office', 'Home', 'Rencana'];
  NotificationService notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    notificationService.initializeNotifications();
  }

  @override
  void dispose() {
    super.dispose();
    titleText.dispose();
    descText.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imagesMap =
        Provider.of<TaskProvider>(context, listen: false).taskGroup;
    final mediaQuery = MediaQuery.of(context);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Tambah Tugas'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          customTextField('Judul', titleText),
          customHeight(context),
          customTextField('Deskripsi', descText),
          customHeight(context),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Material(
              borderRadius: BorderRadius.circular(30),
              elevation: 0,
              child: InkWell(
                onTap: () {
                  _selectStarDate();
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: startDate == null
                        ? Colors.grey[300]
                        : Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: startDate == null
                        ? Text(
                            'Pilih Tanggal',
                            style: TextStyle(
                                fontSize: mediaQuery.textScaleFactor * 17,
                                color: startDate == null
                                    ? Colors.black45
                                    : Colors.white),
                          )
                        : Text(
                            DateFormat.MMMMd('id_ID').format(startDate!),
                            style: TextStyle(
                                fontSize: mediaQuery.textScaleFactor * 17,
                                color: Colors.white),
                          ),
                  ),
                ),
              ),
            ),
          ),
          customHeight(context),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSterchedDropDown = !isSterchedDropDown;
                  });
                },
                child: Container(
                  height: isLandscape
                      ? mediaQuery.size.width * 0.12
                      : mediaQuery.size.height * 0.12,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 14, 14, 14),
                      borderRadius: isSterchedDropDown
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))
                          : const BorderRadius.all(Radius.circular(25))),
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      top: 20, bottom: 0, left: 10, right: 10),
                  child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(imagesMap[
                                              dropDownValue.toLowerCase()]!),
                                          fit: BoxFit.contain)),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                dropDownValue,
                                style: TextStyle(
                                    fontSize: mediaQuery.textScaleFactor * 23,
                                    color: const Color.fromARGB(
                                        255, 243, 237, 237)),
                              )
                            ],
                          ),
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSterchedDropDown = !isSterchedDropDown;
                                });
                              },
                              child: isSterchedDropDown
                                  ? const Icon(
                                      Icons.arrow_upward,
                                      color: Colors.black,
                                    )
                                  : const Icon(
                                      Icons.arrow_downward,
                                      color: Colors.black,
                                    ))
                        ],
                      )),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(microseconds: 100),
                height: isSterchedDropDown
                    ? listItems.length * mediaQuery.size.height * 0.11
                    : 0,
                decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 233, 227, 227),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                width: double.infinity,
                margin: const EdgeInsets.only(
                    top: 0, bottom: 50, left: 10, right: 10),
                child: ListView.builder(
                  itemCount: listItems.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              dropDownValue = listItems[index];
                              isSterchedDropDown = false;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(imagesMap[
                                                listItems[index]
                                                    .toLowerCase()]!),
                                            fit: BoxFit.contain)),
                                  ),
                                ),
                                SizedBox(
                                  width: mediaQuery.size.width * 0.05,
                                ),
                                Text(
                                  listItems[index],
                                  style: TextStyle(
                                      fontSize: mediaQuery.textScaleFactor * 23,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              )
            ],
          ),
        ]),
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(
            bottom: 70,
          ),
          child: FloatingActionButton(
            onPressed: () {
              _submitData(context);
              if (titleText.text.trim().isNotEmpty && startDate != null) {
                final String id =
                    _date.toString().substring(20, _date.toString().length);
                notificationService.scheduleNotification(
                    titleText.text.trim(), 'Tugas Pending', int.parse(id));
              }
            },
            child: const Icon(Icons.done_all_rounded),
          )),
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }

  Widget customTextField(
      String hintText, TextEditingController textEditingController) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: Colors.black45),
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide.none),
            filled: true,
            fillColor: Colors.grey[300]),
        controller: textEditingController,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }

  Widget customHeight(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.01,
    );
  }

  Widget dateButtonDecoration(ElevatedButton button, BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SizedBox(
        width: double.infinity,
        height: isLandscape ? size.width * 0.06 : size.height * 0.075,
        child: button);
  }

  void _selectStarDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2023),
            lastDate: DateTime(2030))
        .then((value) {
      if (value == null) {
        return;
      }
      setState(() {
        startDate = value;
      });
    });
  }

  void _submitData(BuildContext context) {
    final taskTitle = titleText.text.trim();
    final taskDesc = descText.text.trim();

    if (taskTitle.isEmpty) {
      AwesomeDialog(
          dismissOnBackKeyPress: false,
          dismissOnTouchOutside: false,
          context: context,
          dialogType: DialogType.info,
          title: 'Tambahakan Judul Tugas!',
          btnCancelOnPress: () {
            Navigator.of(context).pop();
          }).show();
      return;
    }
    Provider.of<TaskProvider>(context, listen: false).addTask(
        taskTitle, taskDesc, startDate, dropDownValue.toLowerCase(), _date);
    isSterchedDropDown = false;
    Navigator.of(context).pop();
  }
}
