import 'dart:async';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/infrastructure/blockchain/models/dto_collections.dart';
import 'package:hnotes/infrastructure/blockchain/services/request_helper.dart';


final requestHeaders = {'Content-type': 'application/json'};


class BlockchainRepository {
  final client = http.Client();

  /// Read necessary keys
  readKeys() async {
    String secretFileString = await rootBundle.loadString(secretsFilePath);
    final dynamic secretMap = loadYaml(secretFileString);
    SecretDto secret = SecretDto.fromYaml(secretMap);
  }

  // Returns the number of the most recent block.
  Future<Map<String, dynamic>> getLatestBlockNumber() async {
    return (await _getNumberResultDto("eth_blockNumber")).toMap();
  }

  // Returns the current price per gas in wei.
  Future<Map<String, dynamic>> getCurrentGasPrice() async {
    return (await _getNumberResultDto("eth_gasPrice")).toMap();
  }

  // Returns the current network name.
  Future<Map<String, dynamic>> getNetwork() async {
    final NumberResultDto networkResult = await _getNumberResultDto("net_version");
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

  // For API responses that only contain a number (hex or decimal)
  Future<NumberResultDto> _getNumberResultDto(String methodName) async {
    final String requestBody = formRequestBody(methodName);

    return await makeRequest(requestBody)
        .then((response) {
          NumberResultDto dto = NumberResultDto.fromResponse(response, methodName);
          return dto;
    });
  }

  // For API responses that only contain a text string
  Future<TextResultDto> _getTextResult(String methodName) async {
    final String requestBody = formRequestBody(methodName);

    return await makeRequest(requestBody)
        .then((response) {
      TextResultDto dto = TextResultDto.fromResponse(response, methodName);
      return dto;
    });
  }

}

