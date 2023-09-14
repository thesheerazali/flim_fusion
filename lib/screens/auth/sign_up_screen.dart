import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/screens/auth/sms_code_screen.dart';
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
  bool isLoading = false;
  bool _obscurePass = true;
  bool _obscureConf = true;
  String phoneNumber = '';

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
      return 'Phone number should be 10 digits';
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

  String? _validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a valid 10-digit phone number';
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

  TextEditingController _smsCodeController = TextEditingController();
  String _verificationId = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true; // Set loading to true
        });
        await _auth.verifyPhoneNumber(
          phoneNumber: "+92${_phoneController.text}",
          verificationCompleted: (AuthCredential credential) {
            // Auto verification if on the same device
            _signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle verification failure
            print("Verification Failed: ${e.message}");
            setState(() {
              isLoading = false;
            });
          },
          codeSent: (String verificationId, int? resendToken) {
            // Save verification ID for later use
            _verificationId = verificationId;

            // Navigate to SMS code verification screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SmsCodeScreen(
                  verificationId: verificationId,
                  name: _nameController.text,
                  phone: "+92${_phoneController.text}",
                  username: _usernameController.text,
                  email: _emailController.text,
                  password: _passwordController.text,
                ),
              ),
            ).then((_) {
              setState(() {
                isLoading =
                    false; // Set isLoading back to false when the SMS code screen is dismissed
              });
            }).catchError((error) {
              setState(() {
                isLoading = false; // Set isLoading back to false on error
              });
              print("Error navigating to SMS code screen: $error");
            });
            // .then((value) => setState(() {
            //       isLoading = false; // Set loading back to false
            //     }))
            // .onError((error, stackTrace) => setState(() {
            //       isLoading = false; // Set loading back to false
            //     }));
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            // Timeout handling
          },
        );
      } catch (e) {
        setState(() {
          isLoading = false; // Set loading back to false in case of error
        });
        print("Error sending SMS code: $e");
      }
    }
  }

  Future<void> _signInWithCredential(AuthCredential credential) async {
    try {
      // Sign in with the provided credential
      await _auth.signInWithCredential(credential);

      // If sign-in is successful, register the user
      await _firebaseService.signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        name: _nameController.text,
        phone: "+92${_phoneController.text}",
        username: _usernameController.text,
      );

      // Navigate to the login screen
      Get.offNamed(login);
    } catch (e) {
      // Handle sign-in errors
      print("Error signing in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Container(
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
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: Get.height * .2,
                    ),
                    const Text(
                      "Create Your Account",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      height: Get.height * .015,
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
                              width:
                                  2 // Color of the bottom line when unfocused
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
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
                              width:
                                  2 // Color of the bottom line when unfocused
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
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
                              width:
                                  2 // Color of the bottom line when unfocused
                              ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
                    ),
                    TextFormField(
                      controller: _phoneController,
                      validator: _validatePhone,
                      onChanged: _validatePhoneNumber,
                      maxLength: 11,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Phone No', // Use a standard hint text
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
                            width: 2, // Color of the bottom line when unfocused
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      validator: _validatePassword,
                      obscureText: _obscurePass,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Password',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        alignLabelWithHint: true,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .white, // Color of the bottom line when focused
                            width:
                                2.0, // Thickness of the bottom line when focused
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width:
                                  2 // Color of the bottom line when unfocused
                              ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePass
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePass = !_obscurePass;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
                    ),
                    TextFormField(
                      controller: _confirmPasswordController,
                      validator: _validateConfirmPassword,
                      obscureText: true, // For password fields
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        hintStyle: const TextStyle(color: Colors.white),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.white,
                        ),
                        alignLabelWithHint: true,
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors
                                .white, // Color of the bottom line when focused
                            width:
                                2.0, // Thickness of the bottom line when focused
                          ),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.white,
                              width:
                                  2 // Color of the bottom line when unfocused
                              ),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConf
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConf = !_obscureConf;
                            });
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .03,
                    ),
                    GestureDetector(
                      onTap: () => _signUp(),
                      child: Container(
                        height: Get.height * .07,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                        ),
                        child: const Center(
                          child: Text(
                            "SIGN UP",
                            style: TextStyle(color: Colors.black, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Get.height * .015,
                    ),
                    TextButton(
                        onPressed: () => Get.offNamed(login),
                        // onPressed: () => Get.toNamed(signup),
                        child: Text(
                          "LOGIN",
                          style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 30),
                        ))
                  ]),
                ),
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.black
                    .withOpacity(0.5), // Dark semi-transparent background
                child: const Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
