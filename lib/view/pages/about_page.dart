import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:package_info/package_info.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:url_launcher/url_launcher.dart';

import 'history_page.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const debuggable = true;

    final _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'everyapp@yandex.ru',
      queryParameters: <String, dynamic>{
        'subject': 'Message about stopwatch (Flutter) program'
      },
    );

    final infoFuture = PackageInfo.fromPlatform();

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            PageCaption(caption: S.of(context).about),
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).stopwatch,
                      style: const TextStyle(fontSize: 20),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 16),
                      child: Text(
                        'Copyright © 2020 Garnet Juice',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: FutureBuilder<PackageInfo>(
                        future: infoFuture,
                        builder: (context, snapshot) => Text(
                          snapshot.hasData
                              ? '${S.of(context).version} ${snapshot.data?.version}'
                              : '',
                          style: const TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: GestureDetector(
                        onTap: () {
                          launch(_emailLaunchUri.toString());
                        },
                        child: Text(
                          'everyapp@yandex.ru',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            color: Theme.of(context).primaryColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            if (debuggable)
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.all(16),
                      fillColor: Colors.amber,
                      onPressed: () async {
                        final res = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => Dialog(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                const Text('Do you want clear DB?'),
                                Row(
                                  children: <Widget>[
                                    RawMaterialButton(
                                      child: const Text('Yes'),
                                      onPressed: () {
                                        Navigator.pop(context, true);
                                      },
                                    ),
                                    RawMaterialButton(
                                      child: const Text('No'),
                                      onPressed: () {
                                        Navigator.pop(context, false);
                                      },
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );

                        if (res ?? false) {
                          final rep = StopwatchRepository();
                          await rep.wipeDatabaseDebug();

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Wiped!'),
                            ),
                          );
                        }
                        //BlocProvider.of<MeasureBloc>(context).add(MeasureOpenedEvent());
                      },
                      child: const Text('Удалить БД'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: RawMaterialButton(
                      padding: const EdgeInsets.all(16),
                      fillColor: Colors.green,
                      onPressed: () {
                        //final db = MyDatabase(); //This should be a singleton
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => MoorDbViewer(db)));
                      },
                      child: const Text('Посмотреть БД'),
                    ),
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
