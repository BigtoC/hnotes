import "package:flutter/cupertino.dart";

import "package:hnotes/presentation/theme.dart";

// ignore: must_be_immutable
class HomeHeaderWidget extends StatelessWidget {
  final TextStyle _textStyle = TextStyle(
    fontWeight: FontWeight.w700,
    fontSize: 32,
    color: primaryColor,
  );

  HomeHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // blockchainInfoBloc.fetchNetworkData();
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 8, bottom: 19, left: 20),
          width: MediaQuery.of(context).size.width * 0.88,
          child: Text(
            "dApps",
            style: _textStyle,
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
