import 'package:stopwatch/models/stopwatch_proxy_models.dart';
import 'package:stopwatch/models/stopwatch_status.dart';

class FakeDataFabric {
  static List<LapViewModel> mainPageLaps() {
    final list = [
      LapViewModel(id: 0, comment: "", measureId: 0, order: 1, difference: 5000, overall: 5000),
      LapViewModel(id: 1, comment: "", measureId: 0, order: 2, difference: 2000, overall: 7000),
      LapViewModel(id: 2, comment: "", measureId: 0, order: 3, difference: 3000, overall: 10000)
    ];

    return list;
  }

  static List<MeasureViewModel> measuresHistory() {
    final list = [
      MeasureViewModel(id: 2, comment: "Пробежка", elapsed: 10000, laps: null, status: StopwatchStatus.Finished, dateStarted: DateTime.now()),
      MeasureViewModel(id: 3, comment: "Стометровка", elapsed: 25000, laps: null, status: StopwatchStatus.Finished, dateStarted: DateTime.now())
    ];

    return list;
  }

  static List<MeasureSessionViewModel> sessionsHistory() {
    final list = [
      MeasureSessionViewModel(id: 1, measureId: 2, started: 2000, finished: 7000),
      MeasureSessionViewModel(id: 2, measureId: 3, started: 7500, finished: 9800)
    ];

    return list;
  }

  static List<LapViewModel> lapsHistory() {
    final list = [
      LapViewModel(id: 0, comment: "Иванов А. И.", measureId: 1, order: 1, difference: 5000, overall: 5000),
      LapViewModel(id: 1, comment: "Владимиров П.К.", measureId: 1, order: 2, difference: 2000, overall: 7000),
      LapViewModel(id: 2, comment: "Петров Р.О.", measureId: 1, order: 2, difference: 3000, overall: 10000)
    ];

    return list;
  }
}
