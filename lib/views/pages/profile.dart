import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'usageinfo.dart' show UsageInfoPage;
// import 'dart:convert';

class ProfilePage extends StatefulWidget {
  final String userName;
  final bool isMe;

  const ProfilePage(this.userName, [this.isMe = false]);

  @override
  State<StatefulWidget> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final tedit = TextEditingController();

  Future<void> _onSave() async {
    try {
      //final _obj = json.decode(tedit.text);
      //setState(() {});
    } catch (_) {
      print(_.message);
    }
  }

  Future<Map<String, dynamic>> _onLoad() async {
    final _mapped = {'result': 'undefined.'};
    tedit?.text = '\{  "new_key" : "new_value"  \}';
    return _mapped;
  }

  FutureBuilder<Map<String, dynamic>> _getDoc() {
    return FutureBuilder(
        future: _onLoad(),
        builder: (_, snap) {
          if (snap.hasData) {
            final _dat =
                snap.data.keys.where((k) => snap.data[k] != null)?.toList();
            final _len = _dat.length;
            if (_len > 0) {
              return Expanded(
                  child: ListView.builder(
                      itemCount: _len,
                      itemBuilder: (_, i) {
                        final _ky = _dat[i];
                        final _val = snap.data[_ky];
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('$_ky   :   $_val',
                                  style: TextStyle(fontSize: 20)),
                              Row(children: [
                                TextButton(
                                    onPressed: () async {
                                      tedit.text = '\{"$_ky" : "$_val"\}';
                                    },
                                    child: Icon(Icons.edit,
                                        color: Colors.green.shade900)),
                                TextButton(
                                    onPressed: () async {
                                      // await meColl
                                      //     .doc(widget.userName)
                                      //     ?.update({'$_ky': null});
                                      // setState(() => null);
                                    },
                                    child: Icon(Icons.delete,
                                        color: Colors.red.shade900))
                              ])
                            ]);
                      }));
            }
            return Text('no item');
          }
          return Text('fetchin\'...');
        });
  }

  Widget _body(String uname) {
    final butt = Card(
        color: Colors.yellow.shade200,
        child: Stack(children: [
          TextField(minLines: 9, maxLines: 9, controller: tedit),
          Align(
              alignment: Alignment.bottomRight,
              child: TextButton(
                  onPressed: _onSave,
                  child: Icon(Icons.save, color: Colors.blue.shade900))),
        ]));
    return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [_getDoc(), butt]);
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
