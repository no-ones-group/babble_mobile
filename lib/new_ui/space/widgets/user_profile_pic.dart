import 'dart:convert';

import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/new_ui/space/user_profile_space.dart';
import 'package:flutter/material.dart';

class UserProfilePic extends StatelessWidget {
  final User user;
  const UserProfilePic({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => UserProfileSpace(user))),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(5),
        child: user.profilePicLink != null && user.profilePicLink != ''
            ? Image.memory(base64.decode(user.profilePicLink!))
            : Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.account_circle_rounded),
              ),
      ),
    );
  }
}
