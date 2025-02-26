import 'package:hive_flutter/hive_flutter.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox('hiveBox');
  }
}
