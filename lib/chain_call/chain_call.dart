import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/util/share_preferences.dart';
import 'package:hnotes/chain_call/chain_call_query.dart';
import 'package:hnotes/chain_call/chain_call_transaction.dart';
import 'package:hnotes/chain_call/google_crypto/google_crypto_collections.dart';

class ChainCall {
  final client = http.Client();

  String accessId;
  String accAddress;
  String myKmsKeyId;
  RSAPrivateKey privateKey;
  String token;

  readKeys() async {
    String keyString = await rootBundle.loadString(keysFilePath);
    Map<String, dynamic> keysJson = jsonDecode(keyString);

    String tmpPublicKeyString = await rootBundle.loadString(publicKeyPath);
    final String publicKeyString = "-----BEGIN PUBLIC KEY-----\n$tmpPublicKeyString\n-----END PUBLIC KEY-----";
    final String privateKeyString = await rootBundle.loadString(privateKeyPath);
    privateKey = keyFromString(privateKeyString);

    accessId = keysJson["access-id"];
    myKmsKeyId = keysJson["myKmsKeyId"];
    accAddress = keysJson["account-address"];
  }

  handShake() async {
    await new Future.delayed(new Duration(milliseconds: 1000));
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    final String _message = accessId + timestamp;
    List<int> bytesMessage = ascii.encode(_message);
    final RS256Signer _signer = new RS256Signer(privateKey);
    final signature = _signer.sign(bytesMessage);
    final String secret = hex.encode(signature);

    final requestBody = jsonEncode({
      "accessId": "$accessId",
      "time": "$timestamp",
      "secret": "$secret"
    });

    final response = await client.post(
      "$baasUrl/chainCall",
      headers: {'Content-type': 'application/json'},
      body: requestBody,
    );

    if (phraseStatusCode(response.body) == "200") {
      token = phraseResponse(response.body);
      setTokenInSharedPref(token);
    }
    else {
      print("Shake Hand failed: " + response.body);
    }
  }

  ChainCallTransaction chainCallTx() => ChainCallTransaction.getInstance(
    token, accessId, accAddress, myKmsKeyId, privateKey
  );

  ChainCallQuery chainCallQuery() => ChainCallQuery.getInstance(
    token, accessId, accAddress, myKmsKeyId, privateKey
  );


}

