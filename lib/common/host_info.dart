import 'dart:convert';

class HostInfo {
  String _platform;
  String _appVersion;
  String _osVersion;
  HostInfo(this._platform, this._appVersion, this._osVersion);

  String toJson() {
    Map<String, String> map = new Map<String, String>.from({
      "platform": _platform,
      "appVersion": _appVersion,
      "OsVersion": _osVersion,
    });
    return jsonEncode(map);
  }
}
