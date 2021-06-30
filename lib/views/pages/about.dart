import 'package:flutter/material.dart';

Widget aboutPage(BuildContext context) => TextButton(
    onPressed: () => showDialog(
        context: context,
        builder: (_) => Center(
            child: Material(
                color: Colors.transparent,
                child: Card(
                    color: Colors.yellow.shade200,
                    child: Padding(
                        padding: EdgeInsets.all(30),
                        child: Text('''Copyright 2021 | Mustafa C. Akpinar
                        All rights reserved.''')))))),
    child: Text('About'));
