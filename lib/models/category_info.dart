import 'package:flutter/cupertino.dart';
import 'package:learnwords/model/database_models.dart';
import 'package:learnwords/models/persistent_type.dart';

class CategoryInfo {
  final String name;
  final PersistentType persistentType;
  final String translation;
  final String locale;

  CategoryInfo({
    @required this.name,
    @required this.persistentType,
    this.translation = "",
    this.locale = 'ru'
  });

  /*CategoryInfo.fromDatabase(Category model) :
      name = model.name,
      persistentType = PersistentType.Database,
      translation = model.translation,
      locale = 'ru';*/

  CategoryInfo.empty() :
      name = "",
      persistentType = PersistentType.File,
      translation = "",
      locale = 'ru';

  CategoryInfo.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        persistentType =  PersistentType.values.firstWhere((e) => e.toString() == json['persistentType']),
        translation = json['translation'],
        locale = json['locale'];

  Map<String, dynamic> toJson() =>
      {
        'name': name,
        'persistentType': persistentType.toString(),
        'translation' : translation,
        'locale' : locale
      };
}