import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_repository/src/models/models.dart';

class UserRepository {
  User? _user;

  final _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  final _dio = Dio(BaseOptions(baseUrl: "http://10.0.2.2:2000/api/v1/users"));

  Future<User?> getUser() async {
    if (_user != null) return _user;

    final String? token = await _secureStorage.read(key: "token");

    if (token == null) {
      throw Exception("jwt not present in secure storage");
    }

    final Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

    final String id = decodedToken["id"];

    final Response response = await _dio.get("/${id}",
        options: Options(
          headers: {"authorization": "Bearer ${token}"},
        ));

    return User.fromJson(response.data);
  }
}
