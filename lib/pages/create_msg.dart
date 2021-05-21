import 'package:me_flutting/models/draft.dart';

//
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CreateMessagePage extends StatefulWidget {
  final Draft selectedLastMsg;

  CreateMessagePage({Key key, this.selectedLastMsg}) : super(key: key);

  @override
  CreateMessagePageState createState() {
    return new CreateMessagePageState(this.selectedLastMsg);
  }
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final _formKey = GlobalKey<FormState>();

  final Draft selectedLastMsg;
  CreateMessagePageState(this.selectedLastMsg);

  static CreateMessagePageState of(BuildContext context) {
    return context.findAncestorStateOfType<CreateMessagePageState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        leading: CloseButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => TextButton(
              child: Text("SEND"),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('$selectedLastMsg'),
            ],
          ),
        ),
      ),
    );
  }
}
