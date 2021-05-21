import 'package:me_flutting/models/draft.dart';

import '../models/person.dart';
//
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CreateMessagePage extends StatefulWidget {
  final List<Person> buddys;
  final Draft draft;

  CreateMessagePage({Key key, this.buddys, this.draft}) : super(key: key);

  @override
  CreateMessagePageState createState() {
    return new CreateMessagePageState(this.draft);
  }
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final _formKey = GlobalKey<FormState>();

  final Draft _draftToSend;
  CreateMessagePageState(this._draftToSend);

  static CreateMessagePageState of(BuildContext context) {
    return context.findAncestorStateOfType<CreateMessagePageState>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Post a message."),
        leading: CloseButton(
          onPressed: () {
            // save draft here!
          },
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => TextButton(
              child: Text("POST"),
              style: TextButton.styleFrom(backgroundColor: Colors.white),
              onPressed: () {
                CreateMessagePageState.of(context).save();
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
              Text("Receipt:"),
              DropdownButtonFormField<Person>(
                hint: Text("Select a buddy"),
                value: _draftToSend.to,
                onChanged: (buddy) {
                  setState(() {
                    // change the value of 'to' field here!
                  });
                },
                items: widget.buddys
                    .map(
                      (f) => DropdownMenuItem<Person>(
                        value: f,
                        child: Text(f.name),
                      ),
                    )
                    .toList(),
                validator: (buddy) {
                  if (buddy == null) {
                    return "You must select a buddy to post a message to.";
                  }
                  return null;
                },
              ),
              Container(
                height: 16.0,
              ),
              Text("Message body:"),
              TextFormField(
                maxLines: 20,
                inputFormatters: [LengthLimitingTextInputFormatter(280)],
                validator: (value) {
                  if (value.isEmpty) {
                    return "You must enter the message.";
                  }
                  return null;
                },
              ),
              Container(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void save() {
    if (_formKey.currentState.validate()) {
      // send msg here!
      Navigator.pop(context);
    }
  }
}
