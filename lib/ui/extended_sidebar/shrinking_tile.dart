// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ShrinkingTile extends StatelessWidget {
  Space? space;
  User? user;
  final _rootController = Get.find<RootController>();
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  ShrinkingTile({super.key, this.space, this.user});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => ListTile(
          contentPadding: const EdgeInsets.fromLTRB(10, 4, 10, 4),
          leading: Container(
            height: 50,
            width: 50,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(
                  _rootController.extendedMenuVisible.value ? 100 : 15),
            ),
            child: user != null && user!.profilePicLink!.isNotEmpty
                ? Image.memory(
                    base64.decode(user!.profilePicLink!),
                    fit: BoxFit.contain,
                  )
                : space != null && space!.spacePic != ''
                    ? Image.memory(
                        base64.decode(space!.spacePic),
                        fit: BoxFit.fill,
                      )
                    : const CircleAvatar(),
          ),
          title: _rootController.extendedMenuVisible.value
              ? Text(user != null ? user!.displayName : space!.spaceName)
              : null,
          onTap: () {
            _rootController.extendedMenuVisible.value =
                !_rootController.extendedMenuVisible.value;
            if (space != null) {
              _extendedSidebarController.selectedChat.value = space!;
            } else {
              _extendedSidebarController.selectedUser.value = user!;
            }
          }),
    );
  }
}
