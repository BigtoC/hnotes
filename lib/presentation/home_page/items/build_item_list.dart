import "package:flutter/material.dart";

import "package:hnotes/application/local_storage/nft_files_bloc.dart";
import "package:hnotes/domain/blockchain/models/nft_info_model.dart";
import "package:hnotes/presentation/home_page/items/one_item_widget.dart";

Future<List<Widget>> buildItemList(Function(List<Widget> aList) setList) async {
  List<Widget> tmpList = [];
  List<NftInfoModel> nftList = await nftFilesBloc.fetchLocalNftData();
  for (var nftItem in nftList) {
    tmpList.add(OneItem(nftItem: nftItem));
  }
  setList(tmpList);
  return tmpList;
}
