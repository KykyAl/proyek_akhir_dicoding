import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:catatan/provider/auth.dart';
import 'package:catatan/provider/user_provider.dart';
import 'package:catatan/screens/tabs_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class UserAddScreen extends StatefulWidget {
  static const routeName = '/user-add';
  const UserAddScreen({super.key});

  @override
  State<UserAddScreen> createState() => _UserAddScreenState();
}

class _UserAddScreenState extends State<UserAddScreen> {
  final _fromKey = GlobalKey<FormState>();
  final name = TextEditingController();
  final about = TextEditingController();

  String? selectedImagePath;

  @override
  void dispose() {
    name.dispose();
    about.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandScaoe =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Detail Form anda'),
        ),
        body: Form(
            key: _fromKey,
            child: isLandScaoe
                ? landScapeview(mediaQuery, context)
                : potraitView(mediaQuery, context)));
  }

  Widget potraitView(MediaQueryData mediaQuery, BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: mediaQuery.size.height * 0.05),
            SizedBox(
                height: mediaQuery.size.height * 0.25,
                child: SizedBox(
                  width: mediaQuery.size.height * 0.25,
                  child: Swiper(
                    scrollDirection: Axis.horizontal,
                    pagination: const SwiperPagination(),
                    loop: false,
                    itemCount: 1,
                    itemBuilder: (context, index) {
                      return CircleAvatar(
                        backgroundColor:
                            Theme.of(context).colorScheme.secondary,
                        backgroundImage: selectedImagePath != null
                            ? FileImage(
                                File(
                                  selectedImagePath!,
                                ),
                              )
                            : null,
                      );
                    },
                    onTap: (index) {
                      _pickImage();
                    },
                  ),
                )),
            SizedBox(
              height: mediaQuery.size.height * 0.03,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 23, 244, 115),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              onPressed: () {
                _pickImage();
              },
              icon: Icon(
                Icons.image,
                size: mediaQuery.textScaleFactor * 30,
              ),
              label: Text(
                'Pilih Gambar anda ',
                style: TextStyle(
                  fontSize: mediaQuery.textScaleFactor * 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: mediaQuery.size.width * 0.1,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLength: 15,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Kasih nama dulu dong';
                  }
                  return null;
                },
                controller: name,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: TextFormField(
                maxLength: 30,
                maxLines: 1,
                decoration: const InputDecoration(
                  labelText: 'Tentang',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                textCapitalization: TextCapitalization.sentences,
                validator: (value) {
                  if (value == null) {
                    return null;
                  }
                  return null;
                },
                controller: about,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(15),
              height: mediaQuery.size.width * 0.15,
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                ),
                onPressed: () {
                  _submit(context);
                },
                icon: Icon(
                  Icons.arrow_forward_sharp,
                  size: mediaQuery.textScaleFactor * 30,
                ),
                label: Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: mediaQuery.textScaleFactor * 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _pickImage() async {
    final ImagePicker imagePicker = ImagePicker();
    final XFile? pickedImage =
        await imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        selectedImagePath = pickedImage.path;
        Provider.of<UserProvider>(context, listen: false)
            .updateUserImage(selectedImagePath!);
      });
    }
  }

  Widget landScapeview(MediaQueryData mediaQuery, BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            width: mediaQuery.size.width * 0.05,
          ),
          Flexible(
            child: SizedBox(
              height: mediaQuery.size.height * 0.25,
              width: mediaQuery.size.width * 0.3,
              child: Swiper(
                scrollDirection: Axis.horizontal,
                pagination: const SwiperPagination(),
                loop: true,
                itemCount: 1,
                itemBuilder: (context, index) {
                  double avatarSize = mediaQuery.size.height * 0.25;
                  return CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    maxRadius: avatarSize / 5,
                    backgroundImage: selectedImagePath != null
                        ? FileImage(File(selectedImagePath!))
                        : null,
                    child: selectedImagePath != null
                        ? Icon(
                            Icons.done,
                            size: avatarSize * 0.2,
                          )
                        : null,
                  );
                },
                onTap: (index) {
                  _pickImage();
                },
              ),
            ),
          ),
          SizedBox(
            width: mediaQuery.size.width * 0.1,
          ),
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: mediaQuery.size.height * 0.08,
                ),
                Container(
                  width: mediaQuery.size.width * 0.5,
                  margin: const EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 15,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Nama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter name to continue';
                      }
                      return null;
                    },
                    controller: name,
                  ),
                ),
                Container(
                  width: mediaQuery.size.width * 0.5,
                  margin: const EdgeInsets.all(5),
                  child: TextFormField(
                    maxLength: 30,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      labelText: 'Tentang',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null) {
                        return null;
                      }
                      return null;
                    },
                    controller: about,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5),
                  height: mediaQuery.size.width * 0.075,
                  width: mediaQuery.size.width * 0.5,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                    onPressed: () {
                      _submit(context);
                    },
                    label: Text(
                      'Task It',
                      style: TextStyle(
                        fontSize: mediaQuery.textScaleFactor * 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.arrow_forward_sharp,
                      size: mediaQuery.textScaleFactor * 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submit(BuildContext context) async {
    if (!_fromKey.currentState!.validate()) {
      return;
    }

    if (selectedImagePath == null) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.error,
        title: 'Kasih fotonya dulu dong!',
        btnOkOnPress: () {},
        btnOkText: 'OK',
        btnOkColor: Theme.of(context).colorScheme.primary,
      ).show();
    } else {
      Provider.of<UserProvider>(context, listen: false).login(
        DateTime.now().toString(),
        selectedImagePath!,
        name.text.trim(),
        about.text.trim(),
      );
      Provider.of<Auth>(context, listen: false).authenticate('Logged in!');
      Navigator.of(context).pushReplacementNamed(Tabs.routeName);
    }
  }
}
