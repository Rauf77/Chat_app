import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'chatpage.dart';

Future<void> _refresh() async {}

class ChatHome extends StatefulWidget {
  const ChatHome({Key? key}) : super(key: key);

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height;
    var scrWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('user')
              .where('userid', isNotEqualTo: userId)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CircularProgressIndicator();
            }
            return Container(
              height: scrHeight,
              width: scrWidth,
              child: RefreshIndicator(
                onRefresh: _refresh,
                color: Colors.green,
                triggerMode: RefreshIndicatorTriggerMode.onEdge,
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPage(
                                        image: snapshot.data!.docs[index]
                                            ['userimage'],
                                        name: snapshot.data!.docs[index]
                                            ['username'],
                                        rid: snapshot.data!.docs[index]
                                            ['userid'],
                                        uid: userId,
                                      )));
                        },
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                snapshot.data!.docs[index]['userimage']),
                          ),
                          title: Text(snapshot.data!.docs[index]['username']),
                        ),
                      );
                    }),
              ),
            );
          }),
    );
  }
}
