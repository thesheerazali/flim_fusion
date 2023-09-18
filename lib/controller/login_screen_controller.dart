import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../db/entity/users.dart';
import '../../db/services/localdb_services.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final obscureText = true.obs;
  final useremailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  final auth = FirebaseAuth.instance;
 void login() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      auth
          .signInWithEmailAndPassword(
            email: useremailController.text.toString(),
            password: passwordController.text.toString(),
          )
          .then((value) async {
        isLoading.value = false;
       

        Get.snackbar(
          "LOGIN",
          "Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.5),
        );
        Get.offAllNamed(mainScreen);
      }).onError((error, stackTrace) {
        ToastMessage.toastMessage(error.toString());
        debugPrint(error.toString());
        isLoading.value = false;
      });
    }
  }
 

  void sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Password Reset Email Sent",
        "Check your email for password reset instructions.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.greenAccent.withOpacity(0.7),
      );
    } catch (error) {
      Get.snackbar(
        "Error",
        error.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.7),
      );
    }
  }

  void forgotPasswordDialog() {
    Get.defaultDialog(
      title: "Forgot Password",
      content: Column(
        children: [
          TextFormField(
            controller: useremailController,
            validator: validateUsername,
            decoration: const InputDecoration(labelText: "Enter your email"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              String email = useremailController.text.trim();
              if (email.isNotEmpty) {
                sendPasswordResetEmail(email);
                Get.back();
              }
            },
            child: const Text("Reset Password"),
          ),
        ],
      ),
    );
  }
}

