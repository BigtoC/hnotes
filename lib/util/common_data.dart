import 'dart:convert';

final String baasUrl = "https://rest.baas.alipay.com/api/contract";
final requestHeaders = {'Content-type': 'application/json'};

final String keysFilePath = "assets/secrets/my-keys.key";
final String publicKeyPath = "assets/secrets/client.key";
final String privateKeyPath = "assets/secrets/access.key";


String phraseResponse(String body) {
  return jsonDecode(body)['data'];
}

String phraseStatusCode(String body) {
  return jsonDecode(body)['code'];
}