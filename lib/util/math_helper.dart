extension Trancator on int {
  int truncateToHundreds() => (this ~/ 10) * 10;
}
