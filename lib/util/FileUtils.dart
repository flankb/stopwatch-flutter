
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class FileUtils {
  static Future<String> readFileFromAsset(String fullPath) async {
    return await rootBundle.loadString(fullPath);
  }

  static Future<String> _getLocalPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getLocalFile(String fileName) async {
    final path = await _getLocalPath();
    return File('$path/$fileName');
  }

  Future<String> readFile(String fileName) async {
    try {
      final file = await getLocalFile(fileName);

      // Read the file.
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If encountering an error, return 0.
      return "";
    }
  }
}