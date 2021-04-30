// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --
import '../models/person.dart';
//

class PersonDetailsPage extends StatelessWidget {
  final Person selectedPerson;
  const PersonDetailsPage({Key key, this.selectedPerson}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: new Text("Person Details"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Text(
              this.selectedPerson.name,
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
