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

  const SwipeWidget({super.key, 
    required this.nftItem,
    required this.allBorderRadius,
    required this.confirmStartToEnd,
    required this.confirmEndToStart,
    required this.leftBackground,
    required this.rightBackground
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(nftItem.ipfsHash),
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
      child: mainContent(shortenText(nftItem.description, 50)),
    );
  }

  Widget mainContent(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ItemImageWidget(
          nftItem: nftItem,
          topRadius: allBorderRadius,
        ),
        normalText(content),
      ],
    );
  }

  Widget normalText(String text) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 2, 2, 10),
      child: Text(
        text,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  String shortenText(String longText, int limit) {
    return longText.length <= limit ? longText : "${longText.substring(0, limit)}...";
  }
}
