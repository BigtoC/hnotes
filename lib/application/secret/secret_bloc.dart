import 'package:rxdart/rxdart.dart';

import 'package:hnotes/domain/secret/secret_model.dart';
import 'package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart';


class SecretBloc {
  final _repository = new SecretRepository();

  final _secretModel = new PublishSubject<SecretModel>();

  Stream<SecretModel> get secretModel => _secretModel.stream;

  fetchSecret() async {
    SecretModel _apiSecretModel = await _repository.getApiSecret();

    _secretModel.sink.add(_apiSecretModel);
  }

  void dispose() {
    _secretModel.close();
  }
}

final secretBloc = new SecretBloc();
