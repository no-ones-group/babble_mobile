import 'package:babble_mobile/constants/root_constants.dart';
import 'package:flutter/material.dart';

class CreateChatSpaceRoot extends StatelessWidget {
  const CreateChatSpaceRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: RootConstants().spaceWidth,
      child: const SizedBox(),
    );
  }
}
