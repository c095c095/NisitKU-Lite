import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final RxBool isLoading;

  PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    RxBool? isLoading,
  }) : isLoading = isLoading ?? false.obs;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 48.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: isLoading.value ? null : onPressed,
        child: isLoading.value
            ? const SizedBox(
                width: 24.0,
                height: 24.0,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                text,
                style: const TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
      );
    });
  }
}
