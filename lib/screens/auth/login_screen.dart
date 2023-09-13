import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_with_phone.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum LoginType { email, phone }

class _LoginScreenState extends State<LoginScreen> {
  bool isLoading = false;
  LoginType _loginType = LoginType.email; // Default to email login
  // final _formKey = GlobalKey<FormState>();
  // TextEditingController emailController = TextEditingController();
  // TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _useremailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  final _auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      isLoading = true;
    });

    _auth
        .signInWithEmailAndPassword(
            email: _useremailController.text.toString(),
            password: _passwordController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });

      Get.snackbar("LOGIN", "successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.5));
      Get.offNamed(mainScreen);
    }).onError((error, stackTrace) {
      ToastMessage.toastMessage(error.toString());
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromRGBO(38, 116, 9, 1),
            Color.fromRGBO(0, 0, 0, 1),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * .1, vertical: Get.height * .06),
            child: Column(children: [
              Image.asset(
                "assets/images/logo.png",
                height: Get.height * .3,
              ),
              TextFormField(
                controller: _useremailController,
                validator: _validateUsername,
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Colors.white, // Color of the bottom line when focused
                      width: 2.0, // Thickness of the bottom line when focused
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white,
                        width: 2 // Color of the bottom line when unfocused
                        ),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                controller: _passwordController,
                validator: _validatePassword,
                obscureText: true, // For password fields
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.white),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                  alignLabelWithHint: true,
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color:
                          Colors.white, // Color of the bottom line when focused
                      width: 2.0, // Thickness of the bottom line when focused
                    ),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                        color: Colors.white,
                        width: 2 // Color of the bottom line when unfocused
                        ),
                  ),
                ),
              ),
              SizedBox(
                height: Get.height * .08,
              ),
              GestureDetector(
                onTap: () {
                  print("object");
                  login();
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Center(
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            )
                          : const Text(
                              "LOGIN",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 20),
                            )),
                ),
              ),
              SizedBox(
                height: Get.height * .005,
              ),
              TextButton(
                onPressed: () =>forgetPassowrdDialog(),
                child: Text(
                  "Forgot Your Password?",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),
              // GestureDetector(
              //   onTap: () {
              //     Get.to(PhoneNumberScreen());
              //   },
              //   child: Container(
              //     height: 60,
              //     width: double.infinity,
              //     decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(10),
              //         color: Colors.white),
              //     child: Center(
              //         child: isLoading
              //             ? const Center(
              //                 child: CircularProgressIndicator(
              //                   color: Colors.black,
              //                 ),
              //               )
              //             : const Text(
              //                 "LOGIN WITH PHONE",
              //                 style:
              //                     TextStyle(color: Colors.black, fontSize: 20),
              //               )),
              //   ),
              // ),
              SizedBox(
                height: Get.height * .04,
              ),
              TextButton(
                  onPressed: () => Get.toNamed(signup),
                  child: Text(
                    "SIGN UP",
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8), fontSize: 20),
                  ))
            ]),
          ),
        ),
      ),
    );
  }

   Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      Get.snackbar("Password Reset Email Sent", "Check your email for password reset instructions.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.7));
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.7));
    }
  }

  void forgetPassowrdDialog(){
     showDialog(
      context: context,
      builder: (BuildContext context) {
        TextEditingController emailController = TextEditingController();
        return AlertDialog(
          title: Text("Forgot Password"),
          content: TextField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Enter your email",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                String email = emailController.text;
                if (email.isNotEmpty) {
                  sendPasswordResetEmail(email);
                  Navigator.of(context).pop();
                }
              },
              child: Text("Reset Password"),
            ),
          ],
        );
      },
    );
  }
}


