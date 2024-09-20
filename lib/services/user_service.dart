// lib/services/user_service.dart
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../utils/constans.dart';

class UserService {
  final Dio _dio = Dio(); // Inicializa Dio para las solicitudes HTTP

  // URL base de la API Fake
  //final String baseUrlUsuarios =
  //    'https://66eacc1d55ad32cda47a70c7.mockapi.io/api/v2/usuarios';

  // Método para obtener usuarios
  Future<List<User>> fetchUsers() async {
    try {
      final response = await _dio.get(baseUrlUsuarios);
      final List<dynamic> data = response.data;
      return data.map((userJson) => User.fromJson(userJson)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Método para crear un usuario
  Future<void> createUser(User user) async {
    try {
      final response = await _dio.post(baseUrlUsuarios, data: user.toJson());
      print('Usuario creado con éxito: ${response.data}');
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Método para actualizar un usuario existente
  Future<void> updateUser(User user) async {
    try {
      final response = await _dio.put('$baseUrlUsuarios/${user.idUsuario}',
          data: user.toJson());
      print('Usuario actualizado con éxito: ${response.data}');
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Método para eliminar un usuario
  Future<void> deleteUser(int id) async {
    try {
      final response = await _dio.delete('$baseUrlUsuarios/$id');
      print('Usuario eliminado con éxito: ${response.data}');
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }
}
