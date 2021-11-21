import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:stopwatch/generated/l10n.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';

class MeasuresExporter {
  final StopwatchRepository stopwatchRepository;
  final _formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
  MeasuresExporter(this.stopwatchRepository);
  int lastLapsCount = 0;

  Future<String> convertToPlain(List<MeasureViewModel> measures) async {
    final plainBody = StringBuffer();
    // csvBody.writeln("Дата измерения\tОбщее время\tКомментарий\tНомер круга\tВремя круга\tРазница с пред. кругом\tКомментарий круга\t");

    await Future.forEach<MeasureViewModel>(measures, (element) async {
      final elapsedTime = element.elapsedTime();

      final formatted = _formatter.format(element.dateStarted!);

      final row =
          "${S.current.date_created}: $formatted\n${S.current.overall_time}: ${elapsedTime[0]},${elapsedTime[1]}${element.comment != null ? '\n${S.current.comment}: ' : ""}${element.comment ?? ""}";
      plainBody.writeln(row);

      final laps =
          (await stopwatchRepository.getLapsByMeasureAsync(element.id!))
              .map((l) => LapViewModel.fromEntity(l));

      if (laps.any((element) => true)) {
        plainBody.writeln('${S.current.laps}:');
      }

      laps.toList().asMap().forEach((indexLap, lap) {
        final lapRow =
            "${lap.order}) +${lap.differenceTime()},${lap.differenceMills()}\n${lap.overallTime()},${lap.overallMills()}${lap.comment != null ? '\n' : ""}${lap.comment ?? ""}";
        //debugPrint("lap: ${lapRow}");
        plainBody.writeln(lapRow);
      });

      plainBody.writeln('');

      lastLapsCount = laps.length;
    });

    var plain = plainBody.toString();

    // Обрезать 2 \n в конце
    if (plain.length > 2 /*&& lastLApsCount > 0*/) {
      plain = plain.substring(0, plain.length - 2);
    }

    return plain;
  }

  Future<String> convertToCsv(List<MeasureViewModel> measures) async {
    final csvBody = StringBuffer()
      ..writeln(
        '${S.current.date_created}\t${S.current.overall_time}\t${S.current.comment}\t${S.current.number_lap}\t${S.current.time_lap}\t${S.current.diff_prev_lap}\t${S.current.comment_of_lap}\t',
      );

    await Future.forEach<MeasureViewModel>(measures, (element) async {
      debugPrint('Exported to csv $element');
      final formatted = _formatter.format(element.dateStarted!);
      final elapsedTime = element.elapsedTime();

      final row =
          "$formatted\t${elapsedTime[0]},${elapsedTime[1]}\t${element.comment ?? ''}\t\t\t\t";
      csvBody.writeln(row);

      // Загрузить круги для текущего измерения
      final laps =
          (await stopwatchRepository.getLapsByMeasureAsync(element.id!))
              .map((l) => LapViewModel.fromEntity(l));

      //debugPrint("lap len: ${laps.length}");

      for (final lap in laps) {
        final lapRow =
            "\t\t\t${lap.order}\t${lap.overallTime()},${lap.overallMills()}\t${lap.differenceTime()},${lap.differenceMills()}\t${lap.comment ?? ''}";
        //debugPrint("lap: ${lapRow}");

        csvBody.writeln(lapRow);
      }
    });

    //debugPrint(csvBody.toString());

    //String csv = const ListToCsvConverter().convert([]);
    final csv = csvBody.toString();

    return csv;
  }

  Future shareFile(String csv) async {
    final bytes = utf8.encode(csv);

    final tempDirectory = await getTemporaryDirectory();

    final caption = 'Measures_${DateTime.now()}';

    final fileName = '$caption.csv';
    final path = '${tempDirectory.path}/$fileName';

    await File(path).writeAsBytes(bytes, mode: FileMode.write);

    await Share.shareFiles([path], text: caption, mimeTypes: ['text/csv']);
  }
}
