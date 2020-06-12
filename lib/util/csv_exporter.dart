
import 'package:csv/csv.dart';
import 'package:learnwords/models/stopwatch_proxy_models.dart';

class CsvExporter{
  static String convertToCsv(List<MeasureViewModel> measures) {
    StringBuffer csvBody = StringBuffer();
    csvBody.writeln("Дата измерения\tОбщее время\tКомментарий\tНомер круга\tВремя круга\tРазница с пред. кругом\tКомментарий круга\t");

    measures.forEach((element) {
      final elapsedTime = element.elapsedTime();

      String row = "${element.dateCreated}\t${elapsedTime[0]},${elapsedTime[1]}\t${element.comment}\t\t\t\t";
      csvBody.writeln(row);

      element.laps.forEach((lap) {
        String lapRow = "\t\t\t${lap.order}\t${lap.overallTime()}\t${lap.differenceTime()}\t${lap.comment}";
        csvBody.writeln(lapRow);
      });
    });

    //String csv = const ListToCsvConverter().convert([]);
    final csv = csvBody.toString();

    return csv;
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