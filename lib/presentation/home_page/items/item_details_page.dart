import 'package:flutter/material.dart';

import 'package:hnotes/presentation/components/page_framework.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';

// ignore: must_be_immutable
class ItemDetailsPage extends StatelessWidget {
  final NftInfoModel nftItem;

  ItemDetailsPage({required this.nftItem});

  @override
  Widget build(BuildContext context) {

    void _handleBack() {
      Navigator.pop(context);
    }

    return new PageFramework(title: nftItem.title, widgets: itemDetails(), handleBack: _handleBack);
  }

  Widget itemDetails() {
    return Container();
  }
}
