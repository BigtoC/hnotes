import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/blockchain/models/nft_info_model.dart';
import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';
import 'package:hnotes/infrastructure/blockchain/nft_repository.dart';


class NftInfoBloc {
  final NftRepository _nftRepository = new NftRepository();

  final _blockchainNftData = new PublishSubject<NftInfoModel>();

  Stream<NftInfoModel> get blockchainNftData => _blockchainNftData;

  fetchBlockchainNftData(String contractAddress, int tokenId, String tokenType) async {
    NftMetaDataDto nftMetaDataDto =
        await _nftRepository.getNFTMetadata(contractAddress, tokenId, tokenType);

    String nftImageUrl = nftMetaDataDto.metaData["url"];
    String nftImageName = nftMetaDataDto.tokenUri.raw.split("/").last;
    String nftImageFilePath = await _nftRepository.downloadImage(nftImageUrl, nftImageName);

    NftInfoModel nftInfoModel = new NftInfoModel(
        nftMetaDataDto.title, nftMetaDataDto.description, nftMetaDataDto.contract.address,
        nftMetaDataDto.id.tokenId, nftImageUrl, nftImageFilePath
    );

    _blockchainNftData.sink.add(nftInfoModel);
  }

  void dispose() {
    _blockchainNftData.close();
  }

}
