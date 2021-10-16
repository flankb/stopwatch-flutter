import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';

class EntityEditPage extends StatelessWidget {
  final Type entityType;
  final int entityId;
  final BaseStopwatchEntity entity;

  const EntityEditPage(
      {Key? key,
      required this.entityType,
      required this.entityId,
      required this.entity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: EditForm(
      entity: entity,
    )));
  }
}

// Define a custom Form widget.
class EditForm extends StatefulWidget {
  final BaseStopwatchEntity entity;

  const EditForm({Key? key, required this.entity}) : super(key: key);

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
  final _formKey =
      GlobalKey<FormState>(); // TODO У формы обязательно должен быть ключ!!!

  late EntityBloc entityBloc;
  late TextEditingController textController;

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
    entityBloc = GetIt.I.get<EntityBloc>();
    entityBloc.add(OpenEntityEvent(widget.entity));

    textController = new TextEditingController(text: widget.entity.comment);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            BackButton(),
            Flexible(
                child: Text(
              S.of(context).editing,
              maxLines: 1,
              style: TextStyle(fontSize: 36),
            ))
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: BlocProvider(
                create: (BuildContext context) {
                  return entityBloc;
                },
                child: BlocBuilder<EntityBloc, EntityState>(
                    builder: (context, snapshot) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TextFormField(
                          autofocus: true,
                          decoration: InputDecoration(
                            labelText: S.of(context).input_comment,
                          ),
                          controller: textController,
                          validator: (value) {
                            if (value != null && value.length > 256) {
                              return S.of(context).very_long_comment;
                            }

                            return null;
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).primaryColor),
                            ),
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                widget.entity.comment = textController.text;
                                entityBloc.add(SaveEntityEvent(widget.entity));

                                Navigator.pop(context);
                              }
                            },
                            child: Text(S.of(context).save),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
