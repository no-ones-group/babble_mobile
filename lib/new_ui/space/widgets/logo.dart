import 'package:babble_mobile/constants/root_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Logo extends StatelessWidget {
  final bool withName;
  final LogoSize size;
  final LogoOrientation orientation;
  const Logo({
    super.key,
    this.withName = false,
    this.size = LogoSize.small,
    this.orientation = LogoOrientation.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        launchUrl(Uri.parse('no-ones-group.github.io'));
      },
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.only(right: 5),
            height: size == LogoSize.small
                ? 25
                : size == LogoSize.medium
                    ? 50
                    : 100,
            width: size == LogoSize.small
                ? 25
                : size == LogoSize.medium
                    ? 50
                    : 100,
            child: Image.asset('assets/high-res-white-logo.png'),
          ),
          withName
              ? Text(
                  'Babble',
                  style: RootConstants.textStyleHeader,
                )
              : const SizedBox(),
        ],
      ),
    );
  }
}

enum LogoOrientation {
  horizontal,
  vertical,
}

enum LogoSize {
  small,
  medium,
  large,
}
