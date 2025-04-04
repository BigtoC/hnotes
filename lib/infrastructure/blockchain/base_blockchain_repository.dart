import "dart:async";
import "package:http/http.dart";
import "package:http/http.dart" as http;

import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";


class BaseBlockchainRepository {
  final client = http.Client();

  final SecretsRepository _secretRepository = SecretsRepository();

  Future<SecretModel> _readSecrets() async {
    SecretModel secretModel = await _secretRepository.getApiSecret();
    return secretModel;
  }

  Future<Response> makeGetRequest(String method, [String? parameters]) async {
    SecretModel secret = await _readSecrets();
    parameters ??= "";
    String baseUrl = "${secret.urlWithKey}/$method";

    return await client.get(
      Uri.parse("$baseUrl?$parameters"),
      headers: {}
    );
  }

}
