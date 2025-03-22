class SecretModel {
  String urlWithKey;
  String key;

  SecretModel(this.urlWithKey, this.key);

  factory SecretModel.fromAttribute(String? urlWithKey) {
    if (urlWithKey != null && urlWithKey.isNotEmpty) {
      String key = urlWithKey.split("/").last;
      return SecretModel(urlWithKey, key);
    } else {
      return SecretModel("", "");
    }
  }
}
