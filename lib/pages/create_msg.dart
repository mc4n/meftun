import '../models/person.dart';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

class CreateMessagePage extends StatefulWidget {
  final List<Person> buddys;

  CreateMessagePage({Key key, this.buddys}) : super(key: key);

  @override
  CreateMessagePageState createState() {
    return new CreateMessagePageState();
  }
}

class CreateMessagePageState extends State<CreateMessagePage> {
  final _formKey = GlobalKey<FormState>();
  Person _selectedPerson;

  static CreateMessagePageState of(BuildContext context) {
    return context.findAncestorStateOfType<
        CreateMessagePageState>(); //(TypeMatcher<CreateMessagePageState>());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post a message."),
        leading: CloseButton(),
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
                value: _selectedPerson,
                onChanged: (buddy) {
                  setState(() {
                    _selectedPerson = buddy;
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
      // store the inbox_msg request on firebase
      Navigator.pop(context);
    }
  }
}
