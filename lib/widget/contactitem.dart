import 'package:flutter/material.dart';
import 'package:me_flutting/models/person.dart';

class ContactItem extends StatefulWidget {
  final List<Person> dormantContacts;
  ContactItem({Key key, this.dormantContacts});

  @override
  State<StatefulWidget> createState() {
    return ContactItemState(dormantContacts);
  }
}

class ContactItemState extends State<ContactItem> {
  final List<Person> dormantContacts;
  ContactItemState(this.dormantContacts);

  Widget _lv(int ct, Widget Function(BuildContext context, int index) bItem) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: BouncingScrollPhysics(),
      itemCount: ct,
      itemBuilder: (BuildContext context, int index) {
        return bItem(context, index);
      },
    );
  }

  Widget _single(BuildContext c, int i) {
    var ctq = dormantContacts[i];
    return TextButton(
        onPressed: () {
          //
        },
        //padding: EdgeInsets.symmetric(horizontal: 20),
        child: _contCard(ctq));
  }

  Widget _contCard(Person ctq) {
    return Card(
      key: ValueKey(ctq.id),
      color: Colors.blue.shade300,
      margin: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
      child: Padding(
        child: Column(children: [
          Text('${ctq.username} :'),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          CircleAvatar(backgroundImage: AssetImage('assets/avatar.png'))
        ]),
        padding: EdgeInsets.all(15.0),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      dormantContacts == null || dormantContacts.length == 0
          ? Spacer()
          : Expanded(child: _lv(dormantContacts.length, _single))
    ]);
  }
}
