import 'package:get/get.dart';

class AppPlatform {
  static const String android = 'android';
  static const String ios = 'ios';
  static const String web = 'web';
  static const String macos = 'macos';
  static const String windows = 'windows';
  static const String linux = 'linux';
  static const String fuchsia = 'fuchsia';

  static String get platform {
    if (GetPlatform.isAndroid) return android;
    if (GetPlatform.isIOS) return ios;
    if (GetPlatform.isWeb) return web;
    if (GetPlatform.isMacOS) return macos;
    if (GetPlatform.isWindows) return windows;
    if (GetPlatform.isLinux) return linux;
    if (GetPlatform.isFuchsia) return fuchsia;

    return '';
  }

  static bool get isDesktop {
    return GetPlatform.isDesktop && !GetPlatform.isWeb;
  }

  static bool get isMobile {
    return GetPlatform.isMobile && !GetPlatform.isWeb;
  }

  static bool get isWeb {
    return GetPlatform.isWeb;
  }
}
