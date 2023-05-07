import 'package:babble_mobile/constants/space_root_constants.dart';
import 'package:flutter/material.dart';

class Glass extends StatelessWidget {
  final Widget child;
  const Glass({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      color: SpaceRootConstants().containerColor.withOpacity(0.7),
      child: Container(
        color: SpaceRootConstants().containerColor.withOpacity(0.7),
        child: child,
      ),
    );
  }
}
