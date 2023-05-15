// ignore_for_file: must_be_immutable

import 'package:babble_mobile/api/user_api.dart';
import 'package:babble_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserProfileSpace extends StatelessWidget {
  final User user;
  UserProfileSpace(this.user, {super.key});

  RxBool profilePicPrivacy = false.obs;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: UserAPI().getUser(user.id),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (!snapshot.hasError ||
              (snapshot.hasData && snapshot.data != null)) {
            double radius = MediaQuery.of(context).size.width * 0.25;
            return Scaffold(
              body: Container(
                color: Colors.white10,
                width: 376,
                height: MediaQuery.of(context).size.height,
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: CircleAvatar(
                          backgroundColor: Colors.black12,
                          radius: radius <= 195 ? radius : 195,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Display Name'),
                            Text(snapshot.data!.displayName),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 20,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Full Name'),
                            Text(snapshot.data!.fullName),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                      'Only contacts can see Profile Picture'),
                                  Obx(
                                    () => Switch(
                                      value: profilePicPrivacy.value,
                                      onChanged: (val) =>
                                          profilePicPrivacy.value = val,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        }
        return SizedBox(
          width: 367,
          height: MediaQuery.of(context).size.height,
          child: const Center(
            child: CircularProgressIndicator(
              color: Colors.red,
            ),
          ),
        );
      }),
    );
  }
}
