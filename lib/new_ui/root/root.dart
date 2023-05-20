import 'package:babble_mobile/constants/root_constants.dart';
import 'package:babble_mobile/models/space.dart';
import 'package:babble_mobile/new_ui/space/chat_space.dart';
import 'package:babble_mobile/new_ui/space/settings_space.dart';
import 'package:babble_mobile/new_ui/space/user_space.dart';
import 'package:babble_mobile/new_ui/space/widgets/logo.dart';
import 'package:babble_mobile/new_ui/space/widgets/space_profile_picture.dart';
import 'package:babble_mobile/new_ui/root/root_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

class Root extends StatefulWidget {
  Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> with WidgetsBindingObserver {
  final RootController _rootController = Get.find();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        await _rootController.onlineToggle(true);
        await _rootController.refreshUserData();
        break;
      default:
        await _rootController.onlineToggle(false);
        await _rootController.refreshUserData();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Logo(
          withName: true,
          size: LogoSize.medium,
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsSpace()));
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const UserSpace(false, null, null)));
        },
        child: const Icon(Icons.chat),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Stories',
                style: RootConstants.textStyleSubHeader,
              ),
            ),
            SingleChildScrollView(
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.red,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.blue,
                  ),
                  Container(
                    height: 50,
                    width: 50,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                'Chats',
                style: RootConstants.textStyleSubHeader,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _rootController.user.spaces.length,
                itemBuilder: (context, index) {
                  return FutureBuilder(
                    future: _rootController.user.spaces[index].get(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.hasData) {
                        Space space =
                            Space.fromDocumentSnapshotObject(snapshot.data!);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 4),
                          child: ListTile(
                            onTap: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: ((context) => ChatSpace(space)))),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            tileColor: Colors.black12,
                            leading: SpaceProfilePic(
                              space: space,
                            ),
                            title: Text(
                              space.spaceName == ''
                                  ? (_rootController.user.displayName ==
                                          space.displayName1
                                      ? space.displayName2
                                      : space.displayName1)
                                  : space.spaceName,
                              style: RootConstants.textStyleContent,
                            ),
                            subtitle: FutureBuilder(
                              future: space.messagesCollection
                                  .orderBy('sentTime', descending: true)
                                  .limit(1)
                                  .get(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                        ConnectionState.done &&
                                    snapshot.data != null) {
                                  encrypt.Key key =
                                      encrypt.Key.fromBase64(space.key);
                                  encrypt.IV iv =
                                      encrypt.IV.fromBase64(space.iv);
                                  encrypt.Encrypter decrypter =
                                      encrypt.Encrypter(encrypt.AES(key));
                                  return Text(decrypter.decrypt64(
                                      snapshot.data!.docs.first.get('content'),
                                      iv: iv));
                                }
                                return const Text('Send your first text');
                              },
                            ),
                            trailing: Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Text('1'),
                              ),
                            ),
                          ),
                        );
                      }
                      return const CircularProgressIndicator();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
