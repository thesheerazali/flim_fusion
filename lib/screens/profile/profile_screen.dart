// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:film_fusion/constants/routes.dart';
// import 'package:film_fusion/db/entity/users.dart';

// import 'package:film_fusion/db/services/localdb_services.dart';
// import 'package:film_fusion/utils/toast_message.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:get/get.dart';

// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final TextEditingController nameController = TextEditingController();

//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController updatePassword = TextEditingController();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user;
//   UserProfile? _userData;
//   final Connectivity _connectivity = Connectivity();
//   List<UserProfile> updateQueue = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//     _checkConnectivity();
//   }

//   void addToUpdateQueue(UserProfile request) {
//     updateQueue.add(request);
//   }

// // Function to process pending update requests when internet is available
//   Future<void> processPendingUpdates() async {
//     final ConnectivityResult result = await Connectivity().checkConnectivity();

//     if (result != ConnectivityResult.none) {
//       for (var request in updateQueue) {
//         // Update data in Firestore
//         await updateProfileInFirestore(request);
//         // Update data in local database (Floor)
//         await updateProfileInLocalDb(request);
//       }
//       // Clear the update queue
//       updateQueue.clear();
//     }
//   }

// // Function to update profile data in Firestore
//   Future<void> updateProfileInFirestore(UserProfile request) async {
//     try {
//       // Update user data in Firestore
//       await _firestore
//           .collection('users')
//           .doc(_auth.currentUser!.email)
//           .update({
//         'name': request.name,
//         'email': request.email,
//         'username': request.username,
//         'phone': request.phone,
//       });
//       Get.snackbar("Updated", "'Profile updated successfully in FireStore'",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.6));
//       // Success, you can handle success here
//     } catch (error) {
//       debugPrint('Error updating profile in Firestore: $error');
//       // Handle error, e.g., add the request back to the queue
//       addToUpdateQueue(request);
//     }
//   }

// // Function to update profile data in local database (Floor)
//   Future<void> updateProfileInLocalDb(UserProfile request) async {
//     try {
//       final userDao = await LocalDbService.usersDao;
//       // Update or insert the user data into the local database
//       await userDao.insertUserProfile(UserProfile(
//         email: request.email,
//         name: request.name,
//         username: request.username,
//         phone: request.phone,
//       ));
//       Get.snackbar(
//           "Updated", "'Profile updated successfully in Floor Local db'",
//           snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.green.withOpacity(0.6));

//       // Success, you can handle success here
//     } catch (error) {
//       debugPrint('Error updating profile in local database: $error');
//       // Handle error, e.g., add the request back to the queue
//       addToUpdateQueue(request);
//     }
//   }

// // Data structure for profile update request

//   Future<void> _checkConnectivity() async {
//     final ConnectivityResult result = await _connectivity.checkConnectivity();

//     if (result == ConnectivityResult.none) {
//       // No internet connection, load data from local database
//       _loadDataFromLocalDb();
//       debugPrint("Data Froom Local db");
//     } else {
//       // Internet connection is available, load data from Firebase
//       _loadUserData();

//       debugPrint("Data Froom Firestore db");
//     }
//   }

//   Future<void> _loadDataFromLocalDb() async {
//     try {
//       // Use your Floor database to retrieve user data from the local database

//       final localUserData = await (await LocalDbService.usersDao)
//           .findUserProfileById(_user!.email.toString());

//       if (localUserData != null) {
//         setState(() {
//           nameController.text = _userData!.name;
//           emailController.text = _userData!.email;
//           usernameController.text = _userData!.username;
//           phoneController.text = _userData!.phone;
//         });
//       } else {
//         debugPrint('User data not found in the local database.');
//       }
//     } catch (error) {
//       debugPrint('Error loading data from local database: $error');
//     }
//   }

//   Future<void> _loadUserData() async {
//     try {
//       _user = _auth.currentUser;

//       if (_user != null) {
//         final userDoc = await _firestore
//             .collection('users')
//             .doc(_auth.currentUser!.email)
//             .get();
//         final userData = userDoc.data();

//         if (userData != null) {
//           setState(() {
//             _userData = UserProfile.fromFirestore(userData);
//             nameController.text = _userData!.name;
//             emailController.text = _userData!.email;
//             usernameController.text = _userData!.username;
//             phoneController.text = _userData!.phone;
//           });
//         } else {
//           debugPrint('User data is null.');
//         }
//       }
//     } catch (error) {
//       debugPrint('Error loading data from Firebase: $error');
//     }
//   }

//   // Future<void> _loadUserData() async {
//   //   _user = _auth.currentUser;

//   //   if (_user != null) {
//   // final userDoc = await _firestore
//   //     .collection('users')
//   //     .doc(_auth.currentUser!.email)
//   //         .get();
//   //     final userData = userDoc.data();

//   //     if (userData != null) {
//   //       setState(() {
//   //         _userData = UserModel.fromFirestore(userData);
//   //         nameController.text = _userData!.name;
//   //         emailController.text = _userData!.email;
//   //         usernameController.text = _userData!.username;
//   //         phoneController.text = _userData!.phone;
//   //       });
//   //     } else {
//   //       // Handle the case where user data is null, e.g., show an error message
//   //       print('User data is null.');
//   //     }
//   //   }
//   // }

// void _changepasswordDialog(
//     {required bool obscureOldpPass,
//     required bool obscureNewPass,
//     required bool isLoadingChngePassword}) {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       final TextEditingController oldPasswordController =
//           TextEditingController();
//       final TextEditingController newPasswordController =
//           TextEditingController();

//       return AlertDialog(
//         title: const Text('Change Password'),
//         content: Form(
//           key: _formKey,
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 TextFormField(
//                   controller: oldPasswordController,
//                   obscureText: obscureOldpPass,
//                   decoration: InputDecoration(
//                     labelText: 'Old Password',
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscureOldpPass
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           obscureOldpPass = !obscureOldpPass;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter old password';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   controller: newPasswordController,
//                   obscureText: obscureNewPass,
//                   decoration: InputDecoration(
//                     labelText: 'New Password',
//                     suffixIcon: IconButton(
//                       icon: Icon(
//                         obscureNewPass
//                             ? Icons.visibility
//                             : Icons.visibility_off,
//                         color: Colors.white,
//                       ),
//                       onPressed: () {
//                         setState(() {
//                           obscureNewPass = !obscureNewPass;
//                         });
//                       },
//                     ),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter new password';
//                     } else if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
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
//             onPressed: isLoadingChngePassword
//                 ? null
//                 : () async {
//                     setState(() {
//                       isLoadingChngePassword = true;
//                     });
//                     debugPrint("object");
//                     String oldPassword = oldPasswordController.text;
//                     String newPassword = newPasswordController.text;
//                     if (oldPassword.isNotEmpty && newPassword.isNotEmpty) {
//                       // Verify the old password before changing
//                       try {
//                         AuthCredential credential =
//                             EmailAuthProvider.credential(
//                           email: _auth.currentUser!.email!,
//                           password: oldPassword,
//                         );
//                         await _auth.currentUser!
//                             .reauthenticateWithCredential(credential);
//                         // Old password is correct, change the password
//                         await changePassword(newPassword);

//                         Navigator.of(context).pop();
//                         setState(() {
//                           isLoadingChngePassword = false;
//                         });
//                       } catch (e) {
//                         // Handle the case where the old password is incorrect
//                         debugPrint('Error reauthenticating: $e');
//                         Get.snackbar("Unsuccessfull",
//                             "Your password has Not updated Unsuccessfull.",
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red.withOpacity(0.7));
//                         setState(() {
//                           isLoadingChngePassword = false;
//                         });
//                       }
//                     }
//                   },
//             child: isLoadingChngePassword
//                 ? const CircularProgressIndicator(
//                     color: Colors.black,
//                   )
//                 : const Text('Save'),
//           ),
//         ],
//       );
//     },
//   );
// }

// Future<void> changePassword(String newPassword) async {
//   try {
//     User? user = FirebaseAuth.instance.currentUser;
//     await user?.updatePassword(newPassword);
//     Get.snackbar(
//         "Password Changed", "Your password has been updated successfully.",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.greenAccent.withOpacity(0.7));
//   } catch (error) {
//     Get.snackbar("Error", error.toString(),
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.redAccent.withOpacity(0.7));
//   }
// }

// void _showEditProfileDialog() {
//   showDialog(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('Edit Profile'),
//         content: Form(
//           key: _formKey,
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
//               if (_formKey.currentState!.validate()) {
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
//       await _user!.updateEmail(email);

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

//   @override
//   Widget build(BuildContext context) {
//     bool obscureOldPass = false;
//     bool obscureNewPass = false;
//     bool isLoadingChngePassword = false;
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text(
//           'Profile',
//           style: TextStyle(fontSize: 30),
//         ),
//         centerTitle: true,
//         actions: [
//           IconButton(
//               onPressed: () {
//   _auth.signOut().then((value) {
//     Get.offNamed(login);
//     Get.snackbar("LOGOUT", "successfully",
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.greenAccent.withOpacity(0.7));
//   }).onError((error, stackTrace) {
//     ToastMessage.toastMessage(error.toString());
//   });
// },
//               icon: const Icon(Icons.logout))
//         ],
//       ),
//       body: _userData != null
//           ? Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Center(
//                     child: CircleAvatar(
//                       backgroundImage: AssetImage("assets/images/logo.png"),
//                       radius: 60,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 30,
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: const Text(
//                         "Name",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                       title: Text(
//                         _userData!
//                             .name, // Access the user's name from UserModel
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: const Text(
//                         "Email:",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                       title: Text(
//                         _userData!
//                             .email, // Access the user's email from UserModel
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: const Text(
//                         "User Name:",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                       title: Text(
//                         _userData!
//                             .username, // Access the user's username from UserModel
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Card(
//                     child: ListTile(
//                       leading: const Text(
//                         "Phone No:",
//                         style: TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                       title: Text(
//                         _userData!
//                             .phone, // Access the user's phone from UserModel
//                         style: const TextStyle(
//                           fontSize: 18.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _showEditProfileDialog();
//                     },
//                     child: Container(
//                       height: 50,
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                           color: const Color.fromARGB(255, 236, 225, 238),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: const Center(
//                         child: Text(
//                           "UPDATE",
//                           style: TextStyle(
//                               fontSize: 18, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(
//                     height: Get.height * .025,
//                   ),
//                   TextButton(
//                       onPressed: () => _changepasswordDialog(
//                           isLoadingChngePassword: isLoadingChngePassword,
//                           obscureNewPass: obscureNewPass,
//                           obscureOldpPass: obscureOldPass),
//                       child: const Text("Chnage Password")),
//                   const SizedBox(
//                     height: 20,
//                   ),
//                   // InkWell(
//                   //   onTap: () {
//                   //     _auth.signOut().then((value) {
//                   //       Get.offNamed(login);
//                   //       Get.snackbar("LOGOUT", "successfully",
//                   //           snackPosition: SnackPosition.BOTTOM,
//                   //           backgroundColor:
//                   //               Colors.greenAccent.withOpacity(0.7));
//                   //     }).onError((error, stackTrace) {
//                   //       ToastMessage.toastMessage(error.toString());
//                   //     });
//                   //   },
//                   //   child: Container(
//                   //     height: 30,
//                   //     width: 100,
//                   //     decoration: BoxDecoration(
//                   //         color: const Color.fromARGB(255, 236, 225, 238),
//                   //         borderRadius: BorderRadius.circular(10)),
//                   //     child: const Center(
//                   //       child: Text(
//                   //         "LOGOUT",
//                   //         style: TextStyle(
//                   //             fontSize: 16, fontWeight: FontWeight.bold),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // ),
//                 ],
//               ),
//             )
//           : const Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }

import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/controller/profile_screen_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/toast_message.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProfileController controller = Get.put(ProfileController());
    final FirebaseAuth _auth = FirebaseAuth.instance;
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
                  Get.snackbar("LOGOUT", "Successfully",
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.greenAccent.withOpacity(0.7));
                }).onError((error, stackTrace) {
                  ToastMessage.toastMessage(error.toString());
                });
              },
              icon: const Icon(Icons.logout),
            )
          ],
        ),
        body: Obx(
          () => controller.userData.value != null
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
                      const SizedBox(height: 30),
                      Card(
                        child: ListTile(
                          leading: const Text(
                            "Name",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          title: Obx(
                            () => Text(
                              controller.userData.value!.name,
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
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
                          title: Obx(
                            () => Text(
                              controller.userData.value!.email,
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
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
                            title: Obx(
                              () => Text(
                                controller.userData.value!.username,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                      ),
                      Card(
                        child: ListTile(
                            leading: const Text(
                              "Phone No:",
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            title: Obx(
                              () => Text(
                                controller.userData.value!.phone,
                                style: const TextStyle(
                                  fontSize: 18.0,
                                ),
                              ),
                            )),
                      ),
                      const SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          controller.showEditProfileDialog(context);
                        },
                        child: Container(
                          height: 50,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 236, 225, 238),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Center(
                            child: Text(
                              "UPDATE",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.025),
                      TextButton(
                        onPressed: () =>
                            controller.changepasswordDialog(context),
                        child: const Text("Change Password"),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        ));
  }
}
