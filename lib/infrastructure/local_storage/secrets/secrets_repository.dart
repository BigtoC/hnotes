import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/infrastructure/local_storage/shared_preferences.dart";


class SecretsRepository {
  static final String _secretSharedPrefKey = "apiSecret";

  Future<SecretModel> getApiSecret() async {
    String? storedApiSecret = await getDataFromSharedPref(_secretSharedPrefKey);

    SecretModel secretsModel = SecretModel.fromAttribute(storedApiSecret);

    return secretsModel;
  }

  static void saveApiSecret(String? urlWithKey) {
    if (urlWithKey != null) {
      setDataInSharedPref(_secretSharedPrefKey, urlWithKey);
    }
  }
}
