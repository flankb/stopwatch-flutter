import 'package:flutter/widgets.dart';
import 'package:rate_my_app/rate_my_app.dart';

mixin AppReviewer {
  rateMyApp(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2));

    RateMyApp rateMyApp = RateMyApp(
      preferencesPrefix: 'rate_my_app_',
      minDays: 0,
      minLaunches: 1,
      remindDays: 0,
      remindLaunches: 5,
      googlePlayIdentifier: 'fr.skyost.example',
      appStoreIdentifier: '1491556149',
    );


    rateMyApp.init().then((_) {
      if (rateMyApp.shouldOpenDialog || true) {
        rateMyApp.showRateDialog(context,
            title: 'Просьба об оценке',
            // The dialog title.
            message:
            'Пожалуйста, оцените приложение, это очень важно для нас!',
            // The dialog message.
            rateButton: 'Оценить',
            // The dialog "rate" button text.
            noButton: 'Нет, спасибо',
            // The dialog "no" button text.
            laterButton: 'Позже',
            ignoreIOS: false,
            dialogStyle: DialogStyle(),
            // The dialog "later" button text.
            listener: (button) {
              // The button click listener (useful if you want to cancel the click event).
              switch (button) {
                case RateMyAppDialogButton.rate:
                  print('Clicked on "Rate".');
                  break;
                case RateMyAppDialogButton.later:
                  print('Clicked on "Later".');
                  break;
                case RateMyAppDialogButton.no:
                  print('Clicked on "No".');
                  break;
              }

              return true;
            });
      }
    });
  }
}