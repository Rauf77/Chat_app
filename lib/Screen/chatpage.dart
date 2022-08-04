import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voice_message_package/voice_message_package.dart';

import '../main.dart';
import 'audio.dart';
import 'camera.dart';

class ChatPage extends StatefulWidget {
  final String image;
  final String name;
  final String rid;
  final String uid;

  const ChatPage({
    Key? key,
    required this.image,
    required this.name,
    required this.rid,
    required this.uid,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  TextEditingController messageController = TextEditingController();
  bool emojiShowing = false;
  bool keyboardShowing = false;

  _onEmojiSelected(Emoji emoji) {
    messageController
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  //
  _onBackspacePressed() {
    messageController
      ..text = messageController.text.characters.skipLast(1).toString()
      ..selection = TextSelection.fromPosition(
          TextPosition(offset: messageController.text.length));
  }

  @override
  Widget build(BuildContext context) {
    var scrHeight = MediaQuery.of(context).size.height;
    var scrWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        // resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 0,
          leadingWidth: 100,
          leading: Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_outlined)),
              CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
              // SizedBox(
              //   width: 30,
              // ),
            ],
          ),
          title: Text(widget.name),
          actions: [
            Icon(Icons.video_call),
            SizedBox(
              width: 10,
            ),
            Icon(Icons.call),
            SizedBox(
              width: 10,
            ),
            PopupMenuButton<int>(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('View contact'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('Media,link,and docs'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('Search'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('View contact'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('Disappearing messages'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('Wallpaper'),
                        onTap: () {},
                      ),
                      PopupMenuItem(
                        child: Text('More'),
                        onTap: () {},
                      )
                    ])
          ],
          backgroundColor: Colors.green,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                  'https://res.cloudinary.com/practicaldev/image/fetch/s--WAKqnINn--/c_limit%2Cf_auto%2Cfl_progressive%2Cq_auto%2Cw_880/https://thepracticaldev.s3.amazonaws.com/i/tw0nawnvo0zpgm5nx4fp.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: SizedBox(
                  height: scrHeight,
                  width: scrWidth,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("chat")
                          .orderBy('sendTime', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Text("No messages");
                        } else if (snapshot.hasData &&
                            snapshot.data!.docs.isEmpty) {
                          return Text("No messages");
                        } else {
                          var data = snapshot.data!.docs;
                          print(widget.rid);

                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Expanded(
                                  child: ListView.builder(
                                    addAutomaticKeepAlives: true,
                                    cacheExtent: double.infinity,
                                    reverse: true,
                                    itemCount: data.length,
                                    padding: const EdgeInsets.only(
                                        top: 10, bottom: 10),
                                    itemBuilder: (context, index) {
                                      if ((data[index]["senderId"] ==
                                                  widget.uid ||
                                              data[index]["receiverId"] ==
                                                  widget.uid) &&
                                          (data[index]["senderId"] ==
                                                  widget.rid ||
                                              data[index]["receiverId"] ==
                                                  widget.rid)) {
                                        if (data[index]['receiverId'] ==
                                            userId) {
                                          FirebaseFirestore.instance
                                              .collection('chat')
                                              .doc(data[index]['msgId'])
                                              .update({'isRead': true});
                                        }
                                        Timestamp t = data[index]["sendTime"];
                                        DateTime d = t.toDate();

                                        return Align(
                                          alignment: (data[index]["senderId"] ==
                                                  widget.rid
                                              ? Alignment.topLeft
                                              : Alignment.topRight),
                                          child: ConstrainedBox(
                                            constraints: BoxConstraints(
                                                maxWidth: scrWidth - 45,
                                                minWidth: 130),
                                            child: Card(
                                              elevation: 1,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8)),
                                              color: (data[index]["senderId"] ==
                                                      widget.rid
                                                  ? Color(0x61000000)
                                                  : Color(0xff2e7d32)),
                                              margin: EdgeInsets.symmetric(
                                                  horizontal: 15, vertical: 5),
                                              child: Stack(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 10,
                                                      right: 30,
                                                      top: 5,
                                                      bottom: 20,
                                                    ),
                                                    child: Text(
                                                      data[index]["message"],
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: 4,
                                                    right: 10,
                                                    child: Row(children: [
                                                      Text(
                                                          style: TextStyle(
                                                            fontSize: 13,
                                                            // 0xff6cb0a6
                                                            color: (data[index][
                                                                        "senderId"] ==
                                                                    widget.rid
                                                                ? const Color(
                                                                    0xff6f7a83)
                                                                : const Color(
                                                                    0xff6cb0a6)),
                                                          ),
                                                          DateFormat("h:mm a")
                                                              .format(d)
                                                              .toLowerCase()),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      data[index]['senderId'] ==
                                                              userId
                                                          ? Icon(
                                                              Icons.done_all,
                                                              size: 20,
                                                              color: data[index]
                                                                      ['isRead']
                                                                  ? Colors.blue
                                                                  : Colors.grey[
                                                                      600],
                                                            )
                                                          : const SizedBox(),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const SizedBox();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  emojiShowing = !emojiShowing;
                                  keyboardShowing = false;
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              },
                              icon: Icon(
                                Icons.emoji_emotions_outlined,
                                color: Colors.black26,
                              )),
                          Expanded(
                            child: TextFormField(
                              onChanged: (text) {
                                setState(() {});
                              },
                              onTap: () {
                                emojiShowing = false;
                                keyboardShowing = true;
                                setState(() {
                                  Timer(Duration(milliseconds: 700), () {
                                    keyboardShowing = false;
                                  });
                                });
                              },
                              controller: messageController,
                              decoration: InputDecoration(
                                  hintText: 'Message',
                                  border: InputBorder.none),
                            ),
                          ),
                          IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    context: context,
                                    builder: (context) => bottomSheet());
                              },
                              icon: Icon(
                                Icons.attach_file_outlined,
                                color: Colors.black26,
                              )),
                          IconButton(
                              onPressed: () {
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => Camera()));
                              },
                              icon: Icon(
                                Icons.camera_alt_rounded,
                                color: Colors.black26,
                              )),
                        ],
                      ),
                      width: 280,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white),
                    ),
                    Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.green),
                        child: IconButton(
                          onPressed: () {
                            if (messageController.text.isNotEmpty) {
                              sendMessage();
                            } else {
                              VoiceMessage(
                                me: true,
                                audioSrc: '',
                                played: false,
                                onPlay: () {},
                              );
                            }
                            messageController.clear();
                          },
                          icon: icons(),
                        ))
                  ],
                ),
              ),
              // Offstage(
              //   offstage: !keyboardShowing,
              //   child: SizedBox(
              //     height: 275,
              //   ),
              // ),
              Offstage(
                  offstage: !emojiShowing,
                  child: SizedBox(
                    height: 250,
                    child: EmojiPicker(
                      onEmojiSelected: (Category category, Emoji emoji) {
                        _onEmojiSelected(emoji);
                      },
                      onBackspacePressed: _onBackspacePressed,
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        progressIndicatorColor: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: true,
                        showRecentsTab: true,
                        recentsLimit: 28,
                        replaceEmojiOnLimitExceed: false,
                        noRecents: Text('No Recents',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black26,
                            ),
                            textAlign: TextAlign.center),
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        categoryIcons: CategoryIcons(),
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(
                          Icons.file_copy_sharp,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.deepPurpleAccent),
                      ),
                      Text(
                        'Document',
                      )
                    ],
                  ),
                  InkWell(
                    onTap: () {
                      // Navigator.push(
                      //     context,
                      //     CupertinoModalPopupRoute(
                      //         builder: (context) => Camera()));
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(70),
                              color: Colors.redAccent),
                        ),
                        Text(
                          'Camera',
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(
                          Icons.image,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.purple),
                      ),
                      Text(
                        'Gallery',
                      )
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(
                          Icons.headphones,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.deepOrangeAccent),
                      ),
                      Text(
                        'Music',
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                        ),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.green[400]),
                      ),
                      Text(
                        'Location',
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        child: Icon(Icons.person),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.blue[300]),
                      ),
                      Text(
                        'Document',
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  sendMessage() {
    FirebaseFirestore.instance.collection('chat').add({
      'message': messageController.text,
      'receiverId': widget.rid,
      'senderId': widget.uid,
      'sendTime': DateTime.now(),
      'isRead': false,
    }).then((value) {
      value.update({
        'msgId': value.id,
      });
    });
  }

  icons() {
    if (messageController.text.isNotEmpty) {
      return Icon(
        Icons.send,
        color: Colors.white,
      );
    } else {
      return Icon(
        Icons.mic,
        color: Colors.white,
      );
    }
  }

// void openFile(PlatformFile? file) {
//   OpenFile.open(file?.path);
// }
// sendMessage() {
//   FirebaseFirestore.instance.collection('chat').add({
//     "message": messageController.text,
//     "receiverId": widget.rid,
//     "senderId": widget.uid,
//     "sendTime": DateTime.now(),
//     "isRead": false,
//   }).then((value) {
//     value.update({
//       "msgId": value.id,
//     });
//   });
// }
}
