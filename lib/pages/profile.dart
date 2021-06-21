import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../main.dart';
import 'usageinfo.dart' show UsageInfoPage;
import 'dart:convert';
//import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final bool isMe;

  const ProfilePage(this.userName, [this.isMe = false]);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //bool edit = false;
  final tedit = TextEditingController();
  Map<String, dynamic> _obj = {
    'display_name': 'Ali Desidero',
    'birth_date': '01-01-1970',
    'gender': 'male',
  };

  Future<void> _onSave() async {
    try {
      final oooo = json.decode(tedit.text);
      _obj = oooo;
      setState(() => null);
    } catch (_) {
      print(_.message);
    }
  }

  Widget _body(String uname) {
    tedit.text = json.encode(_obj).toString();
    final lsKey = _obj.keys.toList();
    final topp = Expanded(
        child: ListView.builder(
            itemCount: lsKey.length,
            itemBuilder: (_, i) {
              final _ky = lsKey[i];
              final _item = _obj[_ky];
              return Text('$_ky : $_item', style: TextStyle(fontSize: 20));
            }));

    final butt = Card(
        color: Colors.yellow.shade200,
        child: Stack(children: [
          TextField(minLines: 15, maxLines: 15, controller: tedit),
          Align(
              alignment: Alignment.bottomRight,
              child: TextButton(onPressed: _onSave, child: Icon(Icons.save))),
        ]));
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [topp, butt]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(),
          title: Text('Profile/${widget.userName}'),
        ),
        body: _body(widget.userName),
        persistentFooterButtons: _footers(widget.isMe));
  }

  List<Widget> _footers(bool cond) => cond
      ? [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Scaffold(
                    appBar: AppBar(
                      leading: CloseButton(),
                      title: Text('Usage Data'),
                    ),
                    body: UsageInfoPage(),
                  );
                }));
              },
              child: Text('Usage Statistics')),
          Text('Settings')
        ]
      : [Row()];
}
