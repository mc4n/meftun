import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../pages/profile.dart' show ProfilePage;
import '../widgets/msgdialogs.dart' show MessageDialogs;
import '../models/chat.dart' show Chat;
import '../models/message.dart' show Message;
//import '../models/mbody.dart' show RawBody, ImageBody;
import 'package:file_picker/file_picker.dart';
import '../helpers/filehelpers.dart';

class TextingPage extends StatefulWidget {
  static void letTheGameBegin(BuildContext context, final Chat chatItem,
      final void Function(String) onMsgSent) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => TextingPage(chatItem, onMsgSent),
      ),
    );
  }

  final Chat chatItem;
  final void Function(String) onMsgSent;

  const TextingPage(this.chatItem, this.onMsgSent, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TextingPageState();
}

class TextingPageState extends State<TextingPage> {
  final TextEditingController teC = TextEditingController();
  Message quotedMessage;
  void Function(Message msgQuoted) onMsgQuoted;
  TextingPageState() {
    onMsgQuoted = (_) {
      setState(() {
        quotedMessage = _;
      });
    };
  }
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
                      builder: (_) => ProfilePage(widget.chatItem)));
                },
                child: Row(children: [
                  CircleAvatar(
                      backgroundImage: AssetImage(widget.chatItem.photoURL)),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
                  Text('${widget.chatItem.caption}',
                      style: TextStyle(color: Colors.white, fontSize: 23))
                ])),
            Row(children: [
              TextButton(
                  onPressed: () {
                    /*.removeContact(widget.chatItem);
                      widget.onMsgSent(null);
                      Navigator.of(context).pop();*/
                  },
                  child: Icon(Icons.person_remove_alt_1_sharp,
                      color: Colors.blue.shade100)),
              TextButton(
                  onPressed: () {
                    /*.clearMessages();
                    setState(() => null);
                    widget.onMsgSent(null);*/
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
    /*var data = teC.text;
    if (data.trim() != '') {
      var msg = widget.messageFactory.addMessageBody(RawBody(data));
      if (DateTime.now().second % 3 == 0) widget.messageFactory.addReplyTo(msg);
      if (widget.onMsgSent != null) {
        widget.onMsgSent(data);
        setState(() => null);
      }
      teC.text = '';
    }*/
  }

  void _sendImg([String _ = '']) {
    /*if (_.trim() != '') {
      var msg = widget.messageFactory.addMessageBody(ImageBody(_));
      if (DateTime.now().second % 3 == 0) widget.messageFactory.addReplyTo(msg);
      if (widget.onMsgSent != null) {
        widget.onMsgSent(_);
        setState(() => null);
      }
    }*/
  }

  Column _body() => Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageDialogs(null),
            Padding(
                padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
                child: Column(children: [
                  (quotedMessage == null
                      ? Row()
                      :

                      //

                      Card(
                          color: Colors.indigo.shade100,
                          child: Padding(
                            padding: EdgeInsets.all(3),
                            child: Column(children: [
                              TextButton(
                                  onPressed: () => onMsgQuoted(null),
                                  child: Icon(Icons.close)),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 2)),
                              Text('${quotedMessage.from.caption}:'),
                              Padding(
                                  padding: EdgeInsets.symmetric(vertical: 3)),
                              /*quotedMessage.body is ImageBody
                                ? Container(width: 180, height: 180,
                                    child: Image.file(File(quotedMessage.body.toString())))
                                : */
                              Text('${quotedMessage.body}'),
                            ]),
                          ))

                  //

                  ),
                  _butt()
                ])),
          ]);

  Card _butt() {
    return Card(
        color: Colors.grey.shade200,
        margin: EdgeInsets.all(4),
        child: Row(children: [
          //
          Expanded(
            child: TextField(
              minLines: 1,
              maxLines: 5,
              controller: teC,
              onSubmitted: _sendMes,
              style: TextStyle(fontSize: 16),
              //keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'type a message.',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15.0)),
                ),
              ),
            ),
          ),
          //
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
              await _showMyDialog(result.files.first.path);
            },
            child: Icon(Icons.image_sharp, color: Colors.black),
          ),
        ]));
  }

  Future<void> _showMyDialog(String pth) {
    final _ifEx = (_file) => showDialog<void>(
          context: context,
          //barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Send Image'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Container(
                        width: 180, height: 180, child: Image.file(_file)),
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
                    _sendImg(pth ?? '<IMAGE>');
                  },
                ),
              ],
            );
          },
        );

    return fileExists(pth, _ifEx, (_) {
      final snackBar = SnackBar(
          content: Text('ERROR: $_ is a broken or an invalid file path!'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }
}
