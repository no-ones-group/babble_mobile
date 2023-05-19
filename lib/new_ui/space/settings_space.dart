import 'package:babble_mobile/Onboarding/login_screen_mobile.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsSpace extends StatelessWidget {
  final _rootController = Get.find<RootController>();
  SettingsSpace({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 75,
            child: ListTile(
              title: const Text('Log Out'),
              onTap: () async {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginScreenMobile()),
                    (route) => route.isCurrent);
                await FirebaseAuth.instance.signOut();
                await (await _rootController.pref).setString('user_id', 'null');
              },
            ),
          ),
        ],
      ),
    );
  }
}
