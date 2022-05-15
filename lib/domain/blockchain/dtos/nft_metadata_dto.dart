class NftMetaDataDto {
  final _Contract contract;
  final _Id id;
  final String title;
  final String description;
  final _TokenUri tokenUri;
  final List<dynamic> media;
  final Map<String, dynamic> metaData;
  final String timeLastUpdated;
  final String? error;

  NftMetaDataDto(
      this.contract, this.id, this.title, this.description, this.tokenUri, this.media,
      this.metaData, this.timeLastUpdated, this.error);

  factory NftMetaDataDto.fromJson(Map<String, dynamic> json) {
    _Contract _contract = _Contract.fromAttribute(json["contract"]["address"]);

    Map idMap = json["id"];
    _Id _id = _Id.fromAttribute(idMap["tokenId"], idMap["tokenMetadata"]["tokenType"]);

    String _title = json["title"];
    String _description = json["description"];

    Map tokenUriMap = json["tokenUri"];
    _TokenUri _tokenUri = _TokenUri.fromAttribute(tokenUriMap["raw"], tokenUriMap["gateway"]);

    List<dynamic> _media = json["media"];

    Map<String, dynamic> _metaDataMap = json["metadata"];

    String _timeLastUpdated = json["timeLastUpdated"];

    String? _error = json["error"];

    return NftMetaDataDto(
        _contract, _id, _title, _description, _tokenUri, _media, _metaDataMap, _timeLastUpdated, _error
    );
  }
}

class _Contract {
  final String address;

  _Contract(this.address);

  factory _Contract.fromAttribute(String _address) {
    return new _Contract(_address);
  }
}

class _Id {
  final String tokenId;
  final String tokenType;

  _Id(this.tokenId, this.tokenType);

  factory _Id.fromAttribute(String _tokenId, String _tokenType) {
    return new _Id(_tokenId, _tokenType);
  }
}

class _TokenUri {
  final String raw;
  final String gateway;

  _TokenUri(this.raw, this.gateway);

  factory _TokenUri.fromAttribute(String _raw, String _gateway) {
    return new _TokenUri(_raw, _gateway);
  }
}
