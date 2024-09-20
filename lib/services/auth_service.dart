import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_application_5/utils/constans.dart'; // Asegúrate de que esta ruta sea correcta

class AuthException implements Exception {
  final String message;
  AuthException(this.message);
}

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: Duration(milliseconds: 10000),
      receiveTimeout: Duration(milliseconds: 30000),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        baseUrlLogin,
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        await _saveCredentials(email, hashPassword(password));
        return responseData;
      } else {
        throw AuthException(
            'Failed to login with status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('Error response data: ${e.response?.data}');
        print('Error response headers: ${e.response?.headers}');
        print('Error response status code: ${e.response?.statusCode}');
      } else {
        print('Error sending request: ${e.message}');
      }
      rethrow; // Vuelve a lanzar el error para manejarlo en otro lugar
    }
  }

  Future<void> _saveCredentials(String email, String hashedPassword) async {
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: hashedPassword);
  }

  Future<bool> validateCredentials(String email, String password) async {
    try {
      String? storedUsername = await _storage.read(key: 'email');
      String? storedPassword = await _storage.read(key: 'password');
      String hashedPassword = hashPassword(password);

      return email == storedUsername && hashedPassword == storedPassword;
    } catch (e) {
      print('Error validating credentials: $e');
      return false; // Considerar cómo manejar este caso
    }
  }

  Future<void> logout() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
  }

  Future<void> testApiConnection() async {
    try {
      final response = await _dio.get(baseUrlLogin);
      print('API is reachable: ${response.data}');
    } on DioException catch (e) {
      print('Error connecting to API: ${e.message}');
    }
  }
}
