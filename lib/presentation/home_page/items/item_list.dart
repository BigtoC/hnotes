import 'package:flutter/material.dart';

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/home_page/items/one_item.dart';
import 'package:hnotes/presentation/components/loading_circle.dart';
import 'package:hnotes/application/local_storage/nft_files_bloc.dart';
import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';

// ignore: must_be_immutable
class ItemList extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => _ItemList();

}

class _ItemList extends State<ItemList> {
  @override
  void initState() {
    super.initState();
    nftFilesBloc.fetchLocalNftData();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: nftFilesBloc.localNftDataList,
      builder: (context, AsyncSnapshot<List<NftInfoModel>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return LoadingCircle();
          case ConnectionState.active:
            return new ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data?.length,
                itemBuilder: (_, index) {
                  NftInfoModel nftItem = snapshot.data![index];
                  return new OneItem(nftItem: nftItem);
                }
            );
          case ConnectionState.none:
            return Container();
          case ConnectionState.done:
            logger.i("Finish rendering");
            break;
        }
        return SizedBox();
      },
    );
  }

}
