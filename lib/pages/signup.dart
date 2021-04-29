// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _uNameFilter = new TextEditingController();
  String _uName = "";

  _LoginPageState() {
    void _uNameListen() {
      if (_uNameFilter.text.isEmpty) {
        _uName = "";
      } else {
        _uName = _uNameFilter.text;
      }
    }

    _uNameFilter.addListener(_uNameListen);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: new Text("Register"),
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new Container(
            child: new TextField(
              controller: _uNameFilter,
              decoration: new InputDecoration(labelText: 'Username:'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new TextButton(
            child: new Text('Register'),
            onPressed: () => {
              // done!
            },
          ),
        ],
      ),
    );
  }
}
