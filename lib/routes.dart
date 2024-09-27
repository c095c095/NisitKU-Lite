import 'package:get/get.dart';
import 'package:nisitku_lite/screens/home_screen.dart';
import 'package:nisitku_lite/screens/initialization_screen.dart';
import 'package:nisitku_lite/screens/login_screen.dart';
import 'package:nisitku_lite/screens/welcome_screen.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/initialization',
    page: () => InitializationScreen(),
  ),
  GetPage(
    name: '/welcome',
    page: () => WelcomeScreen(),
  ),
  GetPage(
    name: '/login',
    page: () => LoginScreen(),
  ),
  GetPage(
    name: '/home',
    page: () => HomeScreen(),
  )
];
