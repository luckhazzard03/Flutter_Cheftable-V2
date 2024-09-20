// lib/controllers/user_controller.dart
import 'package:flutter/material.dart';
import '../services/order_service.dart';
import '../models/order.dart';

class OrderController with ChangeNotifier {
  final OrderService orderService;
  List<Order> orders = [];
  bool isLoading = false;
  String? errorMessage;

  OrderController(this.orderService);

  Future<void> loadOrders() async {
    try {
      final fetchedOrders = await orderService.fetchOrders();
      orders = fetchedOrders;
    } catch (e) {
      // Manejar errores
      print('Error loading users: $e');
    }
  }

  Future<List<Order>> getOrders() async {
    if (orders.isEmpty) {
      await loadOrders();
    }
    return orders;
  }

  Future<void> addOrder(Order newOrder) async {
    try {
      await orderService
          .createOrder(newOrder); // Llamada al servicio para agregar Comanda
    } catch (e) {
      throw Exception('Error al agregar usuario: $e');
    }
  }

  Future<void> updateOrder(Order updatedOrder) async {
    try {
      await orderService.updateOrder(
          updatedOrder); // Llamada al servicio para actualizar usuario
    } catch (e) {
      throw Exception('Error al actualizar usuario: $e');
    }
  }

  Future<void> deleteOrder(int orderId) async {
    try {
      await orderService.deleteOrder(orderId);
      orders.removeWhere((order) => order.id == orderId);
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    }
  }
}
