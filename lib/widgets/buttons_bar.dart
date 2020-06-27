
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_bloc.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_event.dart';
import 'package:stopwatch/bloc/measure_bloc/measure_state.dart';
import 'package:stopwatch/model/database_models.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';
import 'package:stopwatch/view/pages/about_page.dart';
import 'package:stopwatch/view/pages/history_page.dart';
import 'package:stopwatch/view/pages/settings_page.dart';
import 'package:moor_db_viewer/moor_db_viewer.dart';
import 'package:toast/toast.dart';

// This is the type used by the popup menu below.
enum WhyFarther { review, about }

class ButtonsBar extends StatelessWidget {
  final AnimationController parentAnimationController;

  const ButtonsBar({Key key, @required this.parentAnimationController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //var measureBloc = BlocProvider.of<MeasureBloc>(context);

    return BlocBuilder<MeasureBloc, MeasureState>(builder: (BuildContext context, MeasureState state) {
      return Container(
        //color: Colors.redAccent,
        height: 56,
        /*width: MediaQuery
            .of(context)
            .size
            .width,*/
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(8.0),
          color: Theme.of(context).bottomAppBarColor,
          boxShadow: [
            BoxShadow(
              color: const Color(0xff3F3C3C),
              blurRadius: 1.0,
              spreadRadius: 0.0,
              offset: Offset(0.3, 0.3), // shadow direction: bottom right
            )
          ],
            borderRadius: new BorderRadius.horizontal(
              left: new Radius.circular(10.0),
              right: new Radius.circular(10.0),
            )
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // Кнопка с подсказкой внизу:
              // https://api.flutter.dev/flutter/material/IconButton-class.html
              // Так же можно обернуть в InkWell

              // Пример AppBar'a:
              // https://flutter.dev/docs/catalog/samples/basic-app-bar
              // PopupMenu сделано также как у меня

              /*MenuButton(
                pic: Icons.ac_unit,
                color: Colors.red,
                tooltip: 'View database',
                onPressed: () {
                  final db = MyDatabase(); //This should be a singleton
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
                },
              ),

              MenuButton(
                pic: Icons.ac_unit,
                color: Colors.blue,
                tooltip: 'Ready (Open) state',
                onPressed: () async {
                  final res = await showDialog(context: context, child: new Dialog(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text("Вайпнуть БД?"),
                        Row(
                          children: <Widget>[
                            RawMaterialButton(
                              child : Text("ДА"),
                              onPressed: () {
                                Navigator.pop(context, true);
                            },),
                            RawMaterialButton(
                              child : Text("Нет"),
                              onPressed: () {
                                Navigator.pop(context, false);
                            },)
                          ],
                        )
                      ],
                    ),
                  ));

                  if (res == true){
                    final rep = StopwatchRepository();
                    await rep.wipeDatabaseDebug();

                    // Вайп
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text("БД удалена!"),
                    ));
                  }

                  BlocProvider.of<MeasureBloc>(context).add(MeasureOpenedEvent());
                  //  BlocProvider.of<MeasureBloc>(context).add(MeasureOpenedEvent());
                },
              ),*/

              MenuButton(
                pic: Icons.refresh,
                tooltip: 'Сброс',
                onPressed: () {
                  BlocProvider.of<MeasureBloc>(context).add(MeasureFinishedEvent());

                  if (parentAnimationController.isCompleted) {
                    parentAnimationController.reverse();
                  } else {
                    parentAnimationController.forward();
                  }
                },
              ),

              MenuButton(
                pic: Icons.list,
                tooltip: 'История',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return HistoryPage(pageType: MeasureViewModel, entityId: -1,);
                  }));
                },
              ),

              MenuButton(
                pic: Icons.settings,
                tooltip: 'Settings',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return SettingsPage();
                  }));
                },
              ),

              // This menu button widget updates a _selection field (of type WhyFarther,
              // not shown here).
              PopupMenuButton<WhyFarther>(
                onSelected: (WhyFarther result) {
                  switch (result) {
                    case WhyFarther.review:
                      LaunchReview.launch(
                        androidAppId: "com.garnetjuice.stopwatch",
                        iOSAppId: "585027354",
                      );
                      break;
                    case WhyFarther.about:
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                        return AboutPage();
                      }));
                      break;
                  }
                },
                itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<WhyFarther>>[
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.review,
                    child: Text('Оценить приложение'),
                  ),
                  const PopupMenuItem<WhyFarther>(
                    value: WhyFarther.about,
                    child: Text('О программе'),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    },
    );
  }
}

class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData pic;
  final Color color;
  final String tooltip;

  const MenuButton({
    Key key, this.onPressed, this.pic, this.color, this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(pic),
      color: color,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

/*
class MenuButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData pic;

  const MenuButton({
    Key key, this.onPressed, this.pic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal : 8.0),
      child: IconButton(
        icon: Icon(Icons.ac_unit),
        color: Colors.red,
        tooltip: 'View database',
        onPressed: () {
          final db = MyDatabase(); //This should be a singleton
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MoorDbViewer(db)));
        },
      ),
    );
  }
}
 */