// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// import '../../model/user_model.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({super.key});

//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   User? _user; // Store the currently signed-in user
//   UserMetadata? _userData; // Store user data from Firestore

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     _user = _auth.currentUser;
//     if (_user != null) {
//       final userDoc =
//           await _firestore.collection('users').doc(_user!.uid).get();
//       final userData = userDoc.data() as Map<String, dynamic>;
//       setState(() {
//         _userData = UserModel.fromFirestore(userData) as UserMetadata?;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Profile'),
//       ),
//       body: _userData != null
//           ? Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   'Username: ${_userData!}',
//                   style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   'Email: ${_userData!}',
//                   style: TextStyle(fontSize: 18.0),
//                 ),
//                 // Add more fields as needed
//               ],
//             )
//           : Center(
//               child: CircularProgressIndicator(),
//             ),
//     );
//   }
// }
import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/toast_message.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user; // Store the currently signed-in user
  Map<String, dynamic>? _userData; // Store user data from Firestore

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
      setState(() {
        _userData = userDoc.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Container(
        child: _userData != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ListTile(
                    title: Text(
                      '${_userData!['username']}',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                    subtitle: Text(
                      '${_userData!['email']}',
                      style: const TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                  // Text(
                  //   'Username: ${_userData!['username']}',
                  //   style: const TextStyle(
                  //       fontSize: 18.0, fontWeight: FontWeight.bold),
                  // ),

                  // Add more fields as needed
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
