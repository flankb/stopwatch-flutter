import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String version = '1.0.0'; // Использовать https://pub.dev/packages/package_info

    return Scaffold(

      body: SafeArea(

        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                BackButton(),
                Text("О программе", style: TextStyle(fontSize: 36),)
              ],
            ),
            Expanded(
              child: Container(
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
            ),
          ],
        ),
      ),
    );
  }
}
