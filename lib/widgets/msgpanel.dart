import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../types/chat.dart' show Chat;
import '../types/draft.dart' show Draft;
import '../types/mbody.dart' show RawBody, ImageBody;
import 'package:file_picker/file_picker.dart';
import '../helpers/file_context.dart';
import '../main.dart';
import '../pages/texting.dart';

class MessagingPanel extends StatefulWidget {
  final Chat chatItem;
  const MessagingPanel(this.chatItem, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MessagingPanelState();
}

class MessagingPanelState extends State<MessagingPanel> {
  final TextEditingController teC = TextEditingController();
  Draft currentDraft;
  MessagingPanelState();

  TextingPage get parentWidget =>
      context.findAncestorWidgetOfExactType<TextingPage>();
  TextingPageState get parentState =>
      context.findAncestorStateOfType<TextingPageState>();

  @override
  void initState() {
    super.initState();
    currentDraft = parentWidget.chatItem.createDraft(meSession, null);
  }

  @override
  Widget build(BuildContext context) => _subPanel;

  Future<void> _sendMes([String _ = '']) async {
    if (await _msgPush(RawBody(teC.text))) teC.text = '';
  }

  Future<bool> _msgPush(RawBody mb) async {
    final _ = mb.toString();
    if (_.trim() != '') {
      currentDraft.setBody = mb;
      parentState.onMsgSendClaimed(currentDraft, ({itemAdded, errorMsg}) {
        // fired back here...
        if (itemAdded != null)
          setState(() => null);
        else
          print(errorMsg);
      });

      return true;
    }
    return false;
  }

  Future<void> _sendImg([String _ = '']) async => await _msgPush(ImageBody(_));

  Widget get _subPanel => Padding(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 5),
      child: Column(children: [
        (parentState.quotedMessage == null
            ? Row()
            : Dismissible(
                key: Key(widget.chatItem.id),
                child: Card(
                  color: Colors.indigo.shade100,
                  child: Padding(
                      padding: EdgeInsets.all(3),
                      child: Column(children: [
                        TextButton(
                            onPressed: () =>
                                parentState.onMsgQuoted?.call(null),
                            child: Icon(Icons.close)),
                        Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                        Text('${parentState.quotedMessage.from.caption}:'),
                        Padding(padding: EdgeInsets.symmetric(vertical: 3)),
                        GestureDetector(
                          onTap: () {
                            teC.text =
                                parentState.quotedMessage.body.toString();
                          },
                          child: Text(parentState.quotedMessage.body
                                      .toString()
                                      .length >
                                  497
                              ? '${parentState.quotedMessage.body.toString().substring(0, 497)}...'
                              : '${parentState.quotedMessage.body}'),
                        )
                      ])),
                ),
                onDismissed: (_) => parentState.onMsgQuoted?.call(null),
                direction: DismissDirection.vertical,
              )),
        _butt()
      ]));

  Card _butt() {
    return Card(
        color: Colors.grey.shade200,
        margin: EdgeInsets.all(4),
        child: Row(children: [
          Expanded(
            child: TextField(
              //minLines: 1,
              //maxLines: 4,
              controller: teC,
              onSubmitted: _sendMes,
              style: TextStyle(fontSize: 16),
              //keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: 'type a message.',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
            ),
          ),
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
