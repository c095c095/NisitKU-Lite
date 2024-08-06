import 'package:get/get.dart';
import 'package:nisitku_lite/screens/home_screen.dart';
import 'package:nisitku_lite/screens/login_screen.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/login',
    page: () => LoginScreen(),
  ),
  GetPage(
    name: '/home',
    page: () => HomeScreen(),
  )
];
