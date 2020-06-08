import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learnwords/bloc/entity_bloc/bloc.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';
import 'package:learnwords/resources/stopwatch_db_repository.dart';

class EntityEditPage extends StatelessWidget {
  final Type entityType;
  final int entityId;
  final BaseStopwatchEntity entity;

  const EntityEditPage({Key key, this.entityType, this.entityId, this.entity}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Редактирование измерения"),
        ),
        body: EditForm(entity: entity,));
  }
}

// Define a custom Form widget.
class EditForm extends StatefulWidget {
  final BaseStopwatchEntity entity;

  const EditForm({Key key, this.entity}) : super(key: key);

  @override
  EditFormState createState() {
    return EditFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class EditFormState extends State<EditForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>(); // TODO У формы обязательно должен быть ключ!!!

  EntityBloc entityBloc;
  TextEditingController textController;

  @override
  void dispose() {
    super.dispose();
    entityBloc.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    entityBloc = EntityBloc(StopwatchRepository(MyDatabase()));
    entityBloc.add(OpenEntityEvent(widget.entity));

    textController = new TextEditingController(text: widget.entity.comment);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: BlocProvider(
        create: (BuildContext context) {
          return entityBloc;
        },
        child: BlocBuilder<EntityBloc, EntityState>(builder: (context, snapshot) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Введите комментарий',
                  ),
                  //initialValue: snapshot is AvailableEntityState ? snapshot?.entity?.comment : "",
                  controller: textController,
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
                        //Scaffold.of(context).showSnackBar(SnackBar(content: Text('Обработка данных..')));

                        widget.entity.comment = textController.text;
                        entityBloc.add(SaveEntityEvent(widget.entity));

                        Navigator.pop(context);
                      }
                    },
                    child: Text('Сохранить'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
