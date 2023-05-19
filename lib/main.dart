
import 'package:babble_mobile/Onboarding/login_screen_mobile.dart';
import 'package:babble_mobile/Onboarding/new_login_screen.dart';
import 'package:babble_mobile/new_ui/root/root.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:babble_mobile/new_ui/space/user_space_controller.dart';
import 'package:encrypt/encrypt.dart' as Encrypt;
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
  Get.put(UserSpaceController());
  final iv = Encrypt.IV.fromSecureRandom(16);
  Encrypt.Key key = Encrypt.Key.fromSecureRandom(32);
  Encrypt.Encrypter encrypter = Encrypt.Encrypter(Encrypt.AES(key));
  Encrypt.Encrypted encrypted = encrypter.encrypt('Hello', iv: iv);
  print(encrypted.base64);
  print(encrypter.decrypt(encrypted, iv: iv));

  await Future.delayed(const Duration(seconds: 2));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static Future<bool> get shouldSignIn async {
    var data = await SharedPreferences.getInstance();
    if (data.containsKey('user_id')) {
      if (data.getString('user_id') != 'null') {
        return false;
      }
    }
    return true;
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
              return snapshot.data != null && !snapshot.data!
                  ? Root()
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
