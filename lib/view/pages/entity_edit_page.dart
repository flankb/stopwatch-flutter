import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/widgets/inherited/storage_blocs_provider.dart';

/// Виджет ркдактирования измерения или круга
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
        body:
            SafeArea(child: _EditForm(entity: entity, entityType: entityType)));
  }
}

// Define a custom Form widget.
class _EditForm extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final Type entityType;

  const _EditForm({Key? key, required this.entity, required this.entityType})
      : super(key: key);

  @override
  _EditFormState createState() {
    return _EditFormState();
  }
}

class _EditFormState extends State<_EditForm> {
  final _formKey = GlobalKey<FormState>();

  late EntityBloc entityBloc;
  late TextEditingController textController;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  _init() {
    // TODO Убрать отсюда в didChangeDependencies! А лучше в BlocProvider
    final storageBloc = widget.entityType == MeasureViewModel
        ? StorageBlocsProvider.of(context).measuresBloc
        : StorageBlocsProvider.of(context).lapsBloc;

    entityBloc = storageBloc.entityBloc;
    entityBloc.add(OpenEntityEvent(widget.entity));

    textController = new TextEditingController(text: widget.entity.comment);
  }

  @override
  Widget build(BuildContext context) {
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
                                //widget.entity.comment = textController.text;

                                entityBloc.add(SaveEntityEvent(widget.entity,
                                    comment: textController.text));

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
