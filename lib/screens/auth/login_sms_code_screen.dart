import 'package:film_fusion/constants/routes.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SMSCodeScreen extends StatelessWidget {
  final String verificationId;
  final TextEditingController _smsCodeController = TextEditingController();

  SMSCodeScreen(this.verificationId);

  Future<void> _signInWithPhoneNumber(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: _smsCodeController.text,
    );

    try {
      await _auth.signInWithCredential(credential);
      // Authentication successful, navigate to next screen.
      // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
      Get.offNamed(mainScreen);
    } catch (e) {
      print('Sign in failed: $e');
      // Handle sign-in failure here.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter SMS Code'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _smsCodeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'SMS Code'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _signInWithPhoneNumber(context),
              child: Text('Verify'),
            ),
          ],
        ),
      ),
    );
  }
}
