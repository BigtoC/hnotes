import "dart:io";
import "dart:convert";
import "package:rxdart/rxdart.dart";

import "package:hnotes/domain/blockchain/models/nft_info_model.dart";
import "package:hnotes/infrastructure/local_storage/files/nft_file_repository.dart";

class NftFilesBloc {
  final NftFileRepository _nftFileRepository = NftFileRepository();

  final _localNftDataList = PublishSubject<List<NftInfoModel>>();

  Stream<List<NftInfoModel>> get localNftDataList => _localNftDataList;

  Future<List<NftInfoModel>> fetchLocalNftData() async {
    String nftDataFolderName = _nftFileRepository.importedDataFolderName;
    List<File> nftDataFiles = await _nftFileRepository.loadAllFilesInFolder(
      nftDataFolderName,
    );
    List<NftInfoModel> nftInfoModels = [];
    for (var file in nftDataFiles) {
      NftInfoModel model = NftInfoModel.fromJson(
        json.decode(file.readAsStringSync()),
      );
      nftInfoModels.add(model);
    }

    _localNftDataList.sink.add(nftInfoModels);
    return nftInfoModels;
  }

  Future<void> deleteOneNft(String fileName) async {
    await _nftFileRepository.deleteNftFiles(fileName);
  }

  void dispose() {
    _localNftDataList.close();
  }
}

final nftFilesBloc = NftFilesBloc();
