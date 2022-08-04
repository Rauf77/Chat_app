import 'dart:ffi';

import 'package:camera/camera.dart';
import 'package:chat_aaappp/Screen/camera.dart';
import 'package:chat_aaappp/Screen/home.dart';
import 'package:chat_aaappp/loginpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

var userId;
var userData;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // cameras = await availableCameras();
  runApp(MaterialApp(
    home: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data == null) {
            return LoginPage();
          } else {
            userData = snapshot.data;
            userId = userData.uid;
            print("uid : $userId");
            return Home();
          }
        }
        return CircularProgressIndicator();
      },
    ),
    debugShowCheckedModeBanner: false,
  ));
}
