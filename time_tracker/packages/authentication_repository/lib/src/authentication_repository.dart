import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum AuthenticationStatus { unknown, authenticated, unauthenticated }

class AuthenticationRepository {
  final String apiUrl;
  final _controller = StreamController<AuthenticationStatus>.broadcast();
  late final StreamSubscription<AuthenticationStatus>
      _internalStatusSubscription;
  final FlutterSecureStorage secureStorage;

  AuthenticationRepository({
    required this.apiUrl,
    required this.secureStorage,
  }) {
    print("API URL: ${apiUrl}");

    _internalStatusSubscription = status.listen((event) async {
      switch (event) {
        case AuthenticationStatus.authenticated:
          if (socket != null) return;

          String? token = await readToken();
          if (token == null) return;

          socket = IO.io(
            apiUrl,
            IO.OptionBuilder()
                .setTransports(['websocket']) // for Flutter or Dart VM
                .setAuth({"token": token}).build(),
          );
          break;

        default:
          socket?.disconnect();
          socket = null;
      }
    });
  }

  Dio? __dio;
  IO.Socket? socket;

  Future<Dio> get _dio async {
    if (__dio != null) {
      return __dio!;
    }

    __dio = Dio(BaseOptions(
      baseUrl: "${apiUrl}/api/v1/auth",
      sendTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    return __dio!;
  }

  Stream<AuthenticationStatus> get status async* {
    yield AuthenticationStatus.authenticated;
    yield* _controller.stream;
  }

  Future<void> storeToken(String token) async {
    return secureStorage.write(key: 'token', value: token);
  }

  Future<String?> readToken() async {
    return await secureStorage.read(key: 'token');
  }

  Future<void> logIn({
    required String email,
    required String password,
  }) async {
    final dio = await _dio;

    try {
      final Response response = await dio.post(
        "/signin",
        data: {
          "email": email,
          "password": password,
        },
      );

      final String token = response.data["token"];

      await storeToken(token);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      print("in login catch");
      print(e);
      _controller.add(AuthenticationStatus.unauthenticated);
      throw e;
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    final dio = await _dio;

    final List<String> names = fullName.split(' ');
    final String firstName = names[0];

    late final String? lastName;
    if (names.length > 1) {
      lastName = names.skip(1).join(' ');
    } else {
      lastName = null;
    }

    try {
      final Response response = await dio.post(
        "/signup",
        data: {
          "email": email,
          "password": password,
          "first_name": firstName,
          "last_name": lastName,
          "phone": phone,
        },
      );

      final String token = response.data["token"];
      await storeToken(token);

      _controller.add(AuthenticationStatus.authenticated);
    } catch (e) {
      _controller.add(AuthenticationStatus.unauthenticated);
      throw e;
    }
  }

  void logOut() async {
    await secureStorage.delete(key: "token");
    _controller.add(AuthenticationStatus.unauthenticated);
  }

  void dispose() {
    _internalStatusSubscription.cancel();
    _controller.close();
  }
}
