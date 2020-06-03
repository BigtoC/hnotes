import 'dart:convert';

final String baasUrl = "https://rest.baas.alipay.com/api/contract";
final requestHeaders = {'Content-type': 'application/json'};

final String keysFilePath = "assets/secrets/my-keys.key";
final String publicKeyPath = "assets/secrets/client.key";
final String privateKeyPath = "assets/secrets/access.key";
final String queryAccountName = "bigto-hnotes";


String phraseResponseData(String body, String key) {
  return jsonDecode(body)[key];
}