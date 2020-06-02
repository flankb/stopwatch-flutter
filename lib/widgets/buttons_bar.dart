
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:launch_review/launch_review.dart';
import 'package:learnwords/bloc/measure_bloc/measure_bloc.dart';
import 'package:learnwords/bloc/measure_bloc/measure_event.dart';
import 'package:learnwords/bloc/measure_bloc/measure_state.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/view/pages/about_page.dart';
import 'package:learnwords/view/pages/history_page.dart';
import 'package:learnwords/view/pages/settings_page.dart';

// This is the type used by the popup menu below.
enum WhyFarther { review, about }

class ButtonsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //var measureBloc = BlocProvider.of<MeasureBloc>(context);

    return BlocBuilder<MeasureBloc, MeasureState>(builder: (BuildContext context, MeasureState state) {
      return Container(
        //color: Colors.redAccent,
        height: 56,
        width: MediaQuery
            .of(context)
            .size
            .width,
        decoration: BoxDecoration(
          //borderRadius: BorderRadius.circular(8.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 2.0,
              spreadRadius: 0.0,
              offset: Offset(2.0, 2.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              // Кнопка с подсказкой внизу:
              // https://api.flutter.dev/flutter/material/IconButton-class.html
              // Так же можно обернуть в InkWell

              IconButton(
                icon: Icon(Icons.ac_unit),
                color: Colors.blue,
                tooltip: 'Ready state',
                onPressed: () {
                  BlocProvider.of<MeasureBloc>(context).add(MeasureOpenedEvent());
                },
              ),

              IconButton(
                icon: Icon(Icons.refresh),
                tooltip: 'Сброс',
                onPressed: () {
                  BlocProvider.of<MeasureBloc>(context).add(MeasureFinishedEvent());
                },
              ),

              IconButton(
                icon: Icon(Icons.list),
                tooltip: 'История',
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                    return HistoryPage(pageType: MeasureViewModel, entityId: -1,);
                  }));
                },
              ),

              IconButton(
                icon: Icon(Icons.settings),
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