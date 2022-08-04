import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_aaappp/Screen/Status/story.dart';
import 'package:chat_aaappp/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:status_view/status_view.dart';

import '../home.dart';

List statusList = [];

class Status extends StatefulWidget {
  const Status({Key? key}) : super(key: key);

  @override
  State<Status> createState() => _StatusState();
}

class _StatusState extends State<Status> {
  getList() {
    FirebaseFirestore.instance
        .collection('status')
        .doc(userId)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        statusList = event.get('status');
      }
    });
  }

  @override
  void initState() {
    statusList = [];
    getList();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () {
            if (statusList.isNotEmpty) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Story(
                            id: userId,
                          )));
            }
            // else {}
          },
          child: Container(
            padding: EdgeInsets.all(10),
            height: 75,
            width: double.infinity,
            child: Row(
              children: [
                Badge(
                  showBadge: statusList.isEmpty ? true : false,
                  toAnimate: false,
                  position: BadgePosition(bottom: 1, start: 37),
                  badgeColor: Color(0xff168670),
                  badgeContent: Icon(
                    Icons.add,
                    size: 10,
                    color: Colors.white,
                  ),
                  child: statusList.isEmpty
                      ? CircleAvatar(
                          radius: 30,
                          backgroundImage:
                              CachedNetworkImageProvider(userData.photoURL),
                        )
                      : StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('status')
                              .where('senderId', isEqualTo: userId)
                              .snapshots(),
                          builder: (context, snapshot) {
                            var data;
                            var statlen;
                            if (!snapshot.hasData) {
                              return Text('No Message');
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return Text('No Message');
                            } else if (snapshot.hasData &&
                                snapshot.data!.docs.isEmpty) {
                              return Badge(
                                toAnimate: false,
                                position: BadgePosition(bottom: 1, start: 30),
                                badgeColor: Color(0xff168670),
                                badgeContent: Icon(
                                  Icons.add,
                                  size: 13,
                                  color: Colors.white,
                                ),
                                child: CircleAvatar(
                                  radius: 25,
                                  backgroundImage: CachedNetworkImageProvider(
                                      userData.photoURL),
                                ),
                              );
                            } else {
                              data = snapshot.data!.docs;
                              statlen = data[0]['status'].length;
                              return StatusView(
                                centerImageUrl: data[0]['status'][statlen - 1]
                                    ['url'],
                                radius: 30,
                                spacing: 15,
                                strokeWidth: 2,
                                numberOfStatus: data[0]['status'].length,
                                padding: 4,
                                seenColor: Colors.grey,
                                unSeenColor: Colors.green,
                              );
                            }
                          }),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'My Status',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Tab and Add Status',
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
            padding: EdgeInsets.only(left: 10),
            child: Text(
              'Recent updates',
              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.grey),
            )),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('status')
                  .where('senderId', isNotEqualTo: userId)
                  .snapshots(),
              builder: (context, snapshot) {
                var data = snapshot.data?.docs;
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('No Status'));
                } else {
                  return ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: data?.length,
                      itemBuilder: (context, index) {
                        var statlen = data![index]['status'].length;
                        Timestamp t =
                            data[index]['status'][statlen - 1]['sendTime'];
                        DateTime d = t.toDate();
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Story(id: data[index]['senderId'])));
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                StatusView(
                                  centerImageUrl: data[index]['status']
                                      [statlen - 1]['url'],
                                  numberOfStatus: data[index]['status'].length,
                                  padding: 4,
                                  radius: 30,
                                  spacing: 15,
                                  strokeWidth: 2,
                                  seenColor: Colors.grey,
                                  unSeenColor: Colors.green,
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data[index]['SenderName'],
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 15),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      DateFormat('h:mm a')
                                          .format(d)
                                          .toLowerCase(),
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      });
                }
              },
            ),
          ),
        )

        // Padding(
        //   padding: const EdgeInsets.only(
        //     left: 10,
        //   ),
        //   child: StatusView(
        //     centerImageUrl:
        //         'https://i.ytimg.com/vi/SAPfI9qsOF8/maxresdefault.jpg',
        //     radius: 30,
        //     spacing: 15,
        //     strokeWidth: 2,
        //     indexOfSeenStatus: 2,
        //     numberOfStatus: 5,
        //     padding: 4,
        //     seenColor: Colors.grey,
        //     unSeenColor: Colors.green,
        //   ),
        // )
      ],
    ));
  }
}
