import 'dart:async';

class Ticker {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(milliseconds: 33), (x) => ticks + x)
        .take(ticks); // TODO Разобраться как работает!!!
  }
}

class Ticker2 {
  Stream<int> tick({required int ticks}) {
    return Stream.periodic(Duration(milliseconds: 33), (x) => x).take(ticks);
  }
}

class Ticker3 {
  Stream<int> tick() {
    return Stream.periodic(Duration(milliseconds: 33), (x) => x);
  }
}

class Ticker4 {
  Timer tick() {
    return Timer.periodic(Duration(milliseconds: 33), (timer) {});
    //return Timer.periodic(Duration(milliseconds: 33), (x) => x); //TODO можно Timer.periodic
  }
}

/*
// NOTE: This implementation is FLAWED!
// It starts before it has subscribers, and it doesn't implement pause.
Stream<int> timedCounter(Duration interval, [int maxCount]) {
  var controller = StreamController<int>();
  int counter = 0;
  void tick(Timer timer) {
    counter++;
    controller.add(counter); // Ask stream to send counter values as event.
    if (maxCount != null && counter >= maxCount) {
      timer.cancel();
      controller.close(); // Ask stream to shut down and tell listeners.
    }
  }

  Timer.periodic(interval, tick); // BAD: Starts before it has subscribers.
  return controller.stream;
}
 */

/*
var counterStream = timedCounter(const Duration(seconds: 1), 15);
counterStream.listen(print); // Print an integer every second, 15 times.
 */