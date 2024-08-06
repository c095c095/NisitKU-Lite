import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Obx(() {
                if (_authController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                return ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _authController.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  child: Text('Login'),
                );
              }),
              Obx(() {
                if (_authController.errorMessage.value.isNotEmpty) {
                  return Column(
                    children: [
                      Text(
                        _authController.errorMessage.value,
                        style: TextStyle(color: Colors.red),
                      ),
                      SizedBox(height: 10),
                    ],
                  );
                }

                return Container();
              })
            ],
          ),
        ),
      ),
    );
  }
}
