extension Trancator on int {
  int truncateToHundreds() {
    return (this ~/10) * 10;
  }
}
