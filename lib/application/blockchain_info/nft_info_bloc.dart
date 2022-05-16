import 'dart:io';
import 'dart:convert';
import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';
import 'package:hnotes/infrastructure/blockchain/nft_repository.dart';
import 'package:hnotes/infrastructure/local_storage/files/nft_file_repository.dart';

class NftInfoBloc {
  final NftRepository _nftRepository = new NftRepository();
  NftFileRepository _nftFileRepository = new NftFileRepository();

  final _blockchainNftData = new PublishSubject<NftInfoModel>();
  final _localNftDataList = new PublishSubject<List<NftInfoModel>>();

  Stream<NftInfoModel> get blockchainNftData => _blockchainNftData;

  Stream<List<NftInfoModel>> get localNftDataList => _localNftDataList;

  fetchBlockchainNftData(String contractAddress, int tokenId, String tokenType) async {
    NftMetaDataDto nftMetaDataDto =
        await _nftRepository.getNFTMetadata(contractAddress, tokenId, tokenType);

    String nftImageUrl = nftMetaDataDto.metaData["url"];
    String nftImageName = nftMetaDataDto.tokenUri.raw.split("/").last;
    String nftImageFilePath = await _nftRepository.downloadImage(nftImageUrl, nftImageName);

    NftInfoModel nftInfoModel = NftInfoModel.fromData(nftMetaDataDto, nftImageFilePath);

    _blockchainNftData.sink.add(nftInfoModel);

    String nftModelJson = json.encode(nftInfoModel.toJson());
    String nftJsonFileName = nftImageName;

    _nftFileRepository.saveStringFile(nftModelJson, "$nftJsonFileName.json");
  }

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
    _blockchainNftData.close();
    _localNftDataList.close();
  }
}

final nftInfoBloc = new NftInfoBloc();
