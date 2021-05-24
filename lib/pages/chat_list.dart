import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:me_flutting/pages/create_msg.dart';
import '../models/chat.dart';

class ChatList extends StatelessWidget {
  final List<Chat> chats;

  ChatList({Key key, this.chats}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 16.0),
        ),
        chats.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: chats.length,
                  itemBuilder: (BuildContext context, int index) {
                    var selChat = chats[index];
                    return TextButton(
                        onPressed: () => {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => CreateMessagePage(
                                      messages: selChat.getMessages()),
                                ),
                              )
                            },
                        child: Text(
                            "${chats[index]?.id} : ${chats[index].getLastMessage().body}"));
                  },
                ),
              )
            : Text("No chat."),
      ],
    );
  }
}
