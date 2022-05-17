import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/presentation/home_page/items/item_image_widget.dart';

class OneItem extends StatelessWidget {
  final NftInfoModel nftItem;

  OneItem({required this.nftItem});

  final Radius allBorderRadius = Radius.circular(20);

  @override
  Widget build(BuildContext context) {
    bool isImportant = false;
    // Pick random color for shadow
    Color colors = colorList.elementAt(nftItem.description.length % colorList.length);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(allBorderRadius),
        boxShadow: [buildBoxShadow(context, colors, isImportant)],
      ),
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.all(allBorderRadius),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogBackgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.all(allBorderRadius),
          onTap: onTapAction(nftItem),
          splashColor: colors.withAlpha(20),
          highlightColor: colors.withAlpha(10),
          child: Container(
            // padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ItemImageWidget(
                  titleText: _titleText(_shortenText(nftItem.title, 25), isImportant),
                  nftItem: nftItem,
                  topRadius: allBorderRadius,
                ),
                _normalText("${_shortenText(nftItem.contractAddress, 42)}[${nftItem.tokenId}]"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color, bool isImportant) {
    return BoxShadow(
        color: isImportant == true ? color.withAlpha(80) : color.withAlpha(31),
        blurRadius: 16,
        offset: Offset(0, 8));
  }

  Widget _titleText(String title, bool isImportant) {
    return new Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: isImportant ? FontWeight.w800 : FontWeight.normal),
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

  onTapAction(NftInfoModel nftItem) {
    print("tap" + nftItem.contractAddress);
  }

  String _shortenText(String longText, int limit) {
    return longText.length <= limit ? longText : "${longText.substring(0, limit)}...";
  }
}
