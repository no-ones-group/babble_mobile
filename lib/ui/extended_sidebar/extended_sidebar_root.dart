// ignore_for_file: must_be_immutable

import 'dart:developer';

import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/constants/extended_sidebar_constants.dart';
import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:babble_mobile/ui/extended_sidebar/contact_tile/tiles.dart';
import 'package:babble_mobile/ui/extended_sidebar/extended_sidebar_controller.dart';
import 'package:babble_mobile/ui/root_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ExtendedSidebarRoot extends StatelessWidget {
  final _extendedSidebarController = Get.find<ExtendedSidebarController>();
  int count = 0;
  ExtendedSidebarRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: RootConstants().extendedSidebarWidth,
      height: MediaQuery.of(context).size.height,
      child: Obx(
        () => Scaffold(
          appBar: AppBar(
            toolbarHeight: RootConstants.headerHeight,
            backgroundColor: ExtendedSidebarConstants().headerColor,
            elevation: 0,
            title: Text(
              _extendedSidebarController.titles[
                  _extendedSidebarController.selectedSidebarItemId.value],
            ),
          ),
          body: Container(
            color: ExtendedSidebarConstants().containerColor,
            child: _extendedSidebarController.rootController.pageContent,
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              count += 1;
              UserAPI().createUser(
                User(
                  id: count.toString(),
                  fullName: 'test user $count',
                  displayName: 'test user $count',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
