// -- external libs
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

// -- pages
import 'board.dart';
import 'pages/login.dart';
//

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Message Panel', home: LoginPage() //BoardPage(),
        );
  }
}
