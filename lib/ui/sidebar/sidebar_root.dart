import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/constants/sidebar_constants.dart';
import 'package:babble_mobile/ui/extended_sidebar/chat_sidebar/chat_sidebar_root.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_icon.dart';
import 'package:babble_mobile/ui/extended_sidebar/user_sidebar/user_sidebar_root.dart';
import 'package:babble_mobile/ui/space/profile_space/profile_space_root.dart';
import 'package:babble_mobile/ui/space/setting_space/setting_space_root.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';

class SidebarRoot extends StatelessWidget {
  final SidebarController _sidebarController = Get.find<SidebarController>();
  final RootController _rootController = Get.find<RootController>();
  final ExtendedSidebarController _extendedSidebarController =
      Get.find<ExtendedSidebarController>();
  SidebarRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      child: Container(
        padding: const EdgeInsets.all(5),
        width: RootConstants().sidebarWidth,
        color: SidebarConstants().sidebarColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SidebarIcon(
                  id: 0,
                  icon: Iconsax.message,
                  notifIcon: Iconsax.message_notif,
                  onTap: () {
                    _sidebarController.selectedSidebarItemId.value =
                        _extendedSidebarController.selectedSidebarItemId.value =
                            0;
                    _rootController.setPage(ChatSidebarRoot(), 'Chats');
                  },
                  hasNotification: _sidebarController.chatHasNotification.value,
                ),
                SidebarIcon(
                  id: 1,
                  icon: Iconsax.profile_2user,
                  onTap: () {
                    _sidebarController.selectedSidebarItemId.value =
                        _extendedSidebarController.selectedSidebarItemId.value =
                            1;
                    _rootController.setPage(UserSidebarRoot(), 'Users');
                  },
                ),
              ],
            ),
            Column(
              children: [
                SidebarIcon(
                  id: 2,
                  icon: Iconsax.setting,
                  onTap: () {
                    _sidebarController.selectedSidebarItemId.value =
                        _extendedSidebarController.selectedSidebarItemId.value =
                            2;
                    _rootController.setPage(
                        const SettingSpaceRoot(), 'Settings');
                  },
                ),
                SidebarIcon(
                  id: 3,
                  icon: Iconsax.user_square,
                  onTap: () {
                    _sidebarController.selectedSidebarItemId.value =
                        _extendedSidebarController.selectedSidebarItemId.value =
                            3;
                    _rootController.setPage(
                        const ProfileSpaceRoot(), 'Profile Settings');
                  },
                ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
