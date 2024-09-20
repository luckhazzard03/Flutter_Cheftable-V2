import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';

//import '../services/auth_service.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Instancia del controlador
    LoginController controller = Get.put(LoginController());

    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/rest.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                child: CircleAvatar(
                  radius: 100,
                  backgroundColor: const Color.fromARGB(206, 179, 255, 0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/img/logo.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InputBox(
                isSecured: false,
                hint: 'Username',
                txtController: controller.email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InputBox(
                isSecured: true,
                hint: 'Password',
                txtController: controller.password,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () async {
                  print('Login credentials ========');
                  // Se crea un nuevo Usuario y validación
                  await controller.submit();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color.fromARGB(206, 179, 255, 0), // Color de fondo
                  foregroundColor:
                      const Color.fromARGB(255, 34, 57, 87), // Color del texto
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(30.0), // Bordes redondeados
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 12.0), // Padding
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Modificación del widget InputBox para aceptar decoration
Widget InputBox({
  required String hint,
  required TextEditingController txtController,
  required bool isSecured,
  required InputDecoration decoration, // Añadir parámetro decoration
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 15),
    child: TextField(
      obscureText: isSecured,
      controller: txtController,
      decoration: decoration, // Usar la decoración pasada como parámetro
    ),
  );
}
