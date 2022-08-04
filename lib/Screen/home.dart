import 'dart:io';

import 'package:chat_aaappp/Screen/Other/contacts.dart';
import 'package:chat_aaappp/Screen/chathome.dart';
import 'package:chat_aaappp/Screen/Status/status.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../main.dart';

File? image;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController _controller;
  var checkVisibility = true;
  int _selectedIndex = 1;
  double editBottom = 0;
  final ImagePicker _picker = ImagePicker();
  List statusList = [];
  dynamic url;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 4, vsync: this, initialIndex: 1);
    _controller.addListener(() {
      setState(() {
        _selectedIndex = _controller.index;
      });
      print("Selected: " + _controller.index.toString());
    });
  }

  Widget build(BuildContext context) {
    if (_selectedIndex == 0) {
      setState(() {
        checkVisibility = false;
      });
    }
    if (_selectedIndex != 0) {
      setState(() {
        checkVisibility = true;
      });
    }
    if (_selectedIndex == 2) {
      setState(() {
        editBottom = 70;
      });
    }
    if (_selectedIndex == 1 || _selectedIndex == 3) {
      setState(() {
        editBottom = 0;
      });
    }

    var scrHeight = MediaQuery.of(context).size.height;
    var scrWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green,
            title: Text(
              'Home',
              // style: TextStyle(
              //   fontWeight: FontWeight.bold,
              //   fontSize: 30,
              //
              // ),
            ),
            bottom: TabBar(
              isScrollable: true,
              controller: _controller,
              indicatorColor: Colors.white70,
              unselectedLabelColor: Colors.white54,
              tabs: [
                Tab(
                  child: Container(
                      width: scrWidth * 0.06, child: Icon(Icons.camera_alt)),
                ),
                Tab(
                  child: Container(
                    width: scrWidth * 0.195,
                    child: Center(child: Text('CHAT')),
                  ),
                ),
                Tab(
                  child: Container(
                    width: scrWidth * 0.195,
                    child: Center(child: Text('STATUS')),
                  ),
                ),
                Tab(
                  child: Container(
                    width: scrWidth * 0.195,
                    child: Center(child: Text('CALLS')),
                  ),
                )
              ],
            ),
            actions: [
              // IconButton(
              //     onPressed: () async {
              //       // await FirebaseAuth.instance.signOut();
              //       showDialog(
              //           context: context,
              //           builder: (BuildContext) => AlertDialog(
              //                 title: Text(
              //                   'LogOut',
              //                   style: TextStyle(fontSize: 15),
              //                 ),
              //                 content: Text('Are you Sure?',
              //                     style: Theme.of(context)
              //                         .textTheme
              //                         .headline5
              //                         ?.copyWith(color: Colors.black)),
              //                 actions: [
              //                   TextButton(
              //                       onPressed: () async {
              //                         await FirebaseAuth.instance.signOut();
              //                       },
              //                       child: Text('Logout'))
              //                 ],
              //               ));
              //     },
              //     icon: Icon(Icons.logout)),
              IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded)),
              PopupMenuButton<int>(
                  // Callback that sets the selected popup menu item.
                  itemBuilder: (context) => [
                        PopupMenuItem(
                          child: Text('New group'),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text('New broadcast'),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text('Linked devices'),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text('Starred messages'),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Text('Settings'),
                          onTap: () {},
                        ),
                        PopupMenuItem(
                          child: Row(
                            children: [
                              Text('Logout'),
                              Icon(
                                Icons.logout_sharp,
                                color: Colors.grey,
                              )
                            ],
                          ),
                          onTap: () async {
                            await GoogleSignIn().signOut();
                            FirebaseAuth.instance.signOut();
                          },
                        ),
                      ]),
            ],
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white70,
          body: TabBarView(
            controller: _controller,
            children: [
              Text('camera'),
              // Camera(),
              ChatHome(),
              Status(),
              Text('calls'),
            ],
          ),
          floatingActionButton: Visibility(
              visible: checkVisibility,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  image == null
                      ? Positioned(
                          bottom: editBottom,
                          left: 5,
                          width: 45,
                          child: FloatingActionButton(
                            onPressed: () {},
                            heroTag: 'btn1',
                            child: Icon(Icons.edit),
                            backgroundColor: Colors.green,
                          ))
                      : SizedBox(),
                  Positioned(
                      child: FloatingActionButton(
                    onPressed: () {
                      if (_selectedIndex == 1) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Contacts()));
                      } else if (_selectedIndex == 2) {
                        if (image == null) {
                          imgChooser();
                        } else {
                          uploadToStorage();
                        }
                      }
                    },
                    heroTag: 'btn2',
                    child: iconCondition(),
                    backgroundColor: Colors.green,
                  ))
                ],
              )),
        ),
      ),
    );
  }

  iconCondition() {
    if (_selectedIndex == 1) {
      return Icon(Icons.message);
    } else if (_selectedIndex == 2) {
      return image == null ? Icon(Icons.camera_alt_rounded) : Icon(Icons.done);
    } else if (_selectedIndex == 3) {
      return Icon(Icons.add_call);
    }
  }

  imgPicker(ImageSource filePath) async {
    XFile? file = await _picker.pickImage(source: filePath);
    if (file != null) {
      image = File(file.path);
      setState(() {});
    }
  }

  uploadToStorage() {
    String fileName = DateTime.now().toString();

    var ref = FirebaseStorage.instance.ref().child('status/$fileName');
    UploadTask uploadTask = ref.putFile(File(image!.path));
    setState(() {
      image = null;
    });

    uploadTask.then((res) async {
      url = (await ref.getDownloadURL()).toString();
      statusList.add({
        'type': "image",
        'url': url,
        'sendTime': DateTime.now(),
      });
    }).then((value) =>
        FirebaseFirestore.instance.collection('status').doc(userId).set({
          'SenderName': userData.displayName,
          'senderId': userId,
          'viewed': [],
          'status': FieldValue.arrayUnion(statusList)
        }));
    // setState(() {
    //   image = null;
    // });
  }

  imgChooser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alert'),
        content: const Text('Choose a option'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);

                setState(() {
                  imgPicker(ImageSource.camera);
                });
              },
              child: const Text('Camera')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  imgPicker(ImageSource.gallery);
                });
              },
              child: const Text('Gallery'))
        ],
      ),
    );
  }
}
