import "package:hnotes/domain/blockchain/dtos/nft_raw_dto.dart";

class NftMetaDataDto {
  final Contract contract;
  final Id id;
  late String title;
  late String description;
  final TokenUri tokenUri;
  final List<dynamic> media;
  late Map<String, dynamic> metaData;
  final String timeLastUpdated;
  final String? error;
  NftRawDto? nftRawDto;

  NftMetaDataDto(
    this.contract,
    this.id,
    this.title,
    this.description,
    this.tokenUri,
    this.media,
    this.metaData,
    this.timeLastUpdated,
    this.error,
  );

  factory NftMetaDataDto.fromJson(Map<String, dynamic> json) {
    Contract contract = Contract.fromAttribute(json["contract"]["address"]);

    Map idMap = json["id"];
    Id id = Id.fromAttribute(
      idMap["tokenId"],
      idMap["tokenMetadata"]["tokenType"],
    );

    String title = json["title"];
    String description = json["description"];

    Map tokenUriMap = json["tokenUri"];
    TokenUri tokenUri = TokenUri.fromAttribute(
      tokenUriMap["raw"],
      tokenUriMap["gateway"],
    );

    List<dynamic> media = json["media"];

    Map<String, dynamic> metaDataMap = json["metadata"];

    String timeLastUpdated = json["timeLastUpdated"];

    String? error = json["error"];

    return NftMetaDataDto(
      contract,
      id,
      title,
      description,
      tokenUri,
      media,
      metaDataMap,
      timeLastUpdated,
      error,
    );
  }
}

class Contract {
  final String address;

  Contract(this.address);

  factory Contract.fromAttribute(String address) {
    return Contract(address);
  }
}

class Id {
  final String tokenId;
  final String tokenType;

  Id(this.tokenId, this.tokenType);

  factory Id.fromAttribute(String tokenId, String tokenType) {
    return Id(tokenId, tokenType);
  }
}

class TokenUri {
  final String raw;
  final String gateway;

  TokenUri(this.raw, this.gateway);

  factory TokenUri.fromAttribute(String raw, String gateway) {
    return TokenUri(raw, gateway);
  }
}
