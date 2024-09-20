// lib/services/order_service.dart

import 'package:dio/dio.dart';
import '../models/order.dart';
import '../utils/constans.dart';

class OrderService {
  final Dio _dio = Dio(); // Inicializa Dio para las solicitudes HTTP

  // URL base de la API Fake
  //final String baseUrlComandas =
   //   'https://66eacc1d55ad32cda47a70c7.mockapi.io/api/v2/comandas';

  // Método para obtener Comandas
  Future<List<Order>> fetchOrders() async {
    try {
      final response = await _dio.get(baseUrlComandas);
      final List<dynamic> data = response.data;
      return data.map((comandaJson) => Order.fromJson(comandaJson)).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Método para crear una Comanda
  Future<void> createOrder(Order order) async {
    try {
      final response = await _dio.post(baseUrlComandas, data: order.toJson());
      print('Usuario creado con éxito: ${response.data}');
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Método para actualizar una Comanda existente
  Future<void> updateOrder(Order order) async {
    try {
      final response =
          await _dio.put('$baseUrlComandas/${order.id}', data: order.toJson());
      print('Comanda actualizado con éxito: ${response.data}');
    } catch (e) {
      throw Exception('Error updating order: $e');
    }
  }

 // Método para eliminar una Comanda
  Future<void> deleteOrder(int id) async {
    try {
      final response = await _dio.delete('$baseUrlComandas/$id');
      print('Comanda eliminada con éxito: ${response.data}');      
    } catch (e) {
      throw Exception('Error deleting order: $e');
    }
  }
}
