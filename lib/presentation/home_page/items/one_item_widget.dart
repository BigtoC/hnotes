import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/presentation/home_page/items/item_details_page.dart';
import 'package:hnotes/presentation/home_page/items/item_image_widget.dart';

class OneItem extends StatelessWidget {
  final NftInfoModel nftItem;

  OneItem({required this.nftItem});

  final Radius allBorderRadius = Radius.circular(20);

  @override
  Widget build(BuildContext context) {
    // Pick random color for shadow
    int tokenId = int.parse(nftItem.tokenId);
    Color colors = colorList.elementAt(nftItem.description.length % colorList.length);
    String nftIdentifier = "${_shortenText(nftItem.contractAddress, 42)}[$tokenId]";

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
          child: new Dismissible(
              key: Key(nftIdentifier),
              child: _mainContent(nftIdentifier),
              background: _swipeIcon(Colors.green, Icons.content_paste_go, "Details"),
              secondaryBackground: _swipeIcon(Colors.red, Icons.delete, "Delete"),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.startToEnd) {
                  // Left to right
                  print("Detail");
                } else if (direction == DismissDirection.endToStart) {
                  // Right to left
                  print("Delete");
                }
            },
            confirmDismiss: (DismissDirection direction) async {
              if (direction == DismissDirection.startToEnd) {
                Navigator.of(context).push(_createRoute());
                // Return null so the item won't be dismissed
                return null;
              } else if (direction == DismissDirection.endToStart) {
                // return await showDialog(context: context, builder: (BuildContext context) {
                //
                // });
              }
              return null;
            },
            dismissThresholds: {
              DismissDirection.startToEnd: 0.3,
              DismissDirection.endToStart: 0.88
            },
          ),
        ),
      ),
    );
  }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => ItemDetailsPage(nftItem: nftItem),
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

  Widget _mainContent(String content) {
    return new Container(
      // padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ItemImageWidget(
            titleText: _titleText(_shortenText(nftItem.title, 25)),
            nftItem: nftItem,
            topRadius: allBorderRadius,
          ),
          _normalText(content),
        ],
      ),
    );
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color) {
    return BoxShadow(color: color.withAlpha(31), blurRadius: 16, offset: Offset(0, 8));
  }

  Widget _swipeIcon(Color color, IconData icon, String text) {
    return new Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      alignment: AlignmentDirectional.centerStart,
      color: color,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon),
          Text(text)
        ],
      ),
    );
  }

  Widget _titleText(String title) {
    return new Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
    );
  }

  Widget _normalText(String text) {
    return new Container(
      margin: EdgeInsets.fromLTRB(10, 2, 2, 10),
      child: Text(
        text,
        style: TextStyle(fontSize: 15),
      ),
    );
  }

  String _shortenText(String longText, int limit) {
    return longText.length <= limit ? longText : "${longText.substring(0, limit)}...";
  }
}
