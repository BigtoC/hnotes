import "package:rxdart/rxdart.dart";

import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";


class SecretBloc {
  final _repository = SecretRepository();

  final _secretModel = PublishSubject<SecretModel>();

  Stream<SecretModel> get secretModel => _secretModel.stream;

  fetchSecret() async {
    SecretModel apiSecretModel = await _repository.getApiSecret();

    _secretModel.sink.add(apiSecretModel);
  }

  void dispose() {
    _secretModel.close();
  }
}

final secretBloc = SecretBloc();
