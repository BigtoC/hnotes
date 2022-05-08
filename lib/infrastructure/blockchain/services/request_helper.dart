import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:hnotes/domain/secret/secret_model.dart';
import 'package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart';


List defaultParameter = [];
final requestHeaders = {'Content-type': 'application/json'};
final String secretsFilePath = "assets/secret/secret.yaml";
final SecretRepository _secretRepository = new SecretRepository();

String formRequestBody(String method, [var parameter]) {
  parameter ??= defaultParameter;

  return jsonEncode({
    "jsonrpc":"2.0",
    "method": method,
    "params": parameter,
    "id": DateTime.now().millisecondsSinceEpoch
  });
}

Future<SecretModel> _readSecrets() async {
  SecretModel _secretModel = await _secretRepository.getApiSecret();

  return _secretModel;
}

Future<Response> makeRequest(String requestBody) async {
  SecretModel secret = await _readSecrets();

  final client = http.Client();

  return await client.post(
    Uri.parse(secret.urlWithKey),
    headers: requestHeaders,
    body: requestBody,
  );

}

String phraseResponseData(String body, String key) {
  return jsonDecode(body)[key];
}

bool phraseResponseBooleanData(String body, String key) {
  return jsonDecode(body)[key];
}
