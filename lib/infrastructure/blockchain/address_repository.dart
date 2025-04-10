import "dart:math";
import "package:hnotes/domain/blockchain/dtos/address_dto.dart";
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
    final symbol = metadata.symbol;
    final exponent = metadata.exponent;
    final amountRaw = balance?.balance?.amount ?? "0";
    final denomRaw = balance?.balance?.denom ?? feeDenom;
    final amount = (int.parse(amountRaw) / pow(10, exponent)).toStringAsFixed(
      metadata.exponent,
    );
    return {
      "address": address,
      "balance": "$amount $symbol",
      "balanceRaw": "$amountRaw $denomRaw",
    };
  }

  Future<List<CoinWithExponent>> fetchAddressBalances(String address) async {
    try {
      final balances = await queryApi.allBalances(address);
      if (balances != null) {
        final metadataFutures =
            balances.balances.map((coin) async {
              final metadata = await fetchSymbolMetadata(coin.denom ?? "");
              return CoinWithExponent(
                denom: coin.denom ?? "",
                amount: coin.amount ?? "0",
                exponent: metadata.exponent,
              );
            }).toList();

        return await Future.wait(metadataFutures);
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<SymbolMetadataDto> fetchSymbolMetadata(String denom) async {
    try {
      final metadata = await queryApi.denomMetadata(feeDenom);
      final display = metadata?.metadata?.display;
      final denomUnit = metadata?.metadata?.denomUnits.firstWhere(
        (unit) => unit.denom == display,
      );
      final exponent = denomUnit?.exponent;
      final symbol = metadata?.metadata?.symbol;

      if (symbol == null || exponent == null) {
        return SymbolMetadataDto(symbol: denom, exponent: 0);
      }

      return SymbolMetadataDto(symbol: symbol, exponent: exponent);
    } catch (e) {
      logger.e("Error fetching symbol metadata: $e");
      return SymbolMetadataDto(symbol: denom, exponent: 0);
    }
  }
}
