
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FilterDialog extends StatelessWidget {
  final Type entityType;

  const FilterDialog({Key key, this.entityType}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // Обернуть в Dialog??? Либо в AlertDialog
    // https://medium.com/flutterpub/flutter-alert-dialog-to-custom-dialog-966195157da8
    // https://medium.com/@excogitatr/custom-dialog-in-flutter-d00e0441f1d5

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: FilterForm(),
    );
  }
}

// Define a custom Form widget.
class FilterForm extends StatefulWidget {
  @override
  FilterFormState createState() {
    return FilterFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class FilterFormState extends State<FilterForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");

    // Build a Form widget using the _formKey created above.
    return  Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 10.0),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Фильтр измерений"),
                    TextFormField(
                      initialValue: "Измерение содержит...",
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Поле не может быть пустым!';
                        }
                        return null;
                      },
                    ),
                    DateTimeField(
                      format: format,
                      initialValue: DateTime.now(),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                    DateTimeField(
                      format: format,
                      initialValue: DateTime.now(),
                      onShowPicker: (context, currentValue) {
                        return showDatePicker(
                            context: context,
                            firstDate: DateTime(1900),
                            initialDate: currentValue ?? DateTime.now(),
                            lastDate: DateTime(2100));
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RaisedButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false
                              // otherwise.
                              if (_formKey.currentState.validate()) {
                                // If the form is valid, display a Snackbar.
                                //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Обработка данных..')));
                              }
                            },
                            child: Text('Сохранить'),
                          ),
                          SizedBox(
                            width: 16,
                          ),
                          RaisedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Отмена'),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );

  }
}