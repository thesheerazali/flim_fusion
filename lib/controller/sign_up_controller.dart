import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:film_fusion/utils/constants/routes.dart';

import 'package:firebase_auth/firebase_auth.dart';

import '../../services/firebase_service.dart';
import '../screens/auth/sms_code_screen.dart';

class SignUpController extends GetxController {
  final isLoading = false.obs;
  final obscurePass = true.obs;
  final obscureConf = true.obs;
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final smsCodeController = TextEditingController();
  String verificationId = '';
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseService firebaseService = FirebaseService();

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (value.length != 11) {
      return 'Phone number should be 10 digits';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid 10-digit phone number';
    }
    return null;
  }

  void signUp() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;
        await auth.verifyPhoneNumber(
          phoneNumber: "+92${phoneController.text}",
          verificationCompleted: (AuthCredential credential) {
            _signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            print("Verification Failed: ${e.message}");
            isLoading.value = false;
          },
          codeSent: (String verificationId, int? resendToken) {
            this.verificationId = verificationId;
            Get.to(
              SmsCodeScreen(
                verificationId: verificationId,
                name: nameController.text,
                phone: "+92${phoneController.text}",
                username: usernameController.text,
                email: emailController.text,
                password: passwordController.text,
              ),
            );
            isLoading.value = false;
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        isLoading.value = false;
        print("Error sending SMS code: $e");
      }
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      await auth.signInWithCredential(credential);
      await firebaseService.signUpUser(
        email: emailController.text,
        password: passwordController.text,
        name: nameController.text,
        phone: "+92${phoneController.text}",
        username: usernameController.text,
      );
      Get.offNamed(login);
    } catch (e) {
      print("Error signing in: $e");
    }
  }
}
