import 'package:flutter/material.dart';

class MessageSpaceHeader extends StatelessWidget {
  const MessageSpaceHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 60,
      child: Row(
        children: const [
          Icon(
            Icons.account_circle_outlined,
            size: 40,
          ),
          Text(
            'User',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
