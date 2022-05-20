import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/presentation/home_page/items/swipe_widget.dart';
import 'package:hnotes/presentation/home_page/items/swipe_icon_widget.dart';
import 'package:hnotes/presentation/home_page/items/item_details_page.dart';

class OneItem extends StatelessWidget {
  final NftInfoModel nftItem;

  OneItem({required this.nftItem});

  @override
  Widget build(BuildContext context) {
    int tokenId = int.parse(nftItem.tokenId);
    final Radius allBorderRadius = Radius.circular(20);
    String nftIdentifier = "${_shortenText(nftItem.contractAddress, 42)}[$tokenId]";
    // Pick random color for shadow
    Color colors = colorList.elementAt(nftItem.description.length % colorList.length);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(allBorderRadius),
        boxShadow: [buildBoxShadow(context, colors)],
      ),
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(allBorderRadius),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogBackgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.all(allBorderRadius),
          splashColor: colors.withAlpha(20),
          highlightColor: colors.withAlpha(10),
          child: new SwipeWidget(
              nftIdentifier: nftIdentifier,
              nftItem: nftItem,
              allBorderRadius: allBorderRadius,
              leftBackground: new SwipeIconWidget(
                color: Colors.green,
                icon: Icons.content_paste_go,
                text: "Details",
                direction: DismissDirection.startToEnd,
              ),
              rightBackground: new SwipeIconWidget(
                color: Colors.red,
                icon: Icons.delete,
                text: "Delete",
                direction: DismissDirection.endToStart,
              ),
              confirmStartToEnd: confirmStartToEnd,
              confirmEndToStart: confirmEndToStart
          ),
        ),
      ),
    );
  }

  confirmStartToEnd(BuildContext context) {
    Navigator.of(context).push(newPageRoute(ItemDetailsPage(nftItem: nftItem)));
    // Return null so the item won't be dismissed
    return null;
  }

  confirmEndToStart(BuildContext context) {
    return null;
  }

  Route newPageRoute(Widget newPage) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => newPage,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color) {
    return BoxShadow(color: color.withAlpha(31), blurRadius: 16, offset: Offset(0, 8));
  }

  String _shortenText(String longText, int limit) {
    return longText.length <= limit ? longText : "${longText.substring(0, limit)}...";
  }
}
