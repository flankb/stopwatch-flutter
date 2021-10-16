/// Класс для хранения всяких общих ресурсов приложения
class Application {
  Application._privateCons();

  static Application? _instance;

  Application get current {
    if (_instance == null) {
      _instance = Application._privateCons();
    }

    return _instance!;
  }
}
