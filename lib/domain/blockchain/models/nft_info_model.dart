import 'package:hnotes/domain/blockchain/dtos/nft_metadata_dto.dart';


class NftInfoModel {
  final String title;
  final String description;
  final String contractAddress;
  final String tokenId;
  final String imageUrl;
  final String imageFilePath;

  NftInfoModel(this.title, this.description, this.contractAddress, this.tokenId, this.imageUrl,
      this.imageFilePath);

  factory NftInfoModel.fromDto(NftMetaDataDto dto, String imageFilePath) {
    return new NftInfoModel(dto.title, dto.description, dto.contract.address, dto.id.tokenId,
        dto.metaData["url"], imageFilePath);
  }
}
