import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2000/api/v1/auth"));

  final _controller = StreamController<AuthenticationStatus>();
  final _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    try {
      print("email pass is: ${email} ${password}");
      final Response response = await _dio.post(
        "/signin",
        data: {
          "email": email,
          "password": password,
        },
      );
      final String token = response.data["token"];

      await _secureStorage.write(key: 'token', value: token);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      print("in login catch");
      print(e);
      _controller.add(AuthenticationStatus.unauthenticated);
    }
  }

  void logOut() async {
    await _secureStorage.delete(key: "token");
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() => _controller.close();
}
