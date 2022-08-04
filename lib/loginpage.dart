import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

String uId = '';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text('Hello'),
                Form(
                    child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      width: 200,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Email',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 200,
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Password',
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(onPressed: () {}, child: Text('Login')),
                  ],
                )),
                InkWell(
                  onTap: () async {
                    signWithGoogle();
                  },
                  child: CircleAvatar(
                    backgroundImage: CachedNetworkImageProvider(
                        'https://image3.mouthshut.com/images/imagesp/925000521s.png'),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Future<void> signWithGoogle() async {
    GoogleSignInAccount? googleSignIn = await GoogleSignIn().signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignIn!.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    uId = userCredential.user!.uid;
    var userid = userCredential.user?.uid;
    var username = userCredential.user?.displayName;
    var userimage = userCredential.user?.photoURL;
    var useremail = userCredential.user?.email;
    FirebaseFirestore.instance.collection('user').doc(userid).set({
      'userid': userid,
      'username': username,
      'useremail': useremail,
      'userimage': userimage,
    });
  }
}
