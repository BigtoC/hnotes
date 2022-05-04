import 'dart:async';
import 'dart:convert';
import 'package:yaml/yaml.dart';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/util/share_preferences.dart';
import 'package:hnotes/infrastructure/blockchain/request_helper.dart';
import 'package:hnotes/infrastructure/blockchain/dto/dto_collections.dart';


final requestHeaders = {'Content-type': 'application/json'};


class BlockchainRepository {
  final client = http.Client();

  /// Read necessary keys
  readKeys() async {
    String secretFileString = await rootBundle.loadString(secretsFilePath);
    final dynamic secretMap = loadYaml(secretFileString);
    SecretDto secret = SecretDto.fromYaml(secretMap);
  }

  /// Shake hand with blockchain system
  handShake() async {
    await readKeys();
    throw Exception("Not implemented yet");

  }

  /// Returns the number of the most recent block.
  Future<Map<String, dynamic>> queryLatestBlock() async {

    final String requestBody = formRequestBody("eth_blockNumber");

    return await makeRequest(requestBody)
        .then((response) {
          BlockNumberDto dto =  BlockNumberDto.fromResponse(response);
          return dto.toMap();
        });
  }

  /// 查询账户
  Future<Map<String, dynamic>> queryAccount() async {
    throw Exception("Not implemented yet");
    String token = await getDataFromSharedPref('token');
    String accessId = await getDataFromSharedPref("accessId");

    final requestBody = jsonEncode({
      "bizid": bizid,
      "method": "QUERYACCOUNT",
      "requestStr": "{'queryAccount': '$queryAccountName'}",
      "accessId": accessId,
      "token": token
    });

    final response = await client.post(
      Uri.parse("$baasUrl/chainCall"),
      headers: requestHeaders,
      body: requestBody,
    );

    String statusCode = phraseResponseData(response.body, 'code');

    while (statusCode == "202") {
      await handShake();
      await queryAccount();
    }

    if (statusCode == "200") {
      final accountData = phraseResponseData(response.body, 'data');
      return jsonDecode(accountData);
    }
    else {
      final String errorMsg = "Query Block Height failed: " + response.body;
      print(errorMsg);
      return jsonDecode(response.body);
    }
  }

  /// Upload note content data to blockchain
  Future<bool> uploadNoteDataToChain(String inputParamListStr) async {
    throw Exception("Not implemented yet");
    String orderId = await getDataFromSharedPref('orderId');
    String myKmsKeyId = await getDataFromSharedPref("myKmsKeyId");
    String accessId = await getDataFromSharedPref("accessId");
    String token = await getDataFromSharedPref('token');
    String tenantid = await getDataFromSharedPref('tenantid');

    final requestBody = jsonEncode({
      "orderId": orderId,
      "bizid": bizid,
      "account": queryAccountName,
      "contractName": contractName,
      "methodSignature": "get()",
      "mykmsKeyId": myKmsKeyId,
      "method": "CALLCONTRACTBIZASYNC",
      "inputParamListStr": inputParamListStr,
      "outTypes": "[]",
      "accessId": accessId,
      "token": token,
      "gas": 10000000,
      "tenantid": tenantid
    });

    final response = await client.post(
      Uri.parse("$baasUrl/chainCallForBiz"),
      headers: requestHeaders,
      body: requestBody,
    );

    String statusCode = phraseResponseData(response.body, 'code');

    while (statusCode == "202") {
      handShake();
      await uploadNoteDataToChain(inputParamListStr);
    }

    if (statusCode == "200") {
      return true;
    }
    else {
      final String errorMsg = "Upload Note failed: " + response.body;
      print(errorMsg);
      return false;
    }

  }

  /// Modify the existing note content data
  updateNoteContent(String noteId) async {

  }

  /// Query all my transactions
  queryAllNotes() async {

  }

}

