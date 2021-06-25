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
                        child: Text(
                            '''Bu uygulama Dr. Öğretim Üyesi Ahmet Cevahir ÇINAR tarafından
yürütülen 3301456 kodlu MOBİL PROGRAMLAMA dersi kapsamında 
193301069 numaralı Mustafa C. Akpınar tarafından 25 Haziran 2021 
günü yapılmıştır.''')))))),
    child: Text('About'));
