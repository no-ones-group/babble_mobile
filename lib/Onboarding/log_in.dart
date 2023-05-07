// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:babble_mobile/api/authentication_api.dart';
import 'package:babble_mobile/ui/root.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogIn extends StatelessWidget {
  bool shouldShowOTPWindow = false;
  late ConfirmationResult _confirmationResult;
  UserCredential? _userCredential;

  LogIn({super.key});
  final AuthenticationAPI _authentication = AuthenticationAPI();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: const Color.fromARGB(255, 13, 22, 54),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 150.0,
              width: 190.0,
              padding: const EdgeInsets.only(top: 40),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(200),
              ),
              child: Image.asset('assets/babble_logo.png'),
            ),
            SizedBox(
              // <-- SEE HERE
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter valid mail id as abc@gmail.com',
                  ),
                  onSubmitted: (value) async {
                    shouldShowOTPWindow = true;
                    _confirmationResult =
                        await _authentication.signInWeb(value);
                  },
                ),
              ),
            ),
            SizedBox(
              // <-- SEE HERE
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter your secure password',
                  ),
                  onSubmitted: (value) async {
                    _userCredential = await _authentication.verifyOTP(
                        _confirmationResult, value);
                    print(_userCredential!.additionalUserInfo);
                  },
                ),
              ),
            ),
            Container(
              height: 50,
              width: 200,
              color: Colors.blue,
              child: ElevatedButton(
                // onPressed: () {},
                onPressed: (() {
                  if (_userCredential == null) return;
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Root()),
                      (route) => false);
                }),
                // onPressed: () {},
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 130,
            ),
            const Text('New User? Create Account'),
          ],
        ),
      ),
    );
  }
}
