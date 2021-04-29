// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
// --

// -- model uses
import '../models/draft.dart';
// --

// -- pages
//

class DraftList extends StatelessWidget {
  final List<Draft> drafts;

  const DraftList({Key key, this.drafts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Padding(
          child: Text("Drafts"),
          padding: EdgeInsets.only(top: 16.0),
        ),
        drafts.length > 0
            ? Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: drafts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(
                        "${drafts[index].to} --> ${drafts[index].body}");
                  },
                ),
              )
            : Text("No draft was found."),
      ],
    );
  }
}
