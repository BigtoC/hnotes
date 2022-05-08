import 'package:hnotes/domain/secret/secret_model.dart';
import 'package:hnotes/infrastructure/local_storage/shared_preferences.dart';


class SecretRepository {
  static String _secretSharedPrefKey = "apiSecret";

  Future<SecretModel> getApiSecret() async {
    String? _storedApiSecret = await getDataFromSharedPref(_secretSharedPrefKey);

    SecretModel secretsModel = SecretModel.fromAttribute(_storedApiSecret);

    return secretsModel;
  }

  static void saveApiSecret(String? _urlWithKey) {
    if (_urlWithKey != null) {
      setDataInSharedPref(_secretSharedPrefKey, _urlWithKey);
    }
  }
}
