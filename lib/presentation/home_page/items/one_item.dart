import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';

class OneItem extends StatelessWidget {
  final NftInfoModel nftItem;

  OneItem({required this.nftItem});

  @override
  Widget build(BuildContext context) {
    bool isImportant = false;
    // Pick random color for shadow
    Color colors = colorList.elementAt(nftItem.description.length % colorList.length);
    String title = nftItem.title;
    String titleText = title.length <= 20 ? title : "${title.substring(0, 20)}...";
    print(titleText);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [buildBoxShadow(context, colors, isImportant)],
      ),
      padding: EdgeInsets.all(10),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogBackgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTapAction(nftItem),
          splashColor: colors.withAlpha(20),
          highlightColor: colors.withAlpha(10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _titleText(titleText, isImportant),

              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color, bool isImportant) {
    return BoxShadow(
        color: isImportant == true ? color.withAlpha(80) : color.withAlpha(20),
        blurRadius: 8,
        offset: Offset(0, 6));
  }

  Widget _titleText(String title, bool isImportant) {
    return new Text(
      title,
      style: TextStyle(
          fontSize: 20,
          fontWeight: isImportant ? FontWeight.w800 : FontWeight.normal
      ),
    );
  }

  onTapAction(NftInfoModel nftItem) {
    print(nftItem.contractAddress);
  }
}
