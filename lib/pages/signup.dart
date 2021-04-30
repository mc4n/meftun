// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Register"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Container(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Username:'),
                    ),
                  ),
                  Container(
                    child: TextField(
                      decoration: InputDecoration(labelText: 'Name:'),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Column(
                children: <Widget>[
                  TextButton(
                    child: Text('Register'),
                    onPressed: () => {
                      // done!
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
