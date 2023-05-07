import 'package:babble_mobile/Onboarding/new_login_screen.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_controller.dart';
import 'package:babble_mobile/ui/root.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_controller.dart';
import 'package:babble_mobile/ui/space/profile_space/profile_space_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

enum Configuration {
  debug,
  profile,
  release,
}

late Configuration configuration;

void main() async {
  String env = const String.fromEnvironment("env", defaultValue: "debug");
  configuration = env == "debug" ? Configuration.debug : Configuration.profile;
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: 'AIzaSyDnQpuJwp9jGOgMjx2WXHKxOSayw2AXOC4',
      appId: '1:830437240435:web:f8903c43f4451e8a04c406',
      messagingSenderId: '',
      projectId: 'babble-8e028',
    ),
  );
  Get.put<RootController>(RootController());
  Get.put<SidebarController>(SidebarController());
  Get.put<ProfileSpaceController>(ProfileSpaceController());
  Get.put<UserSidebarController>(UserSidebarController());
  Get.put<ExtendedSidebarController>(ExtendedSidebarController());
  Get.put<MessageSpaceController>(MessageSpaceController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babble',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: SafeArea(
        child: Get.find<RootController>().isUserLoggedIn()
            ? Root()
            : NewLoginScreen(),
      ),
    );
  }
}
