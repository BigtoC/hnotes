import 'dart:async';

import 'package:hnotes/domain/blockchain/dtos/dto_collections.dart';
import 'package:hnotes/infrastructure/blockchain/base_blockchain_repository.dart';


class BlockchainInfoRepository extends BaseBlockchainRepository {

  /// Returns the number of the most recent block.
  Future<Map<String, dynamic>> getLatestBlockNumber() async {
    return (await _parseNumberResultDto("eth_blockNumber")).toMap();
  }

  /// Returns the current price per gas in wei.
  Future<Map<String, dynamic>> getCurrentGasPrice() async {
    return (await _parseNumberResultDto("eth_gasPrice")).toMap();
  }

  /// Returns the current network name.
  Future<Map<String, dynamic>> getNetwork() async {
    final NumberResultDto networkResult = await _parseNumberResultDto("net_version");
    final Map<String, String> networkNames = {
      "1": "Ethereum Mainnet",
      "2": "Morden Testnet (deprecated)",
      "3": "Ropsten Testnet",
      "4": "Rinkeby Testnet",
      "42": "Kovan Testnet"
    };

    final String? currentNetworkName = networkNames[networkResult.number];

    return {
      "text": currentNetworkName,
      "timestamp": networkResult.timestamp,
      "errorMessage": networkResult.errorMessage
    };
  }

  /// Returns the currently configured chain ID
  Future<Map<String, dynamic>> getChainId() async {
    return (await _parseNumberResultDto("eth_chainId")).toMap();
  }

  /// Returns the current client version.
  Future<Map<String, dynamic>> getNodeClientVersion() async {
    return (await _parseTextResult("web3_clientVersion")).toMap();
  }


  /// For API responses that only contain a number (hex or decimal)
  Future<NumberResultDto> _parseNumberResultDto(String methodName) async {
    final String requestBody = formPostRequestBody(methodName);

    return await makePostRequest(requestBody)
        .then((response) {
          NumberResultDto dto = NumberResultDto.fromResponse(response, methodName);
          return dto;
    });
  }

  /// For API responses that only contain a text string
  Future<TextResultDto> _parseTextResult(String methodName) async {
    final String requestBody = formPostRequestBody(methodName);

    return await makePostRequest(requestBody)
        .then((response) {
      TextResultDto dto = TextResultDto.fromResponse(response, methodName);
      return dto;
    });
  }
}
