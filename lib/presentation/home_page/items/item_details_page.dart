import 'package:flutter/material.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/presentation/components/page_header_widget.dart';

// ignore: must_be_immutable
class ItemDetailsPage extends StatelessWidget {
  final NftInfoModel nftItem;

  ItemDetailsPage({required this.nftItem});

  @override
  Widget build(BuildContext context) {

    void _handleBack() {
      Navigator.of(context).pop(false);
    }

    return new Scaffold(
      body: new ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            new Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: _handleBack,
                      child: Container(
                        padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                        child: const Icon(Icons.arrow_back),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                      child: new PageHeaderWidget(title: nftItem.title),
                    ),
                    itemDetails(),
                  ],
                )
            )
          ]
      ),
    );
  }

  Widget itemDetails() {
    return Container();
  }
}
