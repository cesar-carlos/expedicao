import 'package:get/get.dart';

class AppDependency {
  static final AppDependency _instance = AppDependency._internal();
  AppDependency._internal();

  factory AppDependency.instance() {
    return _instance;
  }

  putDependency<T>(T dependency) {
    Get.put(dependency);
  }

  lazyPutDependency<T>(T dependency) {
    Get.put(dependency);
  }
}
