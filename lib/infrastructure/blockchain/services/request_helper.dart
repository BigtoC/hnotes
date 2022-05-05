import 'dart:convert';
import 'package:http/http.dart';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/infrastructure/blockchain/models/secret_dto.dart';

List defaultParameter = [];
final requestHeaders = {'Content-type': 'application/json'};

String formRequestBody(String method, [var parameter]) {
  parameter ??= defaultParameter;

  return jsonEncode({
    "jsonrpc":"2.0",
    "method": method,
    "params": parameter,
    "id": DateTime.now().millisecondsSinceEpoch
  });
}

Future<SecretDto> _readSecrets() async {
  String secretFileString = await rootBundle.loadString(secretsFilePath);
  final dynamic secretMap = loadYaml(secretFileString);
  return SecretDto.fromYaml(secretMap);
}

Future<Response> makeRequest(String requestBody) async {
  SecretDto secret = await _readSecrets();

  final client = http.Client();

  return await client.post(
    Uri.parse(secret.url),
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
