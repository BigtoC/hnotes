import 'dart:io';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/infrastructure/local_storage/files/nft_file_repository.dart';

class NftFilesBloc {
  NftFileRepository _nftFileRepository = new NftFileRepository();

  final _localNftDataList = new PublishSubject<List<NftInfoModel>>();

  Stream<List<NftInfoModel>> get localNftDataList => _localNftDataList;

  fetchLocalNftData() async {
    String nftDataFolderName = _nftFileRepository.importedDataFolderName;
    List<File> nftDataFiles = await _nftFileRepository.loadAllFilesInFolder(nftDataFolderName);
    List<NftInfoModel> nftInfoModels = [];
    nftDataFiles.forEach((file) {
      nftInfoModels.add(NftInfoModel.fromJson(json.decode(file.readAsStringSync())));
    });

    _localNftDataList.sink.add(nftInfoModels);
  }

  void dispose() {
    _localNftDataList.close();
  }
}

final nftFilesBloc = new NftFilesBloc();
