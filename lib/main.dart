import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';
import 'routes.dart';

void main() async {
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  MainApp({super.key});
  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      getPages: routes,
      initialRoute: '/initialization',
    );
  }
}
