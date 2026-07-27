/// Placeholder service — Bluetooth entegrasyonu sonraki aşamada.
class BluetoothService {
  Future<bool> isAvailable() async => false;

  Future<void> scan() async {
    // TODO: Bluetooth tarama
  }

  Future<void> connect(String deviceId) async {
    // TODO: Cihaz bağlantısı
  }

  Future<void> disconnect() async {
    // TODO: Bağlantıyı kes
  }
}
