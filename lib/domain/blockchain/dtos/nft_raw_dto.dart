class NftRawDto {
  final String name;
  final String description;
  final String url;
  final Map<String, dynamic> rawJson;

  NftRawDto(this.name, this.description, this.url, this.rawJson);

  NftRawDto.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        description = json["description"],
        url = json["url"],
        rawJson = json;
}
