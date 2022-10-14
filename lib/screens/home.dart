import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loginsignup/screens/signup.dart';
import 'package:loginsignup/screens/widgets.dart';
import 'package:loginsignup/utils/console.dart';
import 'package:loginsignup/utils/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker imagePicker = ImagePicker();
  bool pSignOut = false;
  bool pUploadingPhoto = false;
  bool pVerifyEmail = false;
  bool pUpdaDisName = false;
  String? filePicked;
  String? fileDownlo;
  @override
  Widget build(BuildContext context) {
    User? user = authController.firebaseUser.value;
    return WillPopScope(
      onWillPop: () async {
        bool? result = await Get.dialog(Dialog(
          backgroundColor: Get.theme.backgroundColor,
          elevation: 12,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(onPressed: () => Get.back(result: false), child: const Text('Annuler')),
              ElevatedButton(onPressed: () => Get.back(result: true), child: const Text('Ok')),
            ],
          ),
        ));
        return result ?? false;
      },
      child: SafeArea(
        child: Scaffold(
          body: user != null
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ListTile(
                            tileColor: user.isAnonymous ? Get.theme.errorColor : null,
                            leading: ClipOval(
                              child: Material(
                                child: InkWell(
                                  onTap: () async {
                                    await uploadProfilePicture(user);
                                  },
                                  child: (user.photoURL == null)
                                      ? pUploadingPhoto
                                          ? const CustomCircular()
                                          : const Icon(Icons.upload)
                                      : Image.network(user.photoURL!),
                                ),
                              ),
                            ),
                            trailing: (user.displayName == null)
                                ? SizedBox(
                                    width: 20,
                                    height: 75,
                                    child: Material(
                                      child: InkWell(
                                        onTap: () async {
                                          await updateDisplayName(user);
                                        },
                                        child: pUpdaDisName
                                            ? const CustomCircular()
                                            : const Icon(Icons.edit_note_sharp),
                                      ),
                                    ),
                                  )
                                : null,
                            title: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('${user.email}'),
                                if (user.emailVerified)
                                  const Icon(
                                    Icons.verified,
                                    color: Color(0xFF75048E),
                                  )
                                else
                                  InkWell(
                                    onTap: () async {
                                      setState(() {
                                        pVerifyEmail = !pVerifyEmail;
                                      });
                                      try {
                                        await user.sendEmailVerification();
                                      } on Exception catch (firebaseException) {
                                        Console.log(firebaseException);
                                      }
                                      if (!mounted) return;
                                      setState(() {
                                        pVerifyEmail = !pVerifyEmail;
                                      });
                                    },
                                    child: const Icon(
                                      Icons.send,
                                      color: Color(0xFF75048E),
                                    ),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              user.displayName ?? 'change your name',
                              style: TextStyle(
                                color: user.displayName == null ? Get.theme.errorColor : null,
                              ),
                            ),
                          ),
                          UploadedPhotos(filePicked: filePicked, fileDownlo: fileDownlo),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          pSignOut = !pSignOut;
                        });
                        await firebaseAuth.signOut();
                        setState(() {
                          pSignOut = !pSignOut;
                        });
                        Get.off(() => const SignUp());
                      },
                      child: pSignOut ? const CustomCircular() : const Text('Sign Out'),
                    ),
                  ]
                      .map((e) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: e,
                              ),
                            ),
                          ))
                      .toList(),
                )
              : const Text("Not signed in"),
        ),
      ),
    );
  }

  Future<void> updateDisplayName(User user) async {
    var name = await Get.bottomSheet<String>(BottomSheet(
      onClosing: () {},
      enableDrag: false,
      builder: (context) {
        TextEditingController editingController = TextEditingController();
        return Card(
          child: TextField(
            keyboardType: TextInputType.name,
            controller: editingController,
            decoration: InputDecoration(
              hintText: 'Votre nom&prénom',
              suffixIcon: InkWell(
                onTap: () => Get.back(result: editingController.text),
                child: const Icon(
                  Icons.check_circle_outline_rounded,
                ),
              ),
            ),
          ),
        );
      },
    ));
    setState(() {
      pUpdaDisName = !pUpdaDisName;
    });
    if (name != null) {
      user.updateDisplayName(name);
    }
    setState(() {
      pUpdaDisName = !pUpdaDisName;
    });
  }

  Future<void> uploadProfilePicture(User user) async {
    setState(() {
      pUploadingPhoto = !pUploadingPhoto;
    });
    /* var collection = firebaseFirestore.collection('collectionPath');
    var snapshots = collection.snapshots(); */
    var file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      Reference ref = firebaseStorage.ref().child(user.uid).child('profile.jpg');
      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': file.path},
      );

      try {
        UploadTask uploadTask = ref.putFile(File(file.path), metadata);
        var result = await Future.value(uploadTask);
        var downloadURL = await result.ref.getDownloadURL();
        /* var downloadL = result.ref.fullPath;
        var downloadN = result.ref.name; */
        /* var memory = await result.ref.getData();
        Widget child = Image.memory(memory!); */
        /* Console.log(downloadURL);
        Console.log(downloadL);
        Console.log(downloadN); */
        user.updatePhotoURL(downloadURL);
        setState(() {
          fileDownlo = downloadURL;
        });
      } on Exception catch (e) {
        Console.log(e);
      }
      setState(() {
        filePicked = file.path;
      });
    }
    // await user.updatePhotoURL('');
    setState(() {
      pUploadingPhoto = !pUploadingPhoto;
    });
  }
}

class UploadedPhotos extends StatelessWidget {
  const UploadedPhotos({
    Key? key,
    required this.filePicked,
    required this.fileDownlo,
  }) : super(key: key);

  final String? filePicked;
  final String? fileDownlo;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (filePicked != null)
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Image.file(
                  File(filePicked!),
                  fit: BoxFit.fitWidth,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'File',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [Shadow(color: Colors.white, blurRadius: 10)],
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (fileDownlo != null)
          SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              children: [
                Image.network(
                  fileDownlo!,
                  fit: BoxFit.fitWidth,
                ),
                const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Network',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      shadows: [Shadow(color: Colors.white, blurRadius: 10)],
                      color: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
