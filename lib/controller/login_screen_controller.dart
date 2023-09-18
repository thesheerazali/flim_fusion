import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/utils/toast_message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final isLoading = false.obs;
  final obscureText = true.obs;
  final useremailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  final auth = FirebaseAuth.instance;
  void login() {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;

      auth
          .signInWithEmailAndPassword(
        email: useremailController.text.toString(),
        password: passwordController.text.toString(),
      )
          .then((value) async {
        isLoading.value = false;

        Get.snackbar(
          "LOGIN",
          "Successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.greenAccent.withOpacity(0.5),
        );
        Get.offAllNamed(mainScreen);
      }).onError((error, stackTrace) {
        ToastMessage.toastMessage(error.toString());
        debugPrint(error.toString());
        isLoading.value = false;
      });
    }
  }

  void sendPasswordResetEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      Get.snackbar(
        "Password Reset Email Sent",
        "Check your email for password reset instructions.",
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

// void changepasswordDialog(context) {
//     RxBool isLoading = false.obs;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {

//         return AlertDialog(
//           title: const Text('Change Password'),
//           content: Form(
//             key: formKey,
//             child: TextFormField(
//                 controller: useremailController,

//                 decoration: const InputDecoration(
//                   labelText: 'Enter You Email',

//                 ),
//                 validator: validateUsername
//               ),
//             )
//         );
//  } );
//           actions: [
  // TextButton(
  //   onPressed: () {
  //     Navigator.of(context).pop();
  //   },
  //   child: const Text('Cancel'),
  // ),
//             Obx(
//               () => ElevatedButton(
//                 onPressed: () async {
//                   isLoading.value = true;

//                   debugPrint("object");
//                   String oldPassword = oldPasswordController.text;
//                   String newPassword = newPasswordController.text;
//                   if (formKey.currentState!.validate()) {
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

//                         isLoading.value = false;
//                       } catch (e) {
//                         // Handle the case where the old password is incorrect
//                         debugPrint('Error reauthenticating: $e');
//                         Get.snackbar(
//                             "Unsuccessfull", "Enter You Correct Old Password.",
//                             snackPosition: SnackPosition.BOTTOM,
//                             backgroundColor: Colors.red.withOpacity(0.7));

//                         isLoading.value = false;
//                       }
//                     }
//                   }
//                 },
//                 child: isLoading.value
//                     ? const CircularProgressIndicator(
//                         color: Colors.black,
//                       )
//                     : const Text('Save'),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
  void forgotPasswordDialog(context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("Forget Password"),
          content: TextFormField(
            controller: useremailController,
            validator: validateUsername,
            decoration: const InputDecoration(labelText: "Enter your email"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                String email = useremailController.text.trim();
                if (email.isNotEmpty) {
                  sendPasswordResetEmail(email);
                  Get.back();
                }
              },
              child: const Text("Reset Password"),
            ),
          ],
        );
      },
    );
    //  barrierDismissible: false,
  }
}
