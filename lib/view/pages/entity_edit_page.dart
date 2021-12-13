import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stopwatch/bloc/entity_bloc/bloc.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/widgets/inherited/storage_blocs_provider.dart';

/// Виджет редактирования измерения или круга
class EntityEditPage extends StatelessWidget {
  final Type entityType;
  final int entityId;
  final BaseStopwatchEntity entity;

  const EntityEditPage({
    required this.entityType,
    required this.entityId,
    required this.entity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body:
            SafeArea(child: _EditForm(entity: entity, entityType: entityType)),
      );
}

// Define a custom Form widget.
class _EditForm extends StatefulWidget {
  final BaseStopwatchEntity entity;
  final Type entityType;

  const _EditForm({
    required this.entity,
    required this.entityType,
    Key? key,
  }) : super(key: key);

  @override
  _EditFormState createState() => _EditFormState();
}

class _EditFormState extends State<_EditForm> {
  final _formKey = GlobalKey<FormState>();

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

  void _init() {
    textController = TextEditingController(text: widget.entity.comment);
  }

  @override
  Widget build(BuildContext context) => Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const BackButton(),
              Flexible(
                child: Text(
                  S.of(context).editing,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 36),
                ),
              )
            ],
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: BlocProvider.value(
                  value: (widget.entityType == MeasureViewModel
                          ? StorageBlocsProvider.of(context).measuresBloc
                          : StorageBlocsProvider.of(context).lapsBloc)
                      .entityBloc,
                  child: BlocBuilder<EntityBloc, EntityState>(
                    builder: (entityContext, snapshot) => Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            autofocus: true,
                            decoration: InputDecoration(
                              labelText: S.of(entityContext).input_comment,
                            ),
                            controller: textController,
                            validator: (value) {
                              if (value != null && value.length > 256) {
                                return S.of(entityContext).very_long_comment;
                              }

                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                  Theme.of(entityContext).primaryColor,
                                ),
                              ),
                              onPressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  entityContext.read<EntityBloc>().add(
                                        SaveEntityEvent(
                                          widget.entity,
                                          comment: textController.text,
                                        ),
                                      );

                                  Navigator.pop(context);
                                }
                              },
                              child: Text(S.of(entityContext).save),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}
