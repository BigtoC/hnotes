import 'dart:io';
import 'package:flutter/material.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';

class ItemImageWidget extends StatelessWidget {
  final NftInfoModel nftItem;
  final Radius topRadius;

  ItemImageWidget({required this.nftItem, required this.topRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(bottom: 5),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: topRadius, bottom: Radius.zero), // Image border
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(rect.width, rect.height, 0, 0));
                },
                blendMode: BlendMode.dstIn,
                child: Image.file(
                  File(nftItem.imageFilePath),
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                margin: EdgeInsets.all(10),
                child: titleText("${nftItem.title} #${nftItem.tokenId}"),
              ),
            ],
          ),
        ));
  }

  Widget titleText(String title) {
    return new Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
    );
  }
}
