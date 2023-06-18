import 'dart:io';

class Config {
  static String devBaseUrl() {
    if (Platform.isAndroid) return "http://10.0.2.2:2000";

    return "http://localhost:2000";
  }

  static const String prodBaseUrl = "https://time.joytracker.xyz";
}
