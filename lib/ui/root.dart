// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'dart:io';

import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/sidebar_constants.dart';
import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:babble_mobile/models/message_model.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_root.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_icon.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_root.dart';
import 'package:babble_mobile/ui/space/create_chat_space/create_chat_space_root.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_body.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_footer.dart';
import 'package:babble_mobile/ui/space/message_space/message_space_root.dart';
import 'package:babble_mobile/ui/space/message_space/widgets/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class Root extends StatelessWidget {
  final RootController _rootController =
      Get.put<RootController>(RootController());
  final ExtendedSidebarController _extendedSidebarController =
      Get.find<ExtendedSidebarController>();
  Root({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height,
        color: SidebarConstants().sidebarColor,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SidebarRoot(true, const Duration(milliseconds: 100)),
            ),
            Align(
              alignment: Alignment.center,
              child: ExtendedSidebarRoot(),
            ),
            RootConstants.spaceVisible
                ? Align(
                    alignment: Alignment.centerRight,
                    child: _extendedSidebarController.selectedChat.value ==
                            Space.defaultV1()
                        ? const SizedBox()
                        : MessageSpaceRoot(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}

class RootAndroid extends StatelessWidget {
  final RootController _rootController = Get.find<RootController>();
  final ExtendedSidebarController _extendedSidebarController = Get.find();
  final SidebarController _sidebarController = Get.find();
  final ScrollController _scrollController = ScrollController();
  static Duration animationTime = const Duration(milliseconds: 100);
  RootAndroid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Obx(
            () => Row(
              children: [
                SidebarRoot(
                    _rootController.extendedMenuVisible.value, animationTime),
                AnimatedContainer(
                  duration: animationTime,
                  width: _rootController.extendedMenuVisible.value
                      ? MediaQuery.of(context).size.width - 70
                      : RootConstants.isPlatformMobile
                          ? 0
                          : 70,
                  color: Colors.blue,
                  child: Scaffold(
                    appBar: AppBar(
                      centerTitle: !_rootController.extendedMenuVisible.value,
                      title: _rootController.extendedMenuVisible.value
                          ? Text(_rootController.pageTitle.value)
                          : _rootController.pageTitle.value == 'Chats'
                              ? const Icon(Iconsax.message)
                              : const Text('None'),
                    ),
                    body: _rootController.pageContent,
                  ),
                ),
                Obx(
                  () => AnimatedContainer(
                    duration: animationTime,
                    height: MediaQuery.of(context).size.height,
                    width: !_rootController.extendedMenuVisible.value
                        ? RootConstants.isPlatformMobile
                            ? MediaQuery.of(context).size.width
                            : MediaQuery.of(context).size.width -
                                RootConstants().sidebarWidth
                        : 0,
                    color: Colors.green,
                    child:
                        _sidebarController.selectedSidebarItemId.value == 1 &&
                                _extendedSidebarController.selectedUser.value !=
                                    User.defaultV1()
                            ? CreateChatSpaceRoot(
                                _extendedSidebarController.selectedUser.value)
                            : MessageSpaceBody(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
