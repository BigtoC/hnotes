import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/util/share_preferences.dart';
import 'package:hnotes/chain_call/google_crypto/google_crypto_collections.dart';

class ChainCall {
  final client = http.Client();
  RSAPrivateKey privateKey;

  /// Read necessary keys
  readKeys() async {
    String keyString = await rootBundle.loadString(keysFilePath);
    Map<String, dynamic> keysJson = jsonDecode(keyString);

    // String tmpPublicKeyString = await rootBundle.loadString(publicKeyPath);
    // final String publicKeyString = "-----BEGIN PUBLIC KEY-----\n$tmpPublicKeyString\n-----END PUBLIC KEY-----";

    final String privateKeyString = await rootBundle.loadString(privateKeyPath);
    privateKey = keyFromString(privateKeyString);

    String accessId = keysJson["access-id"];
    String myKmsKeyId = keysJson["myKmsKeyId"];
    String accAddress = keysJson["account-address"];
    String tenantid = keysJson["tenantid"];
    String orderId = keysJson["orderId"];
    await new Future.delayed(new Duration(milliseconds: 1000));
    setDataInSharedPref("accessId", accessId);
    setDataInSharedPref("myKmsKeyId", myKmsKeyId);
    setDataInSharedPref("accAddress", accAddress);
    setDataInSharedPref("tenantid", tenantid);
    setDataInSharedPref("orderId", orderId);
  }

  /// Shake hand with blockchain system
  handShake() async {
    await readKeys();

    String accessId = await getDataFromSharedPref("accessId");
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    final String _message = accessId + timestamp;
    List<int> bytesMessage = _message.codeUnits;

    final RS256Signer _signer = new RS256Signer(privateKey);
    final signature = _signer.sign(bytesMessage);
    final String secret = hex.encode(signature);

    final requestBody = jsonEncode({
      "accessId": accessId,
      "time": timestamp,
      "secret": secret
    });

    final response = await client.post(
      "$baasUrl/shakeHand",
      headers: {'Content-type': 'application/json'},
      body: requestBody,
    );
    if (phraseResponseData(response.body, 'code') == "200") {
      String token = phraseResponseData(response.body, 'data');
      setDataInSharedPref('token', token);
    }
    else {
      print("Shake Hand failed: " + response.body);
    }
  }

  /// 查询最新块高
  Future<Map<String, dynamic>> queryLatestBlock() async {
    String token = await getDataFromSharedPref('token');
    String accessId = await getDataFromSharedPref("accessId");

    final requestBody = jsonEncode({
      "bizid": bizid,
      "method": "QUERYLASTBLOCK",
      "accessId": accessId,
      "token": token
    });

    final response = await client.post(
      "$baasUrl/chainCall",
      headers: requestHeaders,
      body: requestBody,
    );

    String statusCode = phraseResponseData(response.body, 'code');

    while (statusCode == "202") {
      await handShake();
      await queryAccount();
    }

    if (statusCode == "200") {
      final data = phraseResponseData(response.body, 'data');
      final blockHeader = jsonDecode(data)["block"]["blockHeader"];
      return blockHeader;
    }
    else {
      final String errorMsg = "Query Block Height failed: " + response.body;
      print(errorMsg);
      return jsonDecode(response.body);
    }
  }

  /// 查询账户
  Future<Map<String, dynamic>> queryAccount() async {
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
      "$baasUrl/chainCall",
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
      print(accountData);
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
      "$baasUrl/chainCallForBiz",
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

