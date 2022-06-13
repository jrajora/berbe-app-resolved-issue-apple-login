import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfo {
  DeviceInfo._();

  static DeviceInfo get instance => DeviceInfo._();

  Future<Map<String, dynamic>> getDeviceInfo() async {
    var params = <String, dynamic>{};
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      params["device_os"] = iosDeviceInfo.utsname.release;
      params["device_name"] = iosDeviceInfo.name;
      params["device_type"] = "ios";
      params["os_version"] = iosDeviceInfo.systemVersion;
      params["other_data"] = json.encode(iosDeviceInfo.toMap());
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
      params["device_os"] = androidDeviceInfo.version.release;
      params["device_name"] =
          "${androidDeviceInfo.brand} ${androidDeviceInfo.device} ";
      params["device_type"] = "android";
      params["os_version"] = androidDeviceInfo.version.sdkInt.toString();
      params["other_data"] = json.encode(androidDeviceInfo.toMap());
    }

    return params;
  }
}
