import 'package:film_fusion/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/login_screen_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.put(LoginController());
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(38, 116, 9, 1),
              Color.fromRGBO(0, 0, 0, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: controller.formKey, // Access _formKey from controller
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Get.width * .1, vertical: Get.height * .06),
            child: Column(
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  height: Get.height * .3,
                ),
                TextFormField(
                  controller: controller.useremailController,
                  validator: (value) => controller.validateUsername(value),
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Email',
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
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    validator: (value) => controller.validatePassword(value),
                    obscureText:
                        controller.obscureText.value, // For password fields
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Password',
                      hintStyle: const TextStyle(
                        color: Colors.white,
                      ),
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
                            width: 2 // Color of the bottom line when unfocused
                            ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.obscureText.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          controller.obscureText.value =
                              !controller.obscureText.value;
                        },
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: Get.height * .08,
                ),
                // Your existing UI code here

                GestureDetector(
                  onTap: () {
                    print("object");
                    controller
                        .login(); // Call the login method from the controller
                  },
                  child: Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Obx(
                      () => Center(
                          child: controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : const Text(
                                  "LOGIN",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 20),
                                )),
                    ),
                  ),
                ),
                SizedBox(
                  height: Get.height * .005,
                ),
                TextButton(
                  onPressed: () => controller.forgotPasswordDialog(),
                  child: Text(
                    "Forgot Your Password?",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
