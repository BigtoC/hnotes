import "package:flutter/material.dart";

import "package:hnotes/presentation/home_page/base/dapps_widget.dart";

class SwipeWidget extends StatelessWidget {
  final Widget leftBackground;
  final Widget rightBackground;
  final Radius allBorderRadius;
  final Function(BuildContext context) confirmStartToEnd;
  final Function(BuildContext context) confirmEndToStart;
  final String dAppName;
  final String cardContent;

  const SwipeWidget({
    super.key,
    required this.allBorderRadius,
    required this.confirmStartToEnd,
    required this.confirmEndToStart,
    required this.leftBackground,
    required this.rightBackground,
    required this.dAppName,
    required this.cardContent,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(dAppName),
      background: leftBackground,
      secondaryBackground: rightBackground,
      confirmDismiss: (DismissDirection direction) async {
        if (direction == DismissDirection.startToEnd) {
          confirmStartToEnd(context);
        } else if (direction == DismissDirection.endToStart) {
          confirmEndToStart(context);
        }
        return null;
      },
      dismissThresholds: {
        DismissDirection.startToEnd: 0.3,
        DismissDirection.endToStart: 0.88,
      },
      child: mainContent(),
    );
  }

  Widget mainContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DAppsWidget(
            title: dAppName,
            topRadius: allBorderRadius
        ),
        Container(
          margin: const EdgeInsets.fromLTRB(20, 5, 5, 20),
          child: Text(
              cardContent,
              style: const TextStyle(fontSize: 16)
          ),
        ),
      ],
    );
  }
}
