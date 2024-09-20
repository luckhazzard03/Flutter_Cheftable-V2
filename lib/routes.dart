import 'package:get/get.dart';
import 'pages/login_page.dart';
import 'pages/user_management_page.dart';

class AppRoutes {
  static const login = '/login';
  static const userManagement = '/user_management';
}

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.login, page: () => LoginPage()),
    GetPage(name: AppRoutes.userManagement, page: () => UserManagementPage()),
  ];
}
