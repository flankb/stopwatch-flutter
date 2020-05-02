import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String version = '1.0.1'; // Использовать https://pub.dev/packages/package_info

    return Scaffold(
      appBar: AppBar(
        title: Text("О программе"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text('Программа шаблон',
                    style: TextStyle(fontSize: 20)),
              ),
              Flexible(child: Text('Версия $version', style: TextStyle(fontSize: 20))),
            ],
          )
      ),
    );
  }
}
