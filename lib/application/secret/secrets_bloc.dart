import "package:rxdart/rxdart.dart";

import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";


class SecretsBloc {
  final _secretsRepository = SecretsRepository();

  final _secretModel = PublishSubject<SecretModel>();
  final _walletAddress = PublishSubject<String>();

  Stream<SecretModel> get secretModel => _secretModel.stream;
  Stream<String> get walletAddressStream => _walletAddress.stream;

  fetchSecret() async {
    SecretModel apiSecretModel = await _secretsRepository.getApiSecret();

    _secretModel.sink.add(apiSecretModel);
  }

  Future<String?> exportPrivateKey() async {
    return await _secretsRepository.exportPrivateKey();
  }

  Future<String> importPrivateKey(String value) async {
    return await _secretsRepository.deriveAndSaveWallet(value);
  }

  getImportedWalletAddress() async {
    _walletAddress.sink.add(await _secretsRepository.getImportedWalletAddress());
  }

  void dispose() {
    _secretModel.close();
    _walletAddress.close();
  }
}

final secretsBloc = SecretsBloc();
