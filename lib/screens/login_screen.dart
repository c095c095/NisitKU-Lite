import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/controllers/auth_controller.dart';
import 'package:nisitku_lite/components/primary_button.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthController _authController = Get.put(AuthController());
  final FocusNode _passwordFocusNode = FocusNode();
  bool isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'เข้าสู่ระบบ',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 36.0),
                TextFormField(
                  controller: _emailController,
                  autofocus: true,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดกรอก username ของคุณ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'รหัสผ่าน',
                    labelStyle: const TextStyle(
                      color: Colors.black,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !isPasswordVisible,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.done,
                  onFieldSubmitted: (_) async {
                    if (_formKey.currentState!.validate()) {
                      await _authController.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    } else {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'โปรดกรอกรหัสผ่านของคุณ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                Obx(() {
                  if (_authController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return PrimaryButton(
                    text: 'เข้าสู่ระบบ',
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        await _authController.login(
                          _emailController.text,
                          _passwordController.text,
                        );
                      }
                    },
                  );
                }),
                Obx(() {
                  if (_authController.errorMessage.value.isNotEmpty) {
                    return Column(
                      children: [
                        Text(
                          _authController.errorMessage.value,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 10),
                      ],
                    );
                  }

                  return Container();
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
