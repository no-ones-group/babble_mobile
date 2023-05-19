import 'package:babble_mobile/Onboarding/login_otp_screen_mobile.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreenMobile extends StatelessWidget {
  final _textEditingController = TextEditingController();
  final _rootController = Get.find<RootController>();
  LoginScreenMobile({super.key});

  void verify(BuildContext context) async {
    var auth = FirebaseAuth.instance;
    _rootController.loggedInUserPhoneNumber =
        '+91${_textEditingController.text}';
    await auth.verifyPhoneNumber(
      phoneNumber: '+91${_textEditingController.text}',
      verificationCompleted: (_) {},
      verificationFailed: (_) {},
      codeSent: (verificationId, forceResendingToken) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LoginOtpScreenMobile(verificationId)));
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/high-res-white-logo.png',
                height: MediaQuery.of(context).size.width * 0.5,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 20),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: CupertinoTextField(
                    prefix: TextButton(
                      child: Row(
                        children: [
                          Text(
                            '+91',
                            style: GoogleFonts.poppins(
                              color: Colors.cyan,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Container(
                            width: 1,
                            height: 25,
                            color: Colors.cyan,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Column(
                              children: [
                                Text(
                                  'We are really Sorry',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'We only support numbers from India as of now',
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    cursorColor: Colors.cyan,
                    style: GoogleFonts.poppins(
                      color: Colors.cyan,
                      fontSize: 20,
                    ),
                    padding: const EdgeInsets.fromLTRB(0, 10, 15, 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.cyan,
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    controller: _textEditingController,
                    keyboardType: TextInputType.phone,
                    onSubmitted: (value) => verify(context),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => verify(context),
                child: FilledButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.cyan),
                  ),
                  child: Text(
                    'Next',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                    ),
                  ),
                  onPressed: () => verify(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
