import 'package:get/get.dart';
import 'package:uaspemob/views/login_view.dart';
import 'package:uaspemob/views/dashboard_view.dart';
import 'package:uaspemob/views/cashier_view.dart';

class AppRoutes {
  // Definisikan nama-nama rute
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const cashier = '/cashier';

  // Mendefinisikan rute-rute yang ada
  static final pages = [
    GetPage(name: login, page: () => Login()),
    GetPage(name: dashboard, page: () => DashboardView()),
    GetPage(name: cashier, page: () => CashierView()),
  ];
}
