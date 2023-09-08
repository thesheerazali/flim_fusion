import 'package:film_fusion/constants/routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/firebase_service.dart';
import '../../utils/toast_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  // final _fatherNameController = TextEditingController();
  // final _cnicController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  // String? _validateFatherName(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return "Father's Name is required";
  //   }
  //   return null;
  // }

  // String? _validateCNIC(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return 'CNIC is required';
  //   } else if (value.length != 13) {
  //     return 'CNIC should be 13 digits';
  //   }
  //   return null;
  // }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    } else if (value.length != 11) {
      return 'Phone number should be 11 digits';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!value.contains('@')) {
      return 'Invalid email format';
    }
    return null;
  }

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

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm Password is required';
    } else if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Signup user with Firebase
        await _firebaseService.signUpUser(
            email: _emailController.text,
            password: _passwordController.text,
            name: _nameController.text,
            phone: _phoneController.text,
            username: _usernameController.text);

        // Navigate to the main screen on successful signup
        Get.offNamed(login);
      } catch (e) {
        // Handle signup errors (e.g., duplicate email, weak password)
        // Display an error message to the user
        final snackBar = SnackBar(content: Text('Signup failed: $e'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                horizontal: Get.width * .16,
              ),
              child: SingleChildScrollView(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    "assets/images/logo.png",
                    height: Get.height * .15,
                  ),
                  const Text(
                    "Create Your Account",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  TextFormField(
                    controller: _nameController,
                    validator: _validateName,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Name',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        CupertinoIcons.person_alt,
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .02,
                  ),
                  TextFormField(
                    controller: _usernameController,
                    validator: _validateUsername,
                    style: const TextStyle(color: Colors.white),
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
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .02,
                  ),
                  TextFormField(
                    controller: _emailController,
                    validator: _validateEmail,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'E-Mail',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.email,
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .02,
                  ),
                  TextFormField(
                    controller: _phoneController,
                    validator: _validatePhone,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Phone No',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.phone,
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .02,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    validator: _validatePassword,
                    style: const TextStyle(color: Colors.white),
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
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .01,
                  ),
                  TextFormField(
                    controller: _confirmPasswordController,
                    validator: _validateConfirmPassword,
                    obscureText: true, // For password fields
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                      hintStyle: TextStyle(color: Colors.white),
                      prefixIcon: Icon(
                        Icons.lock,
                        color: Colors.white,
                      ),
                      alignLabelWithHint: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .white, // Color of the bottom line when focused
                          width:
                              2.0, // Thickness of the bottom line when focused
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
                    height: Get.height * .05,
                  ),
                  GestureDetector(
                    onTap: () => _signUp(),
                    child: Container(
                      height: Get.height * .07,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white),
                      child: const Center(
                          child: Text(
                        "SIGN UP",
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      )),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .02,
                  ),
                  TextButton(
                      onPressed: () {},
                      // onPressed: () => Get.toNamed(signup),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(
                            color: Colors.white.withOpacity(0.8), fontSize: 30),
                      ))
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
