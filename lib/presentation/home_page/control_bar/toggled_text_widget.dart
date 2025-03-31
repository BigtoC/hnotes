import "package:flutter/cupertino.dart";

import "package:hnotes/presentation/theme.dart";

// ignore: must_be_immutable
class ImportantIndicatorText extends StatelessWidget {
  final bool isFlagOn;

  const ImportantIndicatorText({super.key, required this.isFlagOn});

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Center(
        child: Text(
          "Only showing notes marked important".toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            color: btnColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      secondChild: Container(height: 1),
      crossFadeState:
          isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }
}
