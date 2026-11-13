import 'package:get/get.dart';

import '../app/app_socket_config.dart';

Future<T> runSocketMutation<T>(Future<T> Function() action) =>
    Get.find<AppSocketConfig>().mutationOperation.run(action);
