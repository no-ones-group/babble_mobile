import 'dart:developer';

import 'package:babble_mobile/Onboarding/login_screen_mobile.dart';
import 'package:babble_mobile/Onboarding/new_login_screen.dart';
import 'package:babble_mobile/new_ui/root/root.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_controller.dart';
import 'package:babble_mobile/new_ui/root/root.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_controller.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message_conntroller.dart';
import 'package:babble_mobile/ui/space/profile_space/profile_space_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDnQpuJwp9jGOgMjx2WXHKxOSayw2AXOC4',
      appId: '1:830437240435:web:f8903c43f4451e8a04c406',
      messagingSenderId: '',
      projectId: 'babble-8e028',
    ),
  );
  Get.put(RootController());
  Get.put(SidebarController());
  Get.put(ProfileSpaceController());
  Get.put(UserSidebarController());
  Get.put(ExtendedSidebarController());
  Get.put(MessageSpaceController());
  await Future.delayed(const Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Future<bool> get shouldSignIn async {
    var data = await SharedPreferences.getInstance();
    return data.containsKey('user_id');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babble',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: SafeArea(
        child: FutureBuilder<bool>(
          future: shouldSignIn,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data != null && snapshot.data!
                  ? FutureBuilder(
                      future: Future.delayed(const Duration(seconds: 5)),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        return Root();
                      })
                  : kIsWeb
                      ? NewLoginScreen()
                      : LoginScreenMobile();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
