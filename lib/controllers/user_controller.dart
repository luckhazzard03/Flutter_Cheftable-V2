// lib/controllers/user_controller.dart
import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UserController with ChangeNotifier {
  final UserService userService;
  List<User> users = [];
  bool isLoading = false;
  String? errorMessage;

  UserController(this.userService);

  Future<void> loadUsers() async {
    try {
      final fetchedUsers = await userService.fetchUsers();
      users = fetchedUsers;
    } catch (e) {
      // Manejar errores
      print('Error loading users: $e');
    }
  }

  Future<List<User>> getUsers() async {
    // Asegúrate de cargar los usuarios antes de devolverlos
    if (users.isEmpty) {
      await loadUsers();
    }
    return users;
  }

  Future<void> addUser(User newUser) async {
    try {
      await userService
          .createUser(newUser); // Llamada al servicio para agregar usuario
    } catch (e) {
      throw Exception('Error al agregar usuario: $e');
    }
  }

  Future<void> updateUser(User updatedUser) async {
    try {
      await userService.updateUser(
          updatedUser); // Llamada al servicio para actualizar usuario
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  Future<void> deleteUser(int userId) async {
    try {
      await userService.deleteUser(userId); // Llama al servicio para eliminar
      // Actualiza el estado después de la eliminación si es necesario
      users.removeWhere((user) => user.idUsuario == userId);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
