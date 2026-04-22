import 'package:flutter/widgets.dart';

class AuthController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();

  final TextEditingController otpController = TextEditingController();

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    currentPasswordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    otpController.dispose();
  }
}
