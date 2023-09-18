import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/db/entity/users.dart';
import 'package:film_fusion/db/services/localdb_services.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class SmsCodeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController smsCodeController = TextEditingController();
  final isLoading = false.obs;

  Future<void> verifySmsCode({
    required String verificationId,
    required String name,
    required String phone,
    required String username,
    required String email,
    required String password,
  }) async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCodeController.text,
    );
    isLoading.value = true;

    try {
      // Verify the SMS code
      await _auth.signInWithCredential(credential);

      // If verification is successful, register the user
      await (await LocalDbService.usersDao).insertUserProfile(UserProfile(
        name: name,
        username: username,
        email: email,
        phone: phone,
      ));

      // Attempt to save user data in Firestore
      await _firestore.collection('users').doc(email).set({
        'name': name,
        'email': email,
        'phone': phone,
        'username': username,
      });

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the login screen
      Get.offAllNamed(login);
      isLoading.value = false;
    } catch (e) {
      // Handle verification errors
      // Display an error message to the user
      final snackBar = SnackBar(content: Text('Verification failed: $e'));
      debugPrint(e.toString());
      isLoading.value = false;
      ScaffoldMessenger.of(Get.context!).showSnackBar(snackBar);

      // If any exceptions occur, avoid saving data to Firestore
    }
  }
}
