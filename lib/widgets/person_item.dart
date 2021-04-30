// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --
// -- models
import '../models/person.dart';

// -- pages
import '../pages/person_details.dart';
//

class PersonItem extends StatelessWidget {
  final Person buddy;

  const PersonItem({Key key, this.buddy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ImageProvider<Object> iPv = AssetImage("avatar.png");

    if (buddy.photoURL.startsWith("http")) {
      iPv = NetworkImage(
        buddy.photoURL,
      );
    } else if (buddy.photoURL != "") {
      iPv = AssetImage("${buddy.photoURL}.jpg");
    }
    return Card(
      key: ValueKey(buddy.username),
      color: Colors.cyan.shade100,
      margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
      child: Padding(
        child: Column(
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PersonDetailsPage(selectedPerson: buddy)),
                  );
                },
                child: Text(this.buddy.name)),
            CircleAvatar(backgroundImage: iPv),
          ],
        ),
        padding: EdgeInsets.all(8.0),
      ),
    );
  }
}
