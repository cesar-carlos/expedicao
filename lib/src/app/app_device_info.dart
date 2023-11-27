import 'package:device_info_plus/device_info_plus.dart';

class AppDeviceInfo {
  static Future<String> getDeviceName() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final deviceInfo = await deviceInfoPlugin.deviceInfo;
    final allInfo = deviceInfo.data;
    return allInfo['name'] ?? 'computerName' ?? '';
  }
}
