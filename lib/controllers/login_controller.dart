import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../models/userLogin.dart';
import '../routes.dart'; // Importa las rutas
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constans.dart';

class LoginController extends GetxController {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String _message = "";
  final Dio _dio = Dio();

  Future<void> submit() async {
    User user = User(email: email.text, password: password.text.trim());
    bool validateResult = ValidateUser(user);

    if (validateResult) {
      bool serverResponse = await authenticateUser(user);
      if (serverResponse) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('is_logged_in', true);

        // Navegar a UserManagementPage y reemplazar toda la pila de navegación
        Get.offAllNamed(AppRoutes.userManagement);
      } else {
        await showMessage(
            context: Get.context!,
            title: 'Error',
            message: 'Usuario o contraseña incorrecta');
      }
    } else {
      await showMessage(
          context: Get.context!, title: 'Error', message: _message);
    }
  }

  bool ValidateUser(User user) {
    if (user.email == null || user.password == null) {
      _message = 'Nombre de usuario o contraseña vacíos';
      return false;
    }
    if (user.email.toString().isEmpty) {
      _message = 'El nombre de usuario no puede estar vacío';
      return false;
    }
    if (user.password.toString().isEmpty) {
      _message = 'La contraseña no puede estar vacía';
      return false;
    }
    return true;
  }

  Future<bool> authenticateUser(User user) async {
    Dio dio = Dio(BaseOptions(connectTimeout: const Duration(seconds: 5)));

    try {
      Map<String, dynamic> requestData = {
        'email': user.email,
        'password': user.password,
      };

      final response = await dio.post(baseUrlLogin, data: requestData);

      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
  }) async {
    return showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            CupertinoDialogAction(
              child: const Text('Ok'),
              onPressed: () {
                Get.back();
              },
            ),
          ],
        );
      },
    );
  }
}
