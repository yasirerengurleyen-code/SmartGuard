/// Placeholder service — RTC senkronizasyonu sonraki aşamada.
class RtcService {
  Future<DateTime> readDeviceTime() async => DateTime.now();

  Future<void> syncTime(DateTime time) async {
    // TODO: RTC senkronizasyonu
  }
}
