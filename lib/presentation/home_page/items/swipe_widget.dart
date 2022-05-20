import 'package:flutter/material.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/presentation/home_page/items/item_image_widget.dart';

class SwipeWidget extends StatelessWidget {
  final NftInfoModel nftItem;
  final Widget leftBackground;
  final Widget rightBackground;
  final Radius allBorderRadius;
  final Function(BuildContext context) confirmStartToEnd;
  final Function(BuildContext context) confirmEndToStart;

  SwipeWidget({
    required this.nftItem,
    required this.allBorderRadius,
    required this.confirmStartToEnd,
    required this.confirmEndToStart,
    required this.leftBackground,
    required this.rightBackground
  });

  @override
  Widget build(BuildContext context) {
    return new Dismissible(
      key: Key(nftItem.ipfsHash),
      child: mainContent("${shortenText(nftItem.contractAddress, 42)}[${nftItem.tokenId}]"),
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
      dismissThresholds: {DismissDirection.startToEnd: 0.3, DismissDirection.endToStart: 0.88},
    );
  }

  Widget mainContent(String content) {
    return new Container(
      // padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ItemImageWidget(
            titleText: titleText(shortenText(nftItem.title, 25)),
            nftItem: nftItem,
            topRadius: allBorderRadius,
          ),
          normalText(content),
        ],
      ),
    );
  }

  Widget titleText(String title) {
    return new Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
    );
  }

  Widget normalText(String text) {
    return new Container(
      margin: EdgeInsets.fromLTRB(10, 2, 2, 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  String shortenText(String longText, int limit) {
    return longText.length <= limit ? longText : "${longText.substring(0, limit)}...";
  }
}
