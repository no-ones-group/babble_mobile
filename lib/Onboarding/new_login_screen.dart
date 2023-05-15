import 'package:babble_mobile/Onboarding/new_otp_screen.dart';
import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NewLoginScreen extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  NewLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              'BABBLE',
              style: GoogleFonts.poppins(
                fontSize: 25,
                color: Colors.amber,
                fontWeight: FontWeight.w700,
              ),
            ),
            Column(
              children: [
                const Text(
                  'Phone Number',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: TextField(
                    style: const TextStyle(color: Colors.white),
                    onSubmitted: (value) async {
                      var nav = Navigator.of(context);
                      _rootController.loggedInUserPhoneNumber = value;
                      nav.push(MaterialPageRoute(
                          builder: (context) => NewOTPScreen(value)));
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
