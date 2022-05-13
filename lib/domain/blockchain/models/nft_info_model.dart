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

  NftInfoModel.fromData(NftMetaDataDto dto, String imageFilePath)
      : title = dto.title,
        description = dto.description,
        contractAddress = dto.contract.address,
        tokenId = dto.id.tokenId,
        imageUrl = dto.metaData["url"],
        imageFilePath = imageFilePath;

  NftInfoModel.fromJson(Map<String, dynamic> json)
      : title = json["title"],
        description = json["description"],
        contractAddress = json["contractAddress"],
        tokenId = json["tokenId"],
        imageUrl = json["imageUrl"],
        imageFilePath = json["imageFilePath"];

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "contractAddress": contractAddress,
        "tokenId": tokenId,
        "imageUrl": imageUrl,
        "imageFilePath": imageFilePath
      };
}
