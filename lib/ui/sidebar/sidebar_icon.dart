import 'package:babble_mobile/constants/sidebar_constants.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:babble_mobile/ui/sidebar/sidebar_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:heroicons/heroicons.dart';

class SidebarIcon extends StatelessWidget {
  final int id;
  final IconData? icon;
  final IconData? notifIcon;
  final HeroIcons? heroIcon;
  final HeroIcons? notifHeroIcon;
  final void Function()? onTap;
  final bool hasNotification;
  final SidebarController _sidebarController = Get.find<SidebarController>();
  final RootController _rootController = Get.find<RootController>();
  SidebarIcon(
      {super.key,
      required this.id,
      this.icon,
      this.notifIcon,
      this.heroIcon,
      this.notifHeroIcon,
      this.onTap,
      this.hasNotification = false});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _sidebarController.hoveredId.value = id,
      onExit: (_) => _sidebarController.hoveredId.value = -1,
      child: GestureDetector(
        onTap: onTap,
        child: Obx(
          () => Container(
            margin: const EdgeInsets.only(bottom: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: _sidebarController.selectedSidebarItemId.value == id ||
                      _sidebarController.hoveredId.value == id
                  ? SidebarConstants().sidebarIconEventBGColor
                  : SidebarConstants().sidebarIconBGColor,
            ),
            child: SizedBox(
              width: SidebarConstants().sidebarIconSize,
              height: SidebarConstants().sidebarIconSize,
              child: Center(
                child: icon == null
                    ? HeroIcon(
                        hasNotification ? notifHeroIcon! : heroIcon!,
                        color: _sidebarController.selectedSidebarItemId.value ==
                                    id ||
                                _sidebarController.hoveredId.value == id
                            ? SidebarConstants().sidebarIconEventColor
                            : SidebarConstants().sidebarIconColor,
                      )
                    : Icon(
                        hasNotification ? notifIcon! : icon!,
                        color: _sidebarController.selectedSidebarItemId.value ==
                                    id ||
                                _sidebarController.hoveredId.value == id
                            ? SidebarConstants().sidebarIconEventColor
                            : SidebarConstants().sidebarIconColor,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
