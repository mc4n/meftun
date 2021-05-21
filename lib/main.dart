import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:me_flutting/board.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mefluttin',
      home: BoardPage(),
    );
  }
}
