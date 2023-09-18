// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

// import '../db/entity/users.dart';
// import '../db/services/localdb_services.dart';

// class ProfileController extends GetxController {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController updatePassword = TextEditingController();
//   final GlobalKey<FormState> formKey = GlobalKey<FormState>();
//   User? user;
//   final Connectivity connectivity = Connectivity();
//   final List<UserProfile> updateQueue = [];
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   UserProfile? userData;
//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();
//     _checkConnectivity();
//   }

//   void addToUpdateQueue(UserProfile request) {
//     updateQueue.add(request);
//   }

//   Future<void> processPendingUpdates() async {
//     final ConnectivityResult result = await connectivity.checkConnectivity();

//     if (result != ConnectivityResult.none) {
//       for (var request in updateQueue) {
//         await updateProfileInFirestore(request);
//         await updateProfileInLocalDb(request);
//       }
//       updateQueue.clear();
//     }
//   }

//   Future<void> updateProfileInFirestore(UserProfile request) async {
//     try {
//       await _firestore.collection('users').doc(user!.email).update({
//         'name': request.name,
//         'email': request.email,
//         'username': request.username,
//         'phone': request.phone,
//       });
//       Get.snackbar("Updated", "'Profile updated successfully in Firestore'",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.6));
//     } catch (error) {
//       debugPrint('Error updating profile in Firestore: $error');
//       addToUpdateQueue(request);
//     }
//   }

//   Future<void> updateProfileInLocalDb(UserProfile request) async {
//     try {
//       final userDao = await LocalDbService.usersDao;
//       await userDao.insertUserProfile(UserProfile(
//         email: request.email,
//         name: request.name,
//         username: request.username,
//         phone: request.phone,
//       ));
//       Get.snackbar("Updated", "'Profile updated successfully in Local DB'",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.6));
//     } catch (error) {
//       debugPrint('Error updating profile in local database: $error');
//       addToUpdateQueue(request);
//     }
//   }

//   Future<void> _checkConnectivity() async {
//     final ConnectivityResult result = await connectivity.checkConnectivity();

//     if (result == ConnectivityResult.none) {
//       _loadDataFromLocalDb();
//       debugPrint("Data From Local DB");
//     } else {
//       _loadUserData();
//       debugPrint("Data From Firestore DB");
//     }
//   }

//   Future<void> _loadDataFromLocalDb() async {
//     try {
//       final localUserData = await (await LocalDbService.usersDao)
//           .findUserProfileById(user!.email!);

//       if (localUserData != null) {
//         nameController.text = localUserData.name;
//         emailController.text = localUserData.email;
//         usernameController.text = localUserData.username;
//         phoneController.text = localUserData.phone;
//       } else {
//         debugPrint('User data not found in the local database.');
//       }
//     } catch (error) {
//       debugPrint('Error loading data from local database: $error');
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       user = _auth.currentUser;

//       if (user != null) {
//         final userDoc =
//             await _firestore.collection('users').doc(user!.email).get();
//         final _userData = userDoc.data();

//         if (userData != null) {
//           userData = UserProfile.fromFirestore(_userData!);
//           nameController.text = userData!.name;
//           emailController.text = userData!.email;
//           usernameController.text = userData!.username;
//           phoneController.text = userData!.phone;
//         } else {
//           debugPrint('User data is null.');
//         }
//       }
//     } catch (error) {
//       debugPrint('Error loading data from Firebase: $error');
//     }
//   }

//   void changepasswordDialog(
//       {required bool obscureOldpPass,
//       required bool obscureNewPass,
//       required bool isLoadingChngePassword,
//       required var context}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         final TextEditingController oldPasswordController =
//             TextEditingController();
//         final TextEditingController newPasswordController =
//             TextEditingController();

//         return AlertDialog(
//           title: const Text('Change Password'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: oldPasswordController,
//                     obscureText: obscureOldpPass,
//                     decoration: InputDecoration(
//                       labelText: 'Old Password',
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureOldpPass
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           obscureOldpPass = !obscureOldpPass;
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter old password';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: newPasswordController,
//                     obscureText: obscureNewPass,
//                     decoration: InputDecoration(
//                       labelText: 'New Password',
//                       suffixIcon: IconButton(
//                         icon: Icon(
//                           obscureNewPass
//                               ? Icons.visibility
//                               : Icons.visibility_off,
//                           color: Colors.white,
//                         ),
//                         onPressed: () {
//                           obscureNewPass = !obscureNewPass;
//                         },
//                       ),
//                     ),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter new password';
//                       } else if (value.length < 6) {
//                         return 'Password must be at least 6 characters';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: isLoadingChngePassword
//                   ? null
//                   : () async {
//                       isLoadingChngePassword = true;

//                       debugPrint("object");
//                       String oldPassword = oldPasswordController.text;
//                       String newPassword = newPasswordController.text;
//                       if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
//                         // Verify the old password before changing
//                         try {
//                           AuthCredential credential =
//                               EmailAuthProvider.credential(
//                             email: _auth.currentUser!.email!,
//                             password: oldPassword,
//                           );
//                           await _auth.currentUser!
//                               .reauthenticateWithCredential(credential);
//                           // Old password is correct, change the password
//                           await changePassword(newPassword);

//                           Navigator.of(context).pop();

//                           isLoadingChngePassword = false;
//                         } catch (e) {
//                           // Handle the case where the old password is incorrect
//                           debugPrint('Error reauthenticating: $e');
//                           Get.snackbar("Unsuccessfull",
//                               "Your password has Not updated Unsuccessfull.",
//                               snackPosition: SnackPosition.BOTTOM,
//                               backgroundColor: Colors.red.withOpacity(0.7));

//                           isLoadingChngePassword = false;
//                         }
//                       }
//                     },
//               child: isLoadingChngePassword
//                   ? const CircularProgressIndicator(
//                       color: Colors.black,
//                     )
//                   : const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> changePassword(String newPassword) async {
//     try {
//       User? user = FirebaseAuth.instance.currentUser;
//       await user?.updatePassword(newPassword);
//       Get.snackbar(
//           "Password Changed", "Your password has been updated successfully.",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.greenAccent.withOpacity(0.7));
//     } catch (error) {
//       Get.snackbar("Error", error.toString(),
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.redAccent.withOpacity(0.7));
//     }
//   }

//   void showEditProfileDialog(context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Edit Profile'),
//           content: Form(
//             key: formKey,
//             child: SingleChildScrollView(
//               child: Column(
//                 children: [
//                   TextFormField(
//                     controller: nameController,
//                     decoration: const InputDecoration(labelText: 'Name'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your name';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: emailController,
//                     decoration: const InputDecoration(
//                       labelText: 'Email',
//                       // Set the enabled property to false to make it read-only
//                       enabled: false,
//                     ),
//                   ),
//                   TextFormField(
//                     controller: usernameController,
//                     decoration: const InputDecoration(labelText: 'Username'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your username';
//                       }
//                       return null;
//                     },
//                   ),
//                   TextFormField(
//                     controller: phoneController,
//                     decoration:
//                         const InputDecoration(labelText: 'Phone Number'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter your phone number';
//                       }
//                       return null;
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               child: const Text('Cancel'),
//             ),
//             ElevatedButton(
//               onPressed: () {
//                 if (formKey.currentState!.validate()) {
//                   // Update user data in Firestore
//                   _updateUserData(
//                     name: nameController.text,
//                     email: emailController.text,
//                     username: usernameController.text,
//                     phone: phoneController.text,
//                   );

//                   Navigator.of(context).pop();
//                 }
//               },
//               child: const Text('Save'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<void> _updateUserData({
//     required String name,
//     required String email,
//     required String username,
//     required String phone,
//   }) async {
//     try {
//       // Check if the new email is already registered

//       // Update user data in Firestore
//       await _firestore
//           .collection('users')
//           .doc(_auth.currentUser!.email)
//           .update({
//         'name': name,
//         'username': username,
//         'phone': phone,
//       });

//       // await (await LocalDbService.usersDao).updateUserProfile(UserProfile(
//       //     name: name, email: email, username: username, phone: phone));

//       final currentEmail = _auth.currentUser!.email;

//       await (await LocalDbService.usersDao).updateUserProfile(UserProfile(
//           name: name, email: currentEmail!, username: username, phone: phone));

//       // Update user email in Firebase Authentication
//       await user!.updateEmail(email);

//       // Reload user data
//       _loadUserData();

//       // Show a success message
//       Get.snackbar("Updated", "'Profile updated successfully'",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.6));
//     } catch (error) {
//       // Handle error, e.g., show an error message
//       Get.snackbar("Error", 'Error updating profile: $error');
//       debugPrint(error.toString());
//     }
//   }
// }

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:film_fusion/db/entity/users.dart';
import 'package:film_fusion/db/services/localdb_services.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController oldpaswordCon = TextEditingController();
  final TextEditingController newPassCon = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? user;
  Rx<UserProfile?> userData = Rx<UserProfile?>(null);
  final Connectivity _connectivity = Connectivity();
  List<UserProfile> updateQueue = [];

  RxBool obscureOldPass = true.obs;
  RxBool obscureNewPass = true.obs;
  RxBool isLoadingChangePassword = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _checkConnectivity();

    saveTolcaldbWhenEmailNotExists();
  }

  void saveTolcaldbWhenEmailNotExists() async {
    final emailList = await (await LocalDbService.usersDao).getEmails();
    final currentUserEmail = _auth.currentUser?.email;
    final userDoc = await _firestore
        .collection('users')
        .doc(_auth.currentUser!.email)
        .get();
    final userData = userDoc.data();

    if (!emailList.contains(currentUserEmail.toString())) {
      debugPrint("Data added to local db");
      UserProfile _userData = UserProfile.fromFirestore(userData!);
      await (await LocalDbService.usersDao).insertUserProfile(UserProfile(
        name: _userData.name,
        email: _userData.email,
        username: _userData.username,
        phone: _userData.phone,
        
      ));
    }
  }

  void addToUpdateQueue(UserProfile request) {
    updateQueue.add(request);
  }

  Future<void> processPendingUpdates() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();

    if (result != ConnectivityResult.none) {
      for (var request in updateQueue) {
        await updateProfileInFirestore(request);
        await updateProfileInLocalDb(request);
      }
      updateQueue.clear();
    }
  }

  Future<void> updateProfileInFirestore(UserProfile request) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.email)
          .update({
        'name': request.name,
        'email': request.email,
        'username': request.username,
        'phone': request.phone,
      });
      Get.snackbar("Updated", "Profile updated successfully in Firestore",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.6));
    } catch (error) {
      debugPrint('Error updating profile in Firestore: $error');
      addToUpdateQueue(request);
    }
  }

  Future<void> updateProfileInLocalDb(UserProfile request) async {
    try {
      final userDao = await LocalDbService.usersDao;
      await userDao.insertUserProfile(UserProfile(
        email: request.email,
        name: request.name,
        username: request.username,
        phone: request.phone,
      ));
      Get.snackbar("Updated", "Profile updated successfully in Local DB",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.6));
    } catch (error) {
      debugPrint('Error updating profile in local database: $error');
      addToUpdateQueue(request);
    }
  }

  Future<void> _checkConnectivity() async {
    final ConnectivityResult result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.none) {
      _loadDataFromLocalDb();
      debugPrint("Data from Local DB");
    } else {
      _loadUserData();
      debugPrint("Data from Firestore DB");
    }
  }

  Future<void> _loadDataFromLocalDb() async {
    try {
      final localUserData = await (await LocalDbService.usersDao)
          .findUserProfileById(user!.email.toString());

      if (localUserData != null) {
        nameController.text = userData.value!.name;
        emailController.text = userData.value!.email;
        usernameController.text = userData.value!.username;
        phoneController.text = userData.value!.phone;
      } else {
        debugPrint('User data not found in the local database.');
      }
    } catch (error) {
      debugPrint('Error loading data from local database: $error');
    }
  }

  Future<void> _loadUserData() async {
    try {
      user = _auth.currentUser;

      if (user != null) {
        final userDoc = await _firestore
            .collection('users')
            .doc(_auth.currentUser!.email)
            .get();
        final _userData = userDoc.data();

        if (_userData != null) {
          userData.value = UserProfile.fromFirestore(_userData);
          nameController.text = userData.value!.name;
          emailController.text = userData.value!.email;
          usernameController.text = userData.value!.username;
          phoneController.text = userData.value!.phone;
        } else {
          debugPrint('User data is null.');
        }
      }
    } catch (error) {
      debugPrint('Error loading data from Firebase: $error');
    }
  }

  void changepasswordDialog(context) {
    RxBool isLoading = false.obs;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        final TextEditingController oldPasswordController =
            TextEditingController();
        final TextEditingController newPasswordController =
            TextEditingController();

        return AlertDialog(
          title: const Text('Change Password'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Obx(
                    () => TextFormField(
                      controller: oldPasswordController,
                      obscureText: obscureOldPass.value,
                      decoration: InputDecoration(
                        labelText: 'Old Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureOldPass.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            obscureOldPass.value = !obscureOldPass.value;
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          isLoading.value = false;
                          return 'Please enter old password';
                        }
                        return null;
                      },
                    ),
                  ),
                  Obx(
                    () => TextFormField(
                      controller: newPasswordController,
                      obscureText: obscureNewPass.value,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscureNewPass.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            obscureNewPass.value = !obscureNewPass.value;
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          isLoading.value = false;
                          return 'Please enter new password';
                        } else if (value.length < 6) {
                          isLoading.value = false;
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            Obx(
              () => ElevatedButton(
                onPressed: () async {
                  isLoading.value = true;

                  debugPrint("object");
                  String oldPassword = oldPasswordController.text;
                  String newPassword = newPasswordController.text;
                  if (formKey.currentState!.validate()) {
                    if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
                      // Verify the old password before changing
                      try {
                        AuthCredential credential =
                            EmailAuthProvider.credential(
                          email: _auth.currentUser!.email!,
                          password: oldPassword,
                        );
                        await _auth.currentUser!
                            .reauthenticateWithCredential(credential);
                        // Old password is correct, change the password
                        await changePassword(newPassword);

                        Navigator.of(context).pop();

                        isLoading.value = false;
                      } catch (e) {
                        // Handle the case where the old password is incorrect
                        debugPrint('Error reauthenticating: $e');
                        Get.snackbar(
                            "Unsuccessfull", "Enter You Correct Old Password.",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red.withOpacity(0.7));

                        isLoading.value = false;
                      }
                    }
                  }
                },
                child: isLoading.value
                    ? const CircularProgressIndicator(
                        color: Colors.black,
                      )
                    : const Text('Save'),
              ),
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
      Get.snackbar(
        "Password Changed",
        "Your password has been updated successfully.",
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

  void showEditProfileDialog(context) {
    RxBool isLoading = false.obs; // Add a boolean to track loading state

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Wrap the AlertDialog in a StatefulBuilder to access the local state
            return AlertDialog(
              title: const Text('Edit Profile'),
              content: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          enabled: false,
                        ),
                      ),
                      TextFormField(
                        controller: usernameController,
                        decoration:
                            const InputDecoration(labelText: 'Username'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration:
                            const InputDecoration(labelText: 'Phone Number'),
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
                  child: const Text('Cancel'),
                ),
                Obx(
                  () => ElevatedButton(
                    onPressed: isLoading.value // Check loading state
                        ? null
                        : () async {
                            if (formKey.currentState!.validate()) {
                              isLoading.value =
                                  true; // Set loading state to true

                              // Update user data in Firestore
                              await _updateUserData(
                                name: nameController.text,
                                email: emailController.text,
                                username: usernameController.text,
                                phone: phoneController.text,
                              );

                              Navigator.of(context).pop();

                              isLoading.value =
                                  false; // Set loading state to false
                            }
                          },
                    child: isLoading.value
                        ? CircularProgressIndicator() // Show loader when loading
                        : const Text('Save'),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // void showEditProfileDialog(context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text('Edit Profile'),
  //         content: Form(
  //           key: formKey,
  //           child: SingleChildScrollView(
  //             child: Column(
  //               children: [
  //                 TextFormField(
  //                   controller: nameController,
  //                   decoration: const InputDecoration(labelText: 'Name'),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter your name';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   controller: emailController,
  //                   decoration: const InputDecoration(
  //                     labelText: 'Email',
  //                     // Set the enabled property to false to make it read-only
  //                     enabled: false,
  //                   ),
  //                 ),
  //                 TextFormField(
  //                   controller: usernameController,
  //                   decoration: const InputDecoration(labelText: 'Username'),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter your username';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //                 TextFormField(
  //                   controller: phoneController,
  //                   decoration:
  //                       const InputDecoration(labelText: 'Phone Number'),
  //                   validator: (value) {
  //                     if (value == null || value.isEmpty) {
  //                       return 'Please enter your phone number';
  //                     }
  //                     return null;
  //                   },
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () {
  //               if (formKey.currentState!.validate()) {
  //                 // Update user data in Firestore
  //                 _updateUserData(
  //                   name: nameController.text,
  //                   email: emailController.text,
  //                   username: usernameController.text,
  //                   phone: phoneController.text,
  //                 );

  //                 Navigator.of(context).pop();
  //               }
  //             },
  //             child: const Text('Save'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _updateUserData({
    required String name,
    required String email,
    required String username,
    required String phone,
  }) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser!.email)
          .update({
        'name': name,
        'username': username,
        'phone': phone,
      });

      final currentEmail = _auth.currentUser!.email;
      await (await LocalDbService.usersDao).updateUserProfile(UserProfile(
        name: name,
        email: currentEmail!,
        username: username,
        phone: phone,
      ));

      await user!.updateEmail(email);
      _loadUserData();

      Get.snackbar("Updated", "Profile updated successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.6));
    } catch (error) {
      Get.snackbar("Error", 'Error updating profile: $error');
      debugPrint(error.toString());
    }
  }
}
