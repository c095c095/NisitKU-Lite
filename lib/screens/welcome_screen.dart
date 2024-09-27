// welcome screen
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nisitku_lite/components/primary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'NisitKU Lite\nเบากว่าคุณ เร็วกว่าคุณ\nดีกว่าคุณด้วย',
                style: TextStyle(
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              const Text(
                'พบฟิเจอร์ดี ๆ ที่ไม่มีคนถาม ที่ดีกว่าแอปพลิเคชั่นต้นฉบับ (มั้ง)',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    '🤫🧏🏻‍♂️',
                    style: TextStyle(
                      fontSize: 80.0,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: PrimaryButton(
                        text: 'ผมต้องการอะไรที่น่าสนใจกว่านี้',
                        onPressed: () {
                          Get.toNamed('/login');
                        })),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Get.toNamed('/login');
                },
                child: const Text(
                  'ไม่ได้สำคัญกับผม',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
