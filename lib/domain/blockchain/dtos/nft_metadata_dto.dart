import 'package:hnotes/domain/blockchain/dtos/nft_raw_dto.dart';

class NftMetaDataDto {
  final _Contract contract;
  final _Id id;
  late String title;
  late String description;
  final _TokenUri tokenUri;
  final List<dynamic> media;
  late Map<String, dynamic> metaData;
  final String timeLastUpdated;
  final String? error;
  NftRawDto? nftRawDto;

  NftMetaDataDto(this.contract, this.id, this.title, this.description, this.tokenUri, this.media,
      this.metaData, this.timeLastUpdated, this.error);

  factory NftMetaDataDto.fromJson(Map<String, dynamic> json) {
    _Contract contract = _Contract.fromAttribute(json["contract"]["address"]);

    Map idMap = json["id"];
    _Id id = _Id.fromAttribute(idMap["tokenId"], idMap["tokenMetadata"]["tokenType"]);

    String title = json["title"];
    String description = json["description"];

    Map tokenUriMap = json["tokenUri"];
    _TokenUri tokenUri = _TokenUri.fromAttribute(tokenUriMap["raw"], tokenUriMap["gateway"]);

    List<dynamic> media = json["media"];

    Map<String, dynamic> metaDataMap = json["metadata"];

    String timeLastUpdated = json["timeLastUpdated"];

    String? error = json["error"];

    return NftMetaDataDto(contract, id, title, description, tokenUri, media, metaDataMap,
        timeLastUpdated, error);
  }
}

class _Contract {
  final String address;

  _Contract(this.address);

  factory _Contract.fromAttribute(String address) {
    return _Contract(address);
  }
}

class _Id {
  final String tokenId;
  final String tokenType;

  _Id(this.tokenId, this.tokenType);

  factory _Id.fromAttribute(String tokenId, String tokenType) {
    return _Id(tokenId, tokenType);
  }
}

class _TokenUri {
  final String raw;
  final String gateway;

  _TokenUri(this.raw, this.gateway);

  factory _TokenUri.fromAttribute(String raw, String gateway) {
    return _TokenUri(raw, gateway);
  }
}
