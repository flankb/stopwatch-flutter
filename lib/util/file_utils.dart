import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<String> readFileFromAsset(String fullPath) async =>
    rootBundle.loadString(fullPath);

Future<String> _getLocalPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> getLocalFile(String fileName) async {
  final path = await _getLocalPath();
  return File('$path/$fileName');
}

Future<String> readFile(String fileName) async {
  try {
    final file = await getLocalFile(fileName);

    // Read the file.
    final contents = await file.readAsString();

    return contents;
  } on Exception {
    // If encountering an error, return 0.
    return '';
  }
}
