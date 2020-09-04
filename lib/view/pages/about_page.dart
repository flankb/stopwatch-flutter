import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import 'history_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String version = '1.1.0'; // Использовать https://pub.dev/packages/package_info
    final debuggable = false;

    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'everyapp@yandex.ru',
        queryParameters: {
          'subject': 'Message about stopwatch (Flutter) program'
        }
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PageCaption(caption : S.of(context).about),
            /*Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                BackButton(),
                Text(
                  S.of(context).about,
                  style: TextStyle(fontSize: 36),
                )
              ],
            ),*/
            Expanded(
              child: Container(
                  margin: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(S.of(context).stopwatch, style: TextStyle(fontSize: 20)),
                      Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Text('Copyright © 2020 Garnet Juice', style: TextStyle(fontSize: 18),),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('${S.of(context).version} $version', style: TextStyle(fontSize: 20)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            launch(_emailLaunchUri.toString());
                          },
                          child: Text(
                            'everyapp@yandex.ru',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Theme.of(context).primaryColor,
                              fontSize: 18
                            ),
                          ),
                        ),
                      )
                    ],
                  )),
            ),
            if (debuggable)
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.all(16),
                      child: Text("Удалить БД"),
                      fillColor: Colors.amber,
                      onPressed: () async {
                        final res = await showDialog(
                            context: context,
                            child: new Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Text("Вайпнуть БД?"),
                                  Row(
                                    children: <Widget>[
                                      RawMaterialButton(
                                        child: Text("ДА"),
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                      RawMaterialButton(
                                        child: Text("Нет"),
                                        onPressed: () {
                                          Navigator.pop(context, false);
                                        },
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ));

                        if (res == true) {
                          final rep = StopwatchRepository();
                          await rep.wipeDatabaseDebug();
                          // Вайп
                          /*Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("БД удалена!"),
                        ));*/ //TODO Валится из-за вложенных Scafoldов
                        }
                        //BlocProvider.of<MeasureBloc>(context).add(MeasureOpenedEvent());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RawMaterialButton(
                        child: Text("Посмотреть БД"),
                        padding: const EdgeInsets.all(16),
                        fillColor: Colors.green,
                        onPressed: () {
                          final db = MyDatabase(); //This should be a singleton
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
                        }),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
