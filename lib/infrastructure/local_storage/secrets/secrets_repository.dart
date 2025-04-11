import "package:blockchain_utils/blockchain_utils.dart";
import "package:hnotes/domain/secret/secret_model.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/infrastructure/local_storage/shared_preferences.dart";

import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";

class SecretsRepository {
  static final String _secretSharedPrefKey = "apiSecret";
  static const String _publicKeyStoreKey = "walletPublicKey";
  static const String _privateKeyStoreKey = "walletPrivateKey";

  Future<SecretModel> getApiSecret() async {
    String? storedApiSecret = await getDataFromSharedPref(_secretSharedPrefKey);

    SecretModel secretsModel = SecretModel.fromAttribute(storedApiSecret);

    return secretsModel;
  }

  Future<String> deriveAndSaveWallet(String privateKeyStr) async {
    await storeKeys(privateKeyStr);
    return await getImportedWalletAddress();
  }

  Bip44 buildBip44(String privateKeyStr) {
    final Bip44 bip44 = Bip44.fromPrivateKey(
      IPrivateKey.fromHex(privateKeyStr, EllipticCurveTypes.secp256k1).raw,
      Bip44Coins.cosmos,
    );
    return bip44;
  }

  Future<CosmosSecp256K1PrivateKey> retrieveSignKey() async {
    final privateKeyStr = await exportPrivateKey();
    final Bip44 bip44 = buildBip44(privateKeyStr);

    return CosmosSecp256K1PrivateKey.fromBytes(bip44.privateKey.raw);
  }

  Future<void> storeKeys(String privateKeyStr) async {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.write(key: _privateKeyStoreKey, value: privateKeyStr);

    final Bip44 bip44 = buildBip44(privateKeyStr);
    final CosmosSecp256K1PublicKey publicKey =
    CosmosSecp256K1PublicKey.fromBytes(bip44.publicKey.compressed);

    await setDataInSharedPref(_publicKeyStoreKey, publicKey.toString());
  }

  Future<String> exportPrivateKey() async {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true)
    );
    final key = await storage.read(key: _privateKeyStoreKey);
    return key ?? "";
  }

  Future<String> getImportedWalletAddress() async {
    final pubKeyHex = await getDataFromSharedPref(_publicKeyStoreKey);
    if (pubKeyHex == null) {
      return "";
    }
    final publicKey = CosmosSecp256K1PublicKey.fromHex(pubKeyHex);
    final cosmosBaseAddress = publicKey.toAddress(hrp: chainWalletPrefix);
    return cosmosBaseAddress.address;
  }
}
