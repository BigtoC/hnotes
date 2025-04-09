import "dart:math";
import "package:mantrachain_dart_sdk/api.dart";

import "package:hnotes/domain/common_data.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/infrastructure/local_storage/secrets/secrets_repository.dart";

class AddressRepository {
  final SecretsRepository _secretRepository = SecretsRepository();
  final queryApi = QueryApi(ApiClient(basePath: chainRestUrl));

  fetchAddressAndBalance() async {
    final address = await _secretRepository.getImportedWalletAddress();
    if (address == "") {
      return {"address": ""};
    }
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

  Future<List<Coin>> fetchAddressBalances(String address) async {
    try {
      final balances = await queryApi.allBalances(address);
      if (balances != null) {
        return balances.balances;
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  fetchSymbolMetadata(String denom) async {
    try {
      final metadata = await queryApi.denomMetadata(feeDenom);
      final display = metadata?.metadata?.display;
      final denomUnit = metadata?.metadata?.denomUnits.firstWhere(
        (unit) => unit.denom == display,
      );
      final exponent = denomUnit?.exponent;
      final symbol = metadata?.metadata?.symbol;
      return {"symbol": symbol, "exponent": exponent};
    } catch (e) {
      logger.e("Error fetching symbol metadata: $e");
      return {"symbol": denom, "exponent": 0};
    }
  }
}
