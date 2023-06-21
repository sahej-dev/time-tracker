import 'dart:io';

import 'package:flutter/foundation.dart';

class Config {
  static String devBaseUrl() {
    if (!kIsWeb && Platform.isAndroid) return "http://10.0.2.2:2000";

    return "http://localhost:2000";
  }

  static const String prodBaseUrl = "https://time.joytracker.xyz";
}
