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
    await storePrivateKey(privateKeyStr);
    return deriveAddress(privateKeyStr);
  }

  Bip44 buildBip44(String privateKeyStr) {
    final Bip44 bip44 = Bip44.fromPrivateKey(
      IPrivateKey.fromHex(privateKeyStr, EllipticCurveTypes.secp256k1).raw,
      Bip44Coins.cosmos,
    );
    return bip44;
  }

  Future<String> deriveAddress(String privateKeyStr) async {
    final Bip44 bip44 = buildBip44(privateKeyStr);
    final CosmosSecp256K1PublicKey publicKey =
        CosmosSecp256K1PublicKey.fromBytes(bip44.publicKey.compressed);

    final walletAddress = publicKey.toAddress(hrp: chainWalletPrefix);
    await setDataInSharedPref(_publicKeyStoreKey, walletAddress.address);
    return walletAddress.address;
  }

  CosmosSecp256K1PrivateKey buildPrivateKey(String privateKeyStr) {
    final Bip44 bip44 = buildBip44(privateKeyStr);

    return CosmosSecp256K1PrivateKey.fromBytes(bip44.privateKey.raw);
  }

  Future<void> storePrivateKey(String privateKeyStr) async {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true)
    );
    await storage.write(key: _privateKeyStoreKey, value: privateKeyStr);
  }

  Future<String> exportPrivateKey() async {
    final storage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true)
    );
    final key = await storage.read(key: _privateKeyStoreKey);
    return key ?? "";
  }

  Future<String> getImportedWalletAddress() async {
    final address = await getDataFromSharedPref(_publicKeyStoreKey);
    return address ?? "";
  }
}
