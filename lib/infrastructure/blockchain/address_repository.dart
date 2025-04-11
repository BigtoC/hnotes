import "dart:convert";
import "dart:math";
import "package:flutter/services.dart";
import "package:hnotes/domain/blockchain/dtos/address_dto.dart";
import "package:mantrachain_dart_sdk/api.dart";

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
    final symbol = metadata?.symbol;
    final exponent = metadata?.exponent ?? 6;
    final amountRaw = balance?.balance?.amount ?? "0";
    final denomRaw = balance?.balance?.denom ?? feeDenom;
    final amount = (int.parse(amountRaw) / pow(10, exponent)).toStringAsFixed(
      exponent,
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
              final metadata = await lookupMetadataFromRegistry(
                coin.denom ?? "",
              );
              if (metadata == null) {
                return null;
              } else {
                return CoinWithExponent(
                  denom: coin.denom ?? "",
                  amount: coin.amount ?? "0",
                  symbol: metadata.symbol,
                  exponent: metadata.exponent,
                );
              }
            }).toList();

        return (await Future.wait(metadataFutures)).nonNulls.toList();
      } else {
        return [];
      }
    } catch (_) {
      return [];
    }
  }

  Future<SymbolMetadataDto?> fetchSymbolMetadata(String denom) async {
    try {
      final metadata = await queryApi.denomMetadataByQueryString(denom: denom);
      final display = metadata?.metadata?.display;
      final denomUnit = metadata?.metadata?.denomUnits.firstWhere(
        (unit) => unit.denom == display,
      );
      final symbol = metadata?.metadata?.symbol ?? "";
      if (denomUnit != null) {
        final exponent = denomUnit.exponent!;
        return SymbolMetadataDto(symbol: symbol, exponent: exponent);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching $denom metadata: $e");
      return SymbolMetadataDto(symbol: denom, exponent: 0);
    }
  }
}

Future<SymbolMetadataDto?> lookupMetadataFromRegistry(String denom) async {
  try {
    final coinLists = [
      "assets/chain-registry/mantrachain-assetlist.json",
      "assets/chain-registry/mantrachaintestnet2-assetlist.json",
    ];

    for (final filePath in coinLists) {
      String jsonString = await rootBundle.loadString(filePath);
      final data = json.decode(jsonString);

      if (data["assets"] != null) {
        for (final asset in data["assets"]) {
          // Check if this asset matches our denom
          if (asset["base"] == denom) {
            // Find the display unit
            final displayDenom = asset["display"];
            final symbol = asset["symbol"] ?? displayDenom;

            // Find the exponent for the display unit
            final denomUnit = asset["denom_units"]?.firstWhere(
              (unit) => unit["denom"] == displayDenom,
              orElse: () => null,
            );

            if (denomUnit != null) {
              return SymbolMetadataDto(
                symbol: symbol,
                exponent: denomUnit["exponent"] ?? 6,
              );
            }
          }
        }
      }
    }
    return null;
  } catch (e) {
    print("Error loading metadata from local registry: $e");
    return null;
  }
}
