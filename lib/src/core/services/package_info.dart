import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoService {
  static String packageVesion = '';

  static Future<void> packageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    packageVesion = packageInfo.version;
  }
}
