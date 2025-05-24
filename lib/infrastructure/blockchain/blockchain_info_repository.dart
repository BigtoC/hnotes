import "dart:async";

import "package:hnotes/infrastructure/constants.dart";
import "package:mantrachain_dart_sdk/api.dart";

class BlockchainInfoRepository {
  // REST clients
  final queryApi = QueryApi(ApiClient(basePath: chainRestUrl));
  final serviceApi = ServiceApi(ApiClient(basePath: chainRestUrl));

  Future<Map<String, String>> fetchNodeInfo() async {
    final nodeInfo = await serviceApi.getNodeInfo();
    final String version = nodeInfo?.applicationVersion?.version ?? "";
    final String chainName = nodeInfo?.applicationVersion?.name ?? "";
    final String chainId = nodeInfo?.defaultNodeInfo?.network ?? "";
    final String goVersion = nodeInfo?.applicationVersion?.goVersion ?? "";
    final cosmosSdkVersion =
        nodeInfo?.applicationVersion?.cosmosSdkVersion ?? "";
    return {
      "version": version,
      "chainName": chainName,
      "chainId": chainId,
      "goVersion": goVersion,
      "cosmosSdkVersion": cosmosSdkVersion,
    };
  }

  /// Returns the number of the most recent block.
  Future<Map<String, String>> fetchLatestBlockInfo() async {
    final latestBLockInfo = await serviceApi.getLatestBlock();
    final String blockNumber = latestBLockInfo?.block?.header?.height ?? "0";
    final String blockTime =
        latestBLockInfo?.block?.header?.time?.toLocal().toIso8601String() ?? "";
    return {"blockNumber": blockNumber, "blockTime": blockTime};
  }

  Future<Map<String, String>> fetchGasPrice() async {
    final GasPrices200Response? gasPrice = await queryApi.gasPrices();
    final price = gasPrice?.prices.firstOrNull;
    final double? gasPriceValue = double.tryParse(price?.amount ?? "0.01");
    final String denom = price?.denom ?? feeDenom;
    return {
      "gasPrice": "$gasPriceValue $denom",
      "amount": gasPriceValue.toString(),
      "denom": denom
    };
  }
}
