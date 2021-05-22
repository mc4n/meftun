import 'package:me_flutting/models/draft.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CreateMessagePage extends StatefulWidget {
  final Draft selectedLastMsg;

  CreateMessagePage({Key key, this.selectedLastMsg}) : super(key: key);

  @override
  CreateMessagePageState createState() =>
      new CreateMessagePageState(this.selectedLastMsg);
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final Draft selectedLastMsg;
  CreateMessagePageState(this.selectedLastMsg);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey,
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            Text('grop-id -> ${selectedLastMsg.chatGroup?.id}'),
          ],
        ),
        body: Column(children: [
          Expanded(
              child: ListWheelScrollView(
            itemExtent: 50,
            children:
                selectedLastMsg.body.characters.map((e) => Text(e)).toList(),
          )),
          Padding(padding: EdgeInsetsDirectional.only(bottom: 20)),
          Row(children: <Widget>[
            Expanded(
                child:
                    TextFormField(initialValue: selectedLastMsg?.body ?? '')),
            ElevatedButton(
              child: Text('SEND'),
              onPressed: () => {print('not sent!')},
            )
          ])
        ]));
  }
}
