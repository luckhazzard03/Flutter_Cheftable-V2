import 'package:crypto/crypto.dart';
import 'dart:convert';

String hashPassword(String password) {
  final bytes = utf8.encode(password); // Convertir a bytes
  final digest = sha256.convert(bytes); // Crear hash con SHA-256
  return digest.toString();
}
