import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';
import 'package:nisitku_lite/services/api_service.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final AuthController _authController = Get.find();
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
                'Welcome ${_authController.user['name_th']} ${_authController.user['surname_th']}'),
            Builder(
              builder: (_) {
                return FutureBuilder(
                  future: _apiService.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Text('${snapshot.data.toString()}');
                    }
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
