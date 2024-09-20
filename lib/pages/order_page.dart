//import 'dart:nativewrappers/_internal/vm/lib/ffi_allocation_patch.dart';

import 'package:flutter/material.dart';
import '../controllers/order_controller.dart';
import 'package:flutter_application_5/pages/user_management_page.dart';
import 'package:flutter_application_5/services/order_service.dart';
//import 'dart:convert';
import 'package:intl/intl.dart';
import '../models/order.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  _OrderManagementPageState createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  late final OrderService orderService;
  late final OrderController orderController;

  List<Order> _orders = [];
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _totalPriceController = TextEditingController();
  final _quantityController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedQuantity;
  String? _selectedMenuType;
  int? _selectedUserId;
  int? _selectedTableId;
  Order? _editingOrder;
  bool _isFormVisible = false; // Controla la visibilidad del formulario

  final List<Map<String, dynamic>> _tableOptions = List.generate(
    10,
    (index) => {'label': 'Mesa ${index + 1}', 'value': index + 1},
  );

  final List<Map<String, dynamic>> _userOptions = List.generate(
    10,
    (index) => {'label': 'Mesero ${index + 1}', 'value': index + 1},
  );

  final List<String> _menuTypes = ['Corriente', 'Ejecutivo', 'Especial'];
  final List<String> _quantities =
      List.generate(20, (index) => (index + 1).toString());

  final _dateFormat = DateFormat('yyyy-MM-dd');
  final _timeFormat = DateFormat('HH:mm');

//Validacion de campos formulario Fecha
  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Fecha es requerido';
    }
    return null;
  }

//Validacion de campos formulario Hora
  String? _validateTime(String? value) {
    if (value == null || value.isEmpty) {
      return 'Hora es requerido';
    }
    return null;
  }

//Validacion de campos formulario Total Platos
  String? _validatePlatos(String? value) {
    if (value == null || value.isEmpty) {
      return 'Numero de platos es requerido';
    }
    return null;
  }

//Validacion de campos formulario Total Precio
  String? _validateTotalPrice(String? value) {
    if (value == null || value.isEmpty) {
      return 'El precio es requerido';
    }
    return null;
  }

//Validacion de campos formulario Tipo menu
  String? _validateMenuType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Menu es requerido';
    }
    return null;
  }

//Validacion de campos formulario Tipo Menú
  String? _validateTipoMenu(String? value) {
    if (value == null || value.isEmpty) {
      return 'El campo Menú es requerido';
    }
    return null;
  }

//Validacion de campos formulario Usuario Mesero
  String? _validateUsuarioId(int? value) {
    if (value == null || value <= 0) {
      return 'Mesero id es requerido';
    }
    return null;
  }

//Validacion de campos formulario Mesa Id
  String? _validateTableId(int? value) {
    if (value == null || value <= 0) {
      return 'La Mesa es requerido';
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    // Inicializar OrderService
    orderService = OrderService();
    // Inicializar OrderController con OrderService
    orderController = OrderController(orderService);
    _loadOrders(); // Cargar las órdenes al iniciar
  }

  void _clearForm() {
    _dateController.clear();
    _timeController.clear();
    _totalPriceController.clear();
    _quantityController.clear();
    setState(() {
      _editingOrder = null;
      _selectedMenuType = null;
      _selectedUserId = null;
      _selectedTableId = null;
      _isFormVisible = false;
    });
  }

  // Función modificada para usar el controlador
  void _addOrder() async {
    if (_formKey.currentState!.validate() && _selectedUserId != null) {
      final date = _dateController.text;
      final time = _timeController.text;
      final quantity = int.tryParse(_selectedQuantity ?? '') ?? 0;
      final pricePerItem = double.tryParse(_totalPriceController.text) ?? 0.0;
      final totalPrice = quantity * pricePerItem;
      final menuType = _selectedMenuType ?? '';
      final userId = _selectedUserId ?? 0;
      final tableId = _selectedTableId ?? 0;

      final newOrder = Order(
        id: _editingOrder?.id ?? 0,
        fecha: date,
        hora: time,
        totalPlatos: quantity,
        precioTotal: totalPrice,
        tipoMenu: menuType,
        idUsuarioFk: userId,
        idMesaFk: tableId,
        createAt: DateTime.now().toIso8601String(),
        updateAt: DateTime.now().toIso8601String(),
      );

      try {
        if (_editingOrder != null) {
          await orderController.updateOrder(newOrder);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comanda actualizado.')),
          );
        } else {
          await orderController.addOrder(newOrder);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Comanda creada con éxito'),
            ),
          );
        }

        // Recargar la lista de Comandas después de la operación
        _loadOrders(); //  método  correctamente implementado
        //_clearForm();
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Completa todos los campos correctamente.')),
      );
    }
  }

  //Define una función llamada _editOrder que toma un objeto Order como parámetro.
  void _editOrder(Order order) {
    setState(() {
      _editingOrder = order;
      _dateController.text = order.fecha ?? '';
      _timeController.text = order.hora ?? '';
      _selectedQuantity = order.totalPlatos.toString();

      if (order.totalPlatos != 0) {
        _totalPriceController.text =
            (order.precioTotal! / order.totalPlatos!).toStringAsFixed(2);
      } else {
        _totalPriceController.text = '0.00';
      }

      _selectedMenuType = order.tipoMenu;
      _selectedUserId = order.idUsuarioFk;
      _selectedTableId = order.idMesaFk;

      // Asegúrate de que la forma del formulario sea visible
      _isFormVisible = true;
    });
  }

  void _deleteOrder(Order order) async {
    await orderController
        .deleteOrder(order.id!); // Usa order.id! para obtener el ID no nulo
    setState(() {
      _orders.remove(order);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Comanda eliminada con éxito'),
        duration: Duration(seconds: 3), // Duración del mensaje en pantalla
      ),
    );
  }

  // Cargar Comanadas desde la API
  void _loadOrders() async {
    try {
      final orders = await orderController.getOrders();
      setState(() {
        _orders = orders;
      });
      print('Comandas cargadas: ${_orders.length}');
      _orders.forEach((order) => print('Comanda: ${order.id}'));
    } catch (error) {
      print('Error al cargar la Comanda: $error');
    }
  }

  void _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (route) => false,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _dateFormat.format(picked);
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = picked.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Comandas'),
        backgroundColor: const Color.fromARGB(255, 20, 42, 59),
        foregroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(213, 108, 238, 2),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(0),
                ),
                image: DecorationImage(
                  image: AssetImage('assets/img/platos.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 20, 42, 59),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/img/logo2.png',
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Bienvenido!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.person, color: Colors.green),
                    title: Text('Gestión de Usuarios'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserManagementPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_isFormVisible)
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFormField(
                              controller: _dateController,
                              decoration: const InputDecoration(
                                labelText: 'Fecha',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              validator: _validateDate,
                              onTap: () => _selectDate(context),
                              readOnly: true,
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _timeController,
                              decoration: const InputDecoration(
                                labelText: 'Hora',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              validator: _validateTime,
                              onTap: () => _selectTime(context),
                              readOnly: true,
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              validator: _validatePlatos,
                              value: _selectedQuantity,
                              items: _quantities.map((quantity) {
                                return DropdownMenuItem<String>(
                                  value: quantity,
                                  child: Text(quantity),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Cantidad de platos',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedQuantity = value;
                                });
                              },
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              validator: _validateTipoMenu,
                              value: _selectedMenuType,
                              items: _menuTypes.map((menuType) {
                                return DropdownMenuItem<String>(
                                  value: menuType,
                                  child: Text(menuType),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'Tipo de menú',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedMenuType = value;
                                });
                              },
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              validator: _validateTableId,
                              value: _selectedTableId,
                              items: _tableOptions.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option['value'] as int,
                                  child: Text(option['label']),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'ID Mesa',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTableId = value;
                                });
                              },
                            ),
                            SizedBox(height: 8),
                            DropdownButtonFormField<int>(
                              validator: _validateUsuarioId,
                              value: _selectedUserId,
                              items: _userOptions.map((option) {
                                return DropdownMenuItem<int>(
                                  value: option['value'] as int,
                                  child: Text(option['label']),
                                );
                              }).toList(),
                              decoration: const InputDecoration(
                                labelText: 'ID Usuario',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _selectedUserId = value;
                                });
                              },
                            ),
                            SizedBox(height: 8),
                            TextFormField(
                              controller: _totalPriceController,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              decoration: const InputDecoration(
                                labelText: 'Precio unitario',
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 12.0),
                              ),
                              validator: _validateTotalPrice,
                            ),
                            SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: _addOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(214, 99, 219, 0),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 30.0, vertical: 12.0),
                              ),
                              child: Text(_editingOrder != null
                                  ? 'Actualizar Comanda'
                                  : 'Añadir Comanda'),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ),
                  ),
                SizedBox(height: 24),
                Text(
                  'Comandas Creadas',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 2,
                  color: Colors.green,
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                ),
                SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final order = _orders[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 5,
                        child: ListTile(
                          title: Text(
                              'COMANDA ${index + 1}: \nFecha: ${order.fecha}, Hora: ${order.hora}'),
                          subtitle: Text(
                            'Cantidad: ${order.totalPlatos}, \n'
                            'Precio: \$${(order.precioTotal ?? 0.0).toStringAsFixed(2)}, \n'
                            'Menú: ${order.tipoMenu}, \n'
                            'Usuario: ${order.idUsuarioFk}, \n'
                            'Mesa: ${order.idMesaFk}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.green),
                                onPressed: () => _editOrder(order),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.green),
                                onPressed: () => _deleteOrder(order),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 25.0,
            right: 20.0,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _isFormVisible = !_isFormVisible;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(214, 99, 219, 0),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
              ),
              child: Text(_isFormVisible ? 'DIS' : 'ADD'),
            ),
          ),
        ],
      ),
    );
  }
}
