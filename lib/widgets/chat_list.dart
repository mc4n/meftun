import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'chatitem.dart' show ChatItem;
import '../models/chat.dart' show Chat;
import '../main.dart';
import '../helpers/table_helper.dart';

class ChatList extends StatefulWidget {
  final bool Function(Chat) filter;
  final void Function(String) onMsgSent;

  ChatList(this.filter, this.onMsgSent, [Key key]);

  @override
  State<StatefulWidget> createState() => ChatListState();

  bool isLoaded = false;
}

class ChatListState extends State<ChatList> {
  final List<Chat> chats = [];

  Future<void> lsInit() async {
    if (!widget.isLoaded) {
      final ls = await myContext.tableEntityOf<ChatTable>().select();
      widget.isLoaded = true;
      setState(() {
        chats.clear();
        chats.addAll(ls.map((i) => i.toChat()).where(widget.filter).toList());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    lsInit();
    return _expan();
  }

  Expanded _expan() {
    return Expanded(
      child: Container(
          child: ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: chats.length,
        itemBuilder: (BuildContext context, int index) =>
            ChatItem(chats[index], widget.onMsgSent),
      )),
    );
  }
}
