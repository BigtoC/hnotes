class SecretDto {
  late String secretKey;
  late String url;

  SecretDto.fromYaml(dynamic file) {
    this.secretKey = file["API_KEY"];
    this.url = file["URL"];
  }
}
