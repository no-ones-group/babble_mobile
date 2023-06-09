import 'dart:convert';

import 'package:flutter/material.dart';

class ProfilePic extends StatelessWidget {
  final String pic;
  const ProfilePic({super.key, required this.pic});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(5),
        child: pic != ''
            ? Image.memory(base64.decode(pic))
            : Container(
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: const Icon(Icons.account_circle_rounded),
              ),
      ),
    );
  }
}
