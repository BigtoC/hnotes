class SecretModel {
  String urlWithKey;
  String key;

  SecretModel(this.urlWithKey, this.key);

  factory SecretModel.fromAttribute(String? _urlWithKey) {
    if (_urlWithKey != null && _urlWithKey.isNotEmpty) {
      String _key = _urlWithKey.split("/").last;
      return SecretModel(_urlWithKey, _key);
    } else {
      return SecretModel("", "");
    }
  }
}
