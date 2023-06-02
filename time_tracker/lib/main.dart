import 'package:flutter/material.dart';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app.dart';

void main() {
  const FlutterSecureStorage secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  runApp(const App(
    secureStorage: secureStorage,
  ));
}
