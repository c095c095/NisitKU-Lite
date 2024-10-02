import 'package:get/get.dart';
import 'package:nisitku_lite/screens/home_screen.dart';
import 'package:nisitku_lite/screens/initialization_screen.dart';
import 'package:nisitku_lite/screens/login_screen.dart';
import 'package:nisitku_lite/screens/welcome_screen.dart';

final List<GetPage> routes = [
  GetPage(
    name: '/initialization',
    page: () => const InitializationScreen(),
  ),
  GetPage(
    name: '/welcome',
    page: () => const WelcomeScreen(),
  ),
  GetPage(
    name: '/login',
    page: () => const LoginScreen(),
  ),
  GetPage(
    name: '/home',
    page: () => HomeScreen(),
  )
];
