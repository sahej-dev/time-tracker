import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import 'models/models.dart';

class UserRepository {
  User? _user;

  final FlutterSecureStorage _secureStorage;
  final String apiUrl;

  UserRepository({
    required FlutterSecureStorage secureStorage,
    required this.apiUrl,
  }) : _secureStorage = secureStorage;

  Dio? __dio;

  Future<Dio> get _dio async {
    if (__dio != null) {
      return __dio!;
    }

    __dio = Dio(BaseOptions(
      baseUrl: "${apiUrl}/api/v1/users",
      sendTimeout: Duration(seconds: 5),
      connectTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ));

    return __dio!;
  }

  Future<User?> getUser() async {
    if (_user != null) return _user;

    final dio = await _dio;

    final String? token = await _secureStorage.read(key: "token");

    if (token == null) {
      throw Exception("jwt not present in secure storage");
    }

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    final String id = decodedToken["id"];

    final Response response = await dio.get("/${id}",
        options: Options(
          headers: {"authorization": "Bearer ${token}"},
        ));

    return User.fromJson(response.data);
  }
}
