// ignore_for_file: must_be_immutable

import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Tiles extends StatelessWidget {
  final User user;
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  Tiles({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _extendedSidebarController.hoveredId.value = user.id,
      onExit: (_) => _extendedSidebarController.hoveredId.value = '-1',
      child: Obx(
        () => GestureDetector(
          onTap: () => _extendedSidebarController.selectedUser.value = user,
          child: Container(
            height: 70,
            color: _extendedSidebarController.hoveredId.value == user.id
                ? Colors.white10
                : Colors.transparent,
            child: Row(
              children: [
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: CircleAvatar(
                    radius: 35,
                  ),
                ),
                Text(user.displayName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
