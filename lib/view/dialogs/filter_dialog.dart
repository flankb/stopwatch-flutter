
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterDialog extends StatelessWidget {
  final Type entityType;

  const FilterDialog({Key key, this.entityType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FilterForm();
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
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              validator: (value) {
                if (value.isEmpty) {
                  return 'Поле не может быть пустым!';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: RaisedButton(
                onPressed: () {
                  // Validate returns true if the form is valid, or false
                  // otherwise.
                  if (_formKey.currentState.validate()) {
                    // If the form is valid, display a Snackbar.
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text('Обработка данных..')));
                  }
                },
                child: Text('Сохранить'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}