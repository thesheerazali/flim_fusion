import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class SmsCodeScreen extends StatefulWidget {
  SmsCodeScreen({
    super.key,
    required this.verificationId,
    required this.name,
    required this.phone,
    required this.username,
    required this.email,
    required this.password,
  });

  final String verificationId;
  final String name;
  final String phone;
  final String username;
  final String email;
  final String password;

  @override
  _SmsCodeScreenState createState() => _SmsCodeScreenState();
}

class _SmsCodeScreenState extends State<SmsCodeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _smsCodeController = TextEditingController();
 

  Future<void> _verifySmsCode() async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _smsCodeController.text,
    );

    try {
      // Verify the SMS code
      await _auth.signInWithCredential(credential);

      // If verification is successful, register the user
      await FirebaseService().signUpUser(
        email: widget.email,
        password: widget.password,
        name: widget.name,
        phone: widget.phone,
        username: widget.username,
      );

      // Navigate to the login screen
      Get.offNamed(login);
    } catch (e) {
      // Handle verification errors
      // Display an error message to the user
      final snackBar = SnackBar(content: Text('Verification failed: $e'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SMS Code Verification'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter the SMS code sent to '),
            TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'SMS Code',
              ),
            ),
            ElevatedButton(
              onPressed: _verifySmsCode,
              child: Text('Verify Code'),
            ),
          ],
        ),
      ),
    );
  }
}
