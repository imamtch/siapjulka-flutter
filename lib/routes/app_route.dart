import 'package:get/get.dart';
import 'package:siapjulka/pages/home_page.dart';
import 'package:siapjulka/pages/login_page.dart';
import 'package:siapjulka/pages/profile_page.dart';
import 'package:siapjulka/routes/name_route.dart';

class AppRoute {
  static final pages = [
    GetPage(
      name: NameRoute.login,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: NameRoute.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: NameRoute.profil,
      page: () => const ProfilePage(),
    ),
  ];
}