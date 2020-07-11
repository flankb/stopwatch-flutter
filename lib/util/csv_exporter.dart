import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/resources/stopwatch_db_repository.dart';

class CsvExporter {
  final StopwatchRepository stopwatchRepository;

  CsvExporter(this.stopwatchRepository);

  Future<String> convertToCsv(List<MeasureViewModel> measures) async {
    // TODO Для экспорта файла плагины:
    // https://pub.dev/packages/esys_flutter_share
    // https://pub.dev/packages/share#-example-tab-

    StringBuffer csvBody = StringBuffer();
    csvBody.writeln("Дата измерения\tОбщее время\tКомментарий\tНомер круга\tВремя круга\tРазница с пред. кругом\tКомментарий круга\t");

    await Future.forEach(measures, ((element) async {
      debugPrint("Exported to csv $element");

      final elapsedTime = element.elapsedTime();

      String row = "${element.dateStarted}\t${elapsedTime[0]},${elapsedTime[1]}\t${element.comment}\t\t\t\t";
      csvBody.writeln(row);

      // Загрузить круги для текущего измерения
      final laps = (await stopwatchRepository.getLapsByMeasureAsync(element.id)).map((l) => LapViewModel.fromEntity(l));

      //debugPrint("lap len: ${laps.length}");

      laps.forEach((lap) {
        String lapRow = "\t\t\t${lap.order}\t${lap.overallTime()}\t${lap.differenceTime()}\t${lap.comment ?? ""}";

        //debugPrint("lap: ${lapRow}");

        csvBody.writeln(lapRow);
      });
    }));

    //debugPrint(csvBody.toString());

    //String csv = const ListToCsvConverter().convert([]);
    final csv = csvBody.toString();

    return csv;
  }

  Future shareFile(String csv) async {
    //final ByteData bytes = await rootBundle.load('assets/image1.png');
    List<int> bytes2 = utf8.encode(csv);
    await Share.file('Измерения', 'Measures_${DateTime.now()}.csv', bytes2, 'text/csv' /*, text: 'My optional text.'*/);
  }
}

/*
 private IAsyncOperation<string> BuildCsv(List<MeasureViewModel> selectedItems)
        {
            var task = Task.Run(() =>
            {
                var prebuiltQuery = InApp.Instance.DbContext.Measures
                    .AsQueryable();

                //Если пользователь выбрал данные, делаем Join
                if (selectedItems != null && selectedItems.Any())
                    prebuiltQuery = from am in prebuiltQuery
                        join lm in selectedItems on am.Id equals lm.Measure.Id
                        select am;

                var allMeasures = prebuiltQuery.OrderByDescending(m => m.MeasureDate);

                StringBuilder csvBody = new StringBuilder();
                csvBody.AppendLine($"{AppResources.CsvDateOfMeasure}\t{AppResources.CsvElapsedTime}\t{AppResources.CsvComment}\t{AppResources.CsvNumberOfLap}\t{AppResources.CsvLapElapsedTime}\t{AppResources.CsvDiffereceLap}\t{AppResources.CsvCommentLap}\t");

                //Материализуем круги
                //var materializedLaps = InApp.Instance.DbContext.Laps.ToList()
                //    .GroupBy(l => l.Measure.Id)
                //    .ToDictionary(g => g.Key, g => g.OrderBy(l => l.Order).ToList());

                foreach (var measure in allMeasures)
                {
                    string row = $"{measure.MeasureDate.ToString("G")}\t{measure.ElapsedTime.ToShortTimeString()}\t{measure.Comment}\t\t\t\t";
                    csvBody.AppendLine(row);

                    var laps1 = InApp.Instance.DbContext.Laps.Where(l => l.MeasureId == measure.Id);

                    if (laps1 != null && laps1.Any())
                    {
                        //var laps = materializedLaps[measure.Id];

                        foreach (var lapDb in laps1.OrderBy(l => l.Order))
                        {
                            string lapRow = $"\t\t\t{lapDb.Order}\t{lapDb.Overall.ToShortTimeString()}\t{lapDb.Difference.ToShortTimeString()}\t{lapDb.Comment}";
                            csvBody.AppendLine(lapRow);
                        }
                    }
                }

                return csvBody.ToString();
            });

            return task.AsAsyncOperation();
        }
 */
