
class Ticker {
  Stream<int> tick({int ticks}) {
    return Stream.periodic(Duration(milliseconds: 33), (x) => ticks + x).take(ticks); // TODO Разобраться как работает!!!
  }
}