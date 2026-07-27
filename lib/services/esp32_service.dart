/// Placeholder service — ESP32 iletişimi sonraki aşamada.
class Esp32Service {
  Future<bool> ping() async => false;

  Future<void> armSystem() async {
    // TODO: Alarmı kur
  }

  Future<void> disarmSystem() async {
    // TODO: Alarmı kapat
  }

  Future<void> setMode(String mode) async {
    // TODO: Mod gönder
  }
}
