import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import 'package:hnotes/domain/secret/secret_model.dart';
import 'package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart';


class BaseBlockchainRepository {
  final client = http.Client();

  final _requestHeaders = {'Content-type': 'application/json'};
  final SecretRepository _secretRepository = new SecretRepository();

  Future<SecretModel> _readSecrets() async {
    SecretModel _secretModel = await _secretRepository.getApiSecret();
    return _secretModel;
  }

  String formPostRequestBody(String method, [var parameter]) {
    parameter ??= [];

    return jsonEncode({
      "jsonrpc":"2.0",
      "method": method,
      "params": parameter,
      "id": DateTime.now().millisecondsSinceEpoch
    });
  }

  Future<Response> makePostRequest(String requestBody) async {
    SecretModel secret = await _readSecrets();
    return await client.post(
      Uri.parse(secret.urlWithKey),
      headers: _requestHeaders,
      body: requestBody,
    );
  }

  Future<Response> makeGetRequest(String method, [String? parameters]) async {
    SecretModel _secret = await _readSecrets();
    parameters ??= "";
    String baseUrl = "${_secret.urlWithKey}/$method";

    return await client.get(
      Uri.parse("$baseUrl?$parameters"),
      headers: {}
    );
  }

}
