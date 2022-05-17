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

  Stream<NftInfoModel> get blockchainNftData => _blockchainNftData;

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

  void dispose() {
    _blockchainNftData.close();
  }
}

final nftInfoBloc = new NftInfoBloc();
