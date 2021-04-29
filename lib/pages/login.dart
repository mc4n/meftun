// -- external libs

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/board.dart';
import 'package:me_flutting/models/mock_repo.dart';
import 'package:me_flutting/models/person.dart';
import 'package:me_flutting/pages/signup.dart';
// --

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
      title: new Text("Login"),
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
          new ElevatedButton(
            child: new Text('Login'),
            onPressed: _loginClaimed,
          ),
          new TextButton(
            child: new Text('Sign Up'),
            onPressed: _createAccountClaimed,
          ),
        ],
      ),
    );
  }

  void _loginClaimed() {
    Person user = null;

    try {
      user = mocklocalUsers.firstWhere((i) => i.username == _uName);
      if (user == null) {
        user = Person(username: "<default>", name: "Anonymous", photoURL: "");
      }
    } catch (e) {
      user = Person(username: "<default>", name: "Anonymous", photoURL: "");
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BoardPage(userLoggedin: user)),
    );
  }

  void _createAccountClaimed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }
}
