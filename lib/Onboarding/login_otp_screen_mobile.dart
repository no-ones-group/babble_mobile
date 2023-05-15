import 'package:babble_mobile/Onboarding/user_details_form.dart';
import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/ui/root.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginOtpScreenMobile extends StatelessWidget {
  final String verificationId;
  final _rootController = Get.find<RootController>();
  final _textEditingController = TextEditingController();
  LoginOtpScreenMobile(this.verificationId, {super.key});

  void verify(BuildContext context) async {
    var nav = Navigator.of(context);
    try {
      var cred = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: _textEditingController.text);
      var userCreds = await FirebaseAuth.instance.signInWithCredential(cred);
      if (userCreds.user != null) {
        (await _rootController.pref)
            .setString('user_id', _rootController.loggedInUserPhoneNumber);
        if (await UserAPI()
            .isUserAlreadyRegistered(_rootController.loggedInUserPhoneNumber)) {
          nav.push(MaterialPageRoute(builder: (context) => Root()));
        } else {
          nav.push(MaterialPageRoute(builder: (context) => UserDetailsForm()));
        }
      }
    } catch (e) {
      nav.push(ModalBottomSheetRoute(
          builder: (context) => const Text('provide otp is incorrect'),
          isScrollControlled: false));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              TextField(
                controller: _textEditingController,
                keyboardType: TextInputType.phone,
                onSubmitted: (value) => verify(context),
              ),
              TextButton(
                onPressed: () => verify(context),
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
