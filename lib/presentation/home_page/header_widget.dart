import 'package:flutter/cupertino.dart';

import 'package:hnotes/presentation/theme.dart';


// ignore: must_be_immutable
class HomeHeaderWidget extends StatelessWidget {
  TextStyle _textStyle = TextStyle(
      fontWeight: FontWeight.w700,
      fontSize: 32,
      color: primaryColor
  );

  @override
  Widget build(BuildContext context) {
    // blockchainInfoBloc.fetchNetworkData();
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(
              top: 8, bottom: 19, left: 20 /// 彩蛋
          ),
          width: 200,
          child: Text(
            "ERC-721 Token",
            style: _textStyle,
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
    );
  }
}
