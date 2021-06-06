import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../pages/profile.dart' show ProfilePage;
import '../helpers/msghelper.dart' show MessageFactory;
import '../widgets/msgdialogs.dart' show MessageDialogs;
import '../models/mbody.dart' show RawBody, ImageBody;
import 'package:file_picker/file_picker.dart';

class TextingPage extends StatefulWidget {
  static void letTheGameBegin(
      BuildContext context,
      final void Function(String) onMsgSent,
      final MessageFactory messageFactory) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextingPage(messageFactory, onMsgSent),
      ),
    );
  }

  final void Function(String) onMsgSent;
  final MessageFactory messageFactory;

  const TextingPage(this.messageFactory, this.onMsgSent, {Key key})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TextingPageState();
}

class _TextingPageState extends State<TextingPage> {
  final TextEditingController teC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ProfilePage(widget.messageFactory)));
                },
                child: Row(children: [
                  CircleAvatar(
                      backgroundImage:
                          AssetImage(widget.messageFactory.chatItem.photoURL)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('${widget.messageFactory.chatItem.caption}',
                      style: TextStyle(color: Colors.white, fontSize: 23))
                ])),
            Row(children: [
              TextButton(
                  onPressed: () {
                    if (widget.messageFactory.chatFactory
                        .removeContact(widget.messageFactory.chatItem)) {
                      widget.onMsgSent(null);
                      Navigator.of(context).pop();
                    }
                  },
                  child: Icon(Icons.person_remove_alt_1_sharp,
                      color: Colors.blue.shade100)),
              TextButton(
                  onPressed: () {
                    widget.messageFactory.clearMessages();
                    setState(() => null);
                    widget.onMsgSent(null);
                  },
                  child: Icon(Icons.delete, color: Colors.yellow.shade100)),
            ])
          ],
        ),
      ),
      body: _body(),
    );
  }

  void _sendMes([String _ = '']) {
    var data = teC.text;
    if (data.trim() != '') {
      var msg = widget.messageFactory.addMessageBody(RawBody(data));
      if (DateTime.now().second % 3 == 0) widget.messageFactory.addReplyTo(msg);
      if (widget.onMsgSent != null) {
        widget.onMsgSent(data);
        setState(() => null);
      }
      teC.text = '';
    }
  }

  void _sendImg([String _ = '']) {
    if (_.trim() != '') {
      var msg = widget.messageFactory.addMessageBody(ImageBody(_));
      if (DateTime.now().second % 3 == 0) widget.messageFactory.addReplyTo(msg);
      if (widget.onMsgSent != null) {
        widget.onMsgSent(_);
        setState(() => null);
      }
    }
  }

  Column _body() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageDialogs(widget.messageFactory),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: _butt()),
          ]);

  Card _butt() {
    return Card(
        color: Colors.grey.shade200,
        margin: EdgeInsets.all(4),
        child: Row(children: [
          Expanded(
              child: TextField(
            controller: teC,
            onSubmitted: _sendMes,
            style: TextStyle(fontSize: 16),
            //autofocus: true,
          )),
          Row(children: [
            TextButton(
              onPressed: _sendMes,
              child: Icon(Icons.send, color: Colors.black),
            )
          ]),
          TextButton(
            onPressed: () async {
              FilePickerResult result = await FilePicker.platform.pickFiles(
                type: FileType.image,
                //allowedExtensions: ['jpg', 'png'],
              );
              final pth = result.files.first.path;

              await _showMyDialog(pth ?? 'pac.jpg');
            },
            child: Icon(Icons.image_sharp, color: Colors.black),
          ),
        ]));
  }

  Future<void> _showMyDialog(String pth) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Send Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(width: 180, height: 180, child: Image.asset(pth)),
                Text('Would you like to send this image?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop()),
            TextButton(
              child: const Text('Send'),
              onPressed: () {
                Navigator.of(context).pop();
                final snackBar =
                    SnackBar(content: Text(pth ?? 'No file was specified.'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                _sendImg(pth ?? '<IMAGE>');
              },
            ),
          ],
        );
      },
    );
  }
}
