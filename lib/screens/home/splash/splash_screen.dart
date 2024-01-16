import 'dart:async';

import 'package:film_fusion/utils/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    isUserLogin();
    super.initState();
  }

  void isUserLogin() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user != null) {
      Timer(const Duration(seconds: 3), () => Get.offNamed(mainScreen));
    } else {
      Timer(const Duration(seconds: 3), () => Get.offNamed(login));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              Color.fromRGBO(38, 116, 9, 1),
              Color.fromRGBO(37, 35, 35, 1)
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          ),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: Get.height * .2,
              ),
              Image.asset(
                "assets/images/logo.png",
                height: Get.height * .5,

                // color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
