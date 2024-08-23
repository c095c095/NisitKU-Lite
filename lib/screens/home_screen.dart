import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';
import 'package:nisitku_lite/services/auth_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthController _authController = Get.find();
  final AuthService _apiService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                  'Welcome ${_authController.user['firstname_th']} ${_authController.user['lastname_th']}'),
              Column(
                children: _authController.user.entries.map((entry) {
                  return Row(
                    children: [
                      Text(entry.key.toString()),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(entry.value.toString()),
                      ),
                    ],
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: () {
                  _authController.logout();
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
