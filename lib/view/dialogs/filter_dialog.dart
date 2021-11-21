import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/filter.dart';

class FilterDialog extends StatelessWidget {
  final Type entityType;
  final Filter filter;

  const FilterDialog({
    required this.entityType,
    required this.filter,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: FilterForm(
          filter: filter,
        ),
      );
}

// Define a custom Form widget.
class FilterForm extends StatefulWidget {
  final Filter filter;

  const FilterForm({
    required this.filter,
    Key? key,
  }) : super(key: key);

  @override
  FilterFormState createState() => FilterFormState();
}

class FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();

  late Filter changedFilter;

  @override
  void initState() {
    super.initState();
    debugPrint('init FormState');
    changedFilter = widget.filter;
  }

  @override
  Widget build(BuildContext context) {
    final myLocale = Localizations.localeOf(context);
    final dateFormat = DateFormat.yMMMMd(myLocale.languageCode);

    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).bottomAppBarColor,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(8),
              // ignore: prefer_const_literals_to_create_immutables
              boxShadow: [
                const BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      S.of(context).measures_filter,
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    TextFormField(
                      initialValue: widget.filter.query,
                      decoration: InputDecoration(
                        hintText: S.of(context).comment_contains,
                      ),
                      onSaved: (val) => setState(() {
                        debugPrint(val);
                        changedFilter =
                            changedFilter.copyWith(query: val ?? '');
                      }),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    DateTimeField(
                      format: dateFormat,
                      onSaved: (dt) {
                        setState(() {
                          changedFilter = changedFilter.copyWithNullable(
                            dateFrom: dt,
                            dateTo: changedFilter.dateTo,
                          );
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return S.of(context).must_not_be_empty;
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: '${S.of(context).from}:',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      initialValue: widget.filter.dateFrom,
                      onShowPicker: (context, currentValue) => showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    DateTimeField(
                      format: dateFormat,
                      onSaved: (dt) {
                        setState(() {
                          changedFilter = changedFilter.copyWithNullable(
                            dateTo: dt,
                            dateFrom: changedFilter.dateFrom,
                          );
                        });
                      },
                      decoration: InputDecoration(
                        labelText: '${S.of(context).to}:',
                        labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.secondary),
                      ),
                      initialValue: widget.filter.dateTo,
                      validator: (value) {
                        if (value == null) {
                          return S.of(context).must_not_be_empty;
                        }
                        return null;
                      },
                      onShowPicker: (context, currentValue) => showDatePicker(
                        context: context,
                        firstDate: DateTime(1900),
                        initialDate: currentValue ?? DateTime.now(),
                        lastDate: DateTime(2100),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          RawMaterialButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _formKey.currentState?.save();
                                Navigator.pop(context, changedFilter);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(S.of(context).save),
                            ),
                          ),
                          const SizedBox(
                            width: 16,
                          ),
                          RawMaterialButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(S.of(context).cancel),
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
