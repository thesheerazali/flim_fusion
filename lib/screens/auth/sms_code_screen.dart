import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:film_fusion/constants/routes.dart';
import 'package:film_fusion/db/entity/users.dart';
import 'package:film_fusion/db/services/localdb_services.dart';
import 'package:film_fusion/model/user_model.dart';
import 'package:film_fusion/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _smsCodeController = TextEditingController();
  bool isLoading = false;

  Future<void> _verifySmsCode() async {
    AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: _smsCodeController.text,
    );
    setState(() {
      isLoading = true;
    });

    try {
      // Verify the SMS code
      await _auth.signInWithCredential(credential);

      // If verification is successful, register the user
      await _firestore.collection('users').doc(widget.email).set({
        'name': widget.name,
        'email': widget.email,
        'phone': widget.phone,
        'username': widget.username,
      });

      await (await LocalDbService.usersDao).insertUserProfile(UserProfile(
          name: widget.name,
          username: widget.username,
          email: widget.email,
          phone: widget.phone));

      await _auth.createUserWithEmailAndPassword(
          email: widget.email, password: widget.password);

      // Navigate to the login screen
      Get.offAllNamed(login);
      setState(() {
        isLoading = true;
      });
    } catch (e) {
      // Handle verification errors
      // Display an error message to the user
      final snackBar = SnackBar(content: Text('Verification failed: $e'));
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Get.height * .04),
        child: Column(
          //  mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Get.height * .15,
            ),
            const Text(
              "Verification Code",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const Text(
              "We Texted You a code \nPlease enter it below",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(
              height: Get.height * .2,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: Color(0xFF512DA8),
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
                _smsCodeController.text = code;
                print(_smsCodeController.text);
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                _smsCodeController.text = verificationCode;
                print(_smsCodeController.text);
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Verification Code"),
                        content: Text('Code entered is $verificationCode'),
                      );
                    });
              }, // end onSubmit
            ),
            SizedBox(
              height: Get.height * .1,
            ),
            Center(
              child: InkWell(
                onTap: () => _verifySmsCode(),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black),
                  child: Center(
                      child: isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text(
                              "Verify Code",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400),
                            )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
