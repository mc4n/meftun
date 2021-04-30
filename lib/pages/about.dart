// -- external libs

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// --

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: new Text("About"),
        centerTitle: true,
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            Text(
              "Bu uygulama Dr. Öğretim Üyesi Ahmet Cevahir ÇINAR tarafından "
              " yürütülen 3301456 kodlu MOBİL PROGRAMLAMA dersi kapsamında "
              " 193301069 numaralı Mustafa Can Akpınar tarafından "
              "30 Nisan 2021 günü yapılmıştır.",
              maxLines: 4,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
