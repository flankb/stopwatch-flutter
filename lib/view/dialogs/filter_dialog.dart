
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stopwatch/models/filter.dart';

class FilterDialog extends StatelessWidget {
  final Type entityType;
  final Filter filter;

  const FilterDialog({Key key, this.entityType, this.filter}) : super(key: key);

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
      child: FilterForm(filter: filter,),
    );
  }
}

// Define a custom Form widget.
class FilterForm extends StatefulWidget {
  Filter filter;

  FilterForm({Key key, this.filter}) : super(key: key);

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
  //Filter _filter; // TODO Это поле можно передавать через конструктор и хранить его в BLoC'е

  //TextEditingController

  @override
  void initState() {
    super.initState();
    debugPrint("init FormState");
    // Создать контроллеры
    widget.filter ??= Filter.defaultFilter();
  }

  @override
  Widget build(BuildContext context) {
    final format = DateFormat("yyyy-MM-dd");

    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                color: Theme.of(context).bottomAppBarColor,
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
                      Text("Фильтр измерений", style: TextStyle(
                        fontSize: 18
                      ),),
                      SizedBox(height: 12,),
                      TextFormField(
                        initialValue: widget.filter.query,
                        decoration: InputDecoration(
                          hintText: "Наименование содержит..."
                        ),
                        onSaved: (val) => setState(() {
                          debugPrint(val);
                          widget.filter.query = val;
                        }),
                        /*validator: (value) {
                          if (value.isEmpty) {
                            return 'Поле не может быть пустым!';
                          }
                          return null;
                        },*/
                      ),
                      SizedBox(height: 6,),
                      DateTimeField(
                        format: format,
                        onSaved: (dt){
                          widget.filter.dateFrom = dt;
                        },
                        decoration: InputDecoration(labelText: "С:", labelStyle: TextStyle(color: Theme.of(context).accentColor)),
                        initialValue: widget.filter.dateFrom,
                        onShowPicker: (context, currentValue) {
                          return showDatePicker(
                              context: context,
                              firstDate: DateTime(1900),
                              initialDate: currentValue ?? DateTime.now(),
                              lastDate: DateTime(2100));
                        },
                      ),
                      SizedBox(height: 6,),
                      DateTimeField(
                        format: format,
                        onSaved: (dt){
                          // TODO setState вроде не нужен
                          widget.filter.dateTo = dt;
                        },
                        decoration: InputDecoration(labelText: "По:", labelStyle: TextStyle(color: Theme.of(context).accentColor)),
                        initialValue: widget.filter.dateTo,
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
                            RawMaterialButton(
                              onPressed: () {
                                // Validate returns true if the form is valid, or false
                                // otherwise.
                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();
                                  Navigator.pop(context, widget.filter);
                                  // If the form is valid, display a Snackbar.
                                  //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Обработка данных..')));
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('СОХРАНИТЬ'),
                              ),
                            ),
                            SizedBox(
                              width: 16,
                            ),
                            RawMaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('ОТМЕНА'),
                              ),
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
      ),
    );

  }
}