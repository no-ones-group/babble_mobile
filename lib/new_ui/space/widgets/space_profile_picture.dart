import 'dart:convert';

import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/new_ui/space/space_profile_space.dart';
import 'package:flutter/material.dart';

class SpaceProfilePic extends StatelessWidget {
  final Space space;
  const SpaceProfilePic({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => SpaceProfileSpace(
                space,
              ))),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(5),
        child: space.spacePic != ''
            ? Image.memory(base64.decode(space.spacePic))
            : Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.account_circle_rounded),
              ),
      ),
    );
  }
}
