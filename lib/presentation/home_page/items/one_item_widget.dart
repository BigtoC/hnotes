import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/application/local_storage/nft_files_bloc.dart';
import 'package:hnotes/presentation/home_page/items/swipe_widget.dart';
import 'package:hnotes/presentation/home_page/items/swipe_icon_widget.dart';
import 'package:hnotes/presentation/home_page/items/item_details_page.dart';

class OneItem extends StatelessWidget {
  final NftInfoModel nftItem;

  const OneItem({super.key, required this.nftItem});

  @override
  Widget build(BuildContext context) {
    final Radius allBorderRadius = Radius.circular(20);
    // Pick random color for shadow
    int randomNumber = nftItem.description.length + nftItem.title.length;
    Color colors = colorList.elementAt(randomNumber % colorList.length);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(allBorderRadius),
        boxShadow: [buildBoxShadow(context, colors)],
      ),
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(allBorderRadius),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogTheme.backgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.all(allBorderRadius),
          splashColor: colors.withAlpha(20),
          highlightColor: colors.withAlpha(10),
          child: SwipeWidget(
              nftItem: nftItem,
              allBorderRadius: allBorderRadius,
              leftBackground: SwipeIconWidget(
                color: Colors.green,
                icon: Icons.content_paste_go,
                text: "Details",
                direction: DismissDirection.startToEnd,
              ),
              rightBackground: SwipeIconWidget(
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

  confirmEndToStart(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text("Delete NFT?"),
            children: <Widget>[
              SimpleDialogOption(
                child: const Text(
                  "Delete",
                  style: TextStyle(color: Colors.redAccent),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  nftFilesBloc.deleteOneNft(nftItem.ipfsHash);
                  return;
                },
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.lightBlue),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  return;
                },
              ),
            ],
          );
        });
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
}
