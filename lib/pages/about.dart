import 'package:flutter/material.dart';

Widget aboutPage(BuildContext context) => TextButton(
    onPressed: () => showDialog(
        context: context,
        builder: (_) => Center(
            child: Material(
                color: Colors.transparent, child: Card(child: Text('#'))))),
    child: Text('About'));
