// ignore_for_file: must_be_immutable

import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Chats extends StatelessWidget {
  final Space space;
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  Chats({super.key, required this.space});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _extendedSidebarController.hoveredId.value = space.uuid,
      onExit: (_) => _extendedSidebarController.hoveredId.value = '-1',
      child: Obx(
        () => GestureDetector(
          onTap: () => _extendedSidebarController.selectedChat.value = space,
          child: Container(
            height: 70,
            color: _extendedSidebarController.hoveredId.value == space.uuid
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
                Text(space.spaceName),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
