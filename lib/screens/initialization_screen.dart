import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';

class InitializationScreen extends StatefulWidget {
  const InitializationScreen({super.key});

  @override
  _InitializationScreenState createState() => _InitializationScreenState();
}

class _InitializationScreenState extends State<InitializationScreen> {
  final AuthController authController = Get.find();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    await authController.loadUserFromStorage();
    if (authController.isAuthenticated.value) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
