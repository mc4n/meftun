// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/person.dart';
// --

import '../widgets/person_item.dart';
//

class PeopleList extends StatelessWidget {
  final List<Person> buddies;

  const PeopleList({Key key, this.buddies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text("People"),
          padding: EdgeInsets.symmetric(vertical: 16.0),
        ),
        buddies.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: buddies.length,
                  itemBuilder: (BuildContext context, int index) {
                    return PersonItem(buddy: buddies[index]);
                  },
                ),
              )
            : Text("No people to show."),
      ],
    );
  }
}
