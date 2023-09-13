import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController updatePassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // Store the currently signed-in user
  UserModel? _userData; // Store user data from Firestore

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;
    if (_user != null) {
      final userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      final userData = userDoc.data();

      if (userData != null) {
        setState(() {
          _userData = UserModel.fromFirestore(userData);
          nameController.text = _userData!.name;
          emailController.text = _userData!.email;
          usernameController.text = _userData!.username;
          phoneController.text = _userData!.phone;
        });
      } else {
        // Handle the case where user data is null, e.g., show an error message
        print('User data is null.');
      }
    }
  }

  void _changepasswordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Change Password'),
          content: Form(
              key: _formKey,
              child: SingleChildScrollView(
                  child: Column(children: [
                TextFormField(
                  controller: updatePassword,
                  decoration: InputDecoration(labelText: 'Password'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter password';
                    } else if (value.length < 6) {
                      return 'Please above 6';
                    }
                    return null;
                  },
                ),
              ]))),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String newPassword = updatePassword.text;
                if (newPassword.isNotEmpty) {
                  changePassword(newPassword);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> changePassword(String newPassword) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      await user?.updatePassword(newPassword);
      Get.snackbar("Password Changed", "Your password has been updated successfully.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.7));
    } catch (error) {
      Get.snackbar("Error", error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withOpacity(0.7));
    }
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Update user data in Firestore
                  _updateUserData(
                    name: nameController.text,
                    email: emailController.text,
                    username: usernameController.text,
                    phone: phoneController.text,
                  );

                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateUserData({
    required String name,
    required String email,
    required String username,
    required String phone,
  }) async {
    try {
      // Check if the new email is already registered
      final emailExists = await _checkEmailExists(email);
      if (emailExists) {
        // Show an error message if the email is already registered
        ToastMessage.toastMessage('Email is already registered');
        return;
      }

      // Update user data in Firestore
      await _firestore.collection('users').doc(_user!.uid).update({
        'name': name,
        'email': email,
        'username': username,
        'phone': phone,
      });

      // Update user email in Firebase Authentication
      await _user!.updateEmail(email);

      // Reload user data
      _loadUserData();

      // Show a success message
      Get.snackbar("Updated", "'Profile updated successfully'");
    } catch (error) {
      // Handle error, e.g., show an error message
      Get.snackbar("Error", 'Error updating profile: $error');
    }
  }

  Future<bool> _checkEmailExists(String email) async {
    try {
      final result =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      return result.isNotEmpty;
    } catch (error) {
      print('Error checking email existence: $error');
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontSize: 30),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _auth.signOut().then((value) {
                  Get.offNamed(login);
                  Get.snackbar("LOGOUT", "successfully",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.greenAccent.withOpacity(0.7));
                }).onError((error, stackTrace) {
                  ToastMessage.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: _userData != null
          ? Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Center(
                    child: CircleAvatar(
                      backgroundImage: AssetImage("assets/images/logo.png"),
                      radius: 60,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Card(
                    child: ListTile(
                      leading: const Text(
                        "Name",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      title: Text(
                        _userData!
                            .name, // Access the user's name from UserModel
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Text(
                        "Email:",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      title: Text(
                        _userData!
                            .email, // Access the user's email from UserModel
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Text(
                        "User Name:",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      title: Text(
                        _userData!
                            .username, // Access the user's username from UserModel
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Text(
                        "Phone No:",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      title: Text(
                        _userData!
                            .phone, // Access the user's phone from UserModel
                        style: const TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _showEditProfileDialog();
                    },
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 236, 225, 238),
                          borderRadius: BorderRadius.circular(10)),
                      child: const Center(
                        child: Text(
                          "UPDATE",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: Get.height * .025,
                  ),
                  TextButton(
                      onPressed: () => _changepasswordDialog(),
                      child: Text("Chnage Password")),
                  const SizedBox(
                    height: 20,
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     _auth.signOut().then((value) {
                  //       Get.offNamed(login);
                  //       Get.snackbar("LOGOUT", "successfully",
                  //           snackPosition: SnackPosition.BOTTOM,
                  //           backgroundColor:
                  //               Colors.greenAccent.withOpacity(0.7));
                  //     }).onError((error, stackTrace) {
                  //       ToastMessage.toastMessage(error.toString());
                  //     });
                  //   },
                  //   child: Container(
                  //     height: 30,
                  //     width: 100,
                  //     decoration: BoxDecoration(
                  //         color: const Color.fromARGB(255, 236, 225, 238),
                  //         borderRadius: BorderRadius.circular(10)),
                  //     child: const Center(
                  //       child: Text(
                  //         "LOGOUT",
                  //         style: TextStyle(
                  //             fontSize: 16, fontWeight: FontWeight.bold),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
