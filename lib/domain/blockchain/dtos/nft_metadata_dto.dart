class NftMetaDataDto {
  final _Contract contract;
  final _Id id;
  final _TokenUri tokenUri;
  final List<Map<String, dynamic>> media;
  final _MetaData metaData;
  final String timeLastUpdated;
  final String? error;

  NftMetaDataDto(
      this.contract, this.id, this.tokenUri, this.media, this.metaData, this.timeLastUpdated,
      this.error
      );

  factory NftMetaDataDto.fromJson(Map<String, dynamic> json) {
    _Contract _contract = _Contract.fromAttribute(json["contract"]["address"]);

    Map idMap = json["id"];
    _Id _id = _Id.fromAttribute(idMap["tokenId"], idMap["tokenMetadata"]["tokenType"]);

    Map tokenUriMap = json["tokenUri"];
    _TokenUri _tokenUri = _TokenUri.fromAttribute(tokenUriMap["raw"], tokenUriMap["gateway"]);

    List<Map<String, dynamic>> _media = json["media"];

    Map metaDataMap = json["metadata"];
    _MetaData _metaData = _MetaData.fromAttribute(
        metaDataMap["image"], metaDataMap["externalUrl"], metaDataMap["name"],
        metaDataMap["description"], metaDataMap["tag"], metaDataMap["backgroundColor"],
        metaDataMap["attributes"], metaDataMap["coven"]
    );

    String _timeLastUpdated = json["timeLastUpdated"];

    String? _error = json["error"];

    return NftMetaDataDto(_contract, _id, _tokenUri, _media, _metaData, _timeLastUpdated, _error);
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

class _MetaData {
  final String image;
  final String externalUrl;
  final String name;
  final String description;

  String? tag;
  String? backgroundColor;
  List? attributes;
  Map<String, dynamic>? coven;

  _MetaData(this.image, this.externalUrl, this.name, this.description, this.tag,
      this.backgroundColor, this.attributes, this.coven);

  factory _MetaData.fromAttribute(
      String _image,
      String _externalUrl,
      String _name,
      String _description,
      String? _tag,
      String? _backgroundColor,
      List? _attributes,
      Map<String, dynamic>? _coven) {
    return new _MetaData(
        _image, _externalUrl, _name, _description, _tag, _backgroundColor, _attributes, _coven);
  }
}
