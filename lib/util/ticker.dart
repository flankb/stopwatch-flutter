import 'dart:async';

class Ticker {
  Stream<int> tick({required int ticks}) =>
      Stream.periodic(const Duration(milliseconds: 33), (x) => ticks + x)
          .take(ticks);
}

class Ticker2 {
  Stream<int> tick({required int ticks}) =>
      Stream.periodic(const Duration(milliseconds: 33), (x) => x).take(ticks);
}

class Ticker3 {
  Stream<int> tick() =>
      Stream.periodic(const Duration(milliseconds: 33), (x) => x);
}

class Ticker4 {
  Timer tick() => Timer.periodic(const Duration(milliseconds: 33), (timer) {});
}
