import "dart:math";

import "package:cosmos_sdk/cosmos_sdk.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";
import "package:mantrachain_dart_sdk/api.dart";

class WalletRepository {
  final SecretsRepository _secretRepository = SecretsRepository();
  final queryApi = QueryApi(ApiClient(basePath: chainRestUrl));

  fetchAddressAndBalance() async {
    final address = await _secretRepository.getImportedWalletAddress();
    final balance = await queryApi.balance(address, denom: feeDenom);
    final metadata = await fetchSymbolMetadata(feeDenom);
    final symbol = metadata["symbol"];
    final exponent = metadata["exponent"];
    final amountRaw = balance?.balance?.amount ?? "0";
    final denomRaw = balance?.balance?.denom ?? feeDenom;
    final amount = (int.parse(amountRaw) / pow(10, exponent)).toStringAsFixed(
      metadata["exponent"] ?? 0,
    );
    return {
      "address": address,
      "balance": "$amount $symbol",
      "balanceRaw": "$amountRaw $denomRaw",
    };
  }

  fetchSymbolMetadata(String denom) async {
    final metadata = await queryApi.denomMetadata(feeDenom);
    final display = metadata?.metadata?.display;
    final denomUnit = metadata?.metadata?.denomUnits.firstWhere(
      (unit) => unit.denom == display,
    );
    final exponent = denomUnit?.exponent;
    final symbol = metadata?.metadata?.symbol;
    return {"symbol": symbol, "exponent": exponent};
  }
}
