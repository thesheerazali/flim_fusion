// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// import 'login_sms_code_screen.dart';

// class PhoneNumberScreen extends StatelessWidget {
//   final TextEditingController _phoneNumberController = TextEditingController();

//   Future<void> _verifyPhoneNumber(BuildContext context) async {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     final String phoneNumber = '+92${_phoneNumberController.text}';

//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       verificationCompleted: (PhoneAuthCredential credential) {},
//       verificationFailed: (FirebaseAuthException e) {
//         print('Verification failed: $e');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SMSCodeScreen(verificationId),
//           ),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {},
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Phone Number Authentication'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _phoneNumberController,
//               keyboardType: TextInputType.phone,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => _verifyPhoneNumber(context),
//               child: Text('Send OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
