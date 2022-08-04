import 'package:chat_aaappp/Screen/chathome.dart';
import 'package:flutter/material.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  State<Contacts> createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select contact'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search),
          ),
          PopupMenuButton(
              itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text('Invite a friend'),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text('Contacts'),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text('Refresh'),
                      onTap: () {},
                    ),
                    PopupMenuItem(
                      child: Text('Help'),
                      onTap: () {},
                    )
                  ])
        ],
        backgroundColor: Colors.green,
      ),
      body: ChatHome(),
    );
  }
}
