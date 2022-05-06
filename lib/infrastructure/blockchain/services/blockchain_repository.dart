import 'dart:async';
import 'package:http/http.dart' as http;

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/blockchain/dto_collections.dart';
import 'package:hnotes/infrastructure/blockchain/services/request_helper.dart';


final requestHeaders = {'Content-type': 'application/json'};


class BlockchainRepository {
  final client = http.Client();

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
    networkNameGlobal = currentNetworkName;

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
    final String requestBody = formRequestBody(methodName);

    return await makeRequest(requestBody)
        .then((response) {
          NumberResultDto dto = NumberResultDto.fromResponse(response, methodName);
          return dto;
    });
  }

  /// For API responses that only contain a text string
  Future<TextResultDto> _parseTextResult(String methodName) async {
    final String requestBody = formRequestBody(methodName);

    return await makeRequest(requestBody)
        .then((response) {
      TextResultDto dto = TextResultDto.fromResponse(response, methodName);
      return dto;
    });
  }
}
