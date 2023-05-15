import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/root.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDetailsForm extends StatelessWidget {
  UserDetailsForm({super.key});
  final _displayNameTEController = TextEditingController();
  final _fullNameTEController = TextEditingController();
  final _rootController = Get.find<RootController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            style: GoogleFonts.poppins(),
            decoration: const InputDecoration(hintText: 'Display Name'),
            controller: _displayNameTEController,
          ),
          TextField(
            style: GoogleFonts.poppins(),
            decoration: const InputDecoration(hintText: 'Full Name'),
            controller: _fullNameTEController,
          ),
          TextButton(
            onPressed: () async {
              var nav = Navigator.of(context);
              nav.popUntil((route) => true);
              User user = User(
                id: _rootController.loggedInUserPhoneNumber,
                fullName: _fullNameTEController.text,
                displayName: _displayNameTEController.text,
              );
              var isRegistered =
                  (await UserAPI().isUserAlreadyRegistered(user.id));
              if (!isRegistered) {
                UserAPI().createUser(user);
              }
              await nav.push(MaterialPageRoute(builder: ((context) => Root())));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
