import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/chain_call/google_crypto/google_crypto_collections.dart';

class ChainCallQuery {
  var client = http.Client();

  String token;
  String accessId;
  String accAddress;
  String myKmsKeyId;
  RSAPrivateKey privateKey;

  ChainCallQuery({
    this.token,
    this.accessId,
    this.accAddress,
    this.myKmsKeyId,
    this.privateKey,
  });

  factory ChainCallQuery.getInstance(
    String token,
    String accessId,
    String accAddress,
    String myKmsKeyId,
    RSAPrivateKey privateKey,
    ) {

    return new ChainCallQuery(
      token: token,
      accessId: accessId,
      accAddress: accAddress,
      myKmsKeyId: myKmsKeyId,
      privateKey: privateKey,
    );
  }

  Future<String> queryBlockHeight() async {
    await new Future.delayed(new Duration(milliseconds: 2000));
    final requestBody = jsonEncode({
      "bizid": "a00e36c5",
      "method": "QUERYLASTBLOCK",
      "accessId": "$accessId",
      "token": "$token"
    });

    final response = await client.post(
      "$baasUrl/shakeHand",
      headers: requestHeaders,
      body: requestBody,
    );

    if (phraseStatusCode(response.body) == "200") {
      print(response.body);
      return phraseResponse(response.body);
    }
    else {
      final String errorMsg = "Query Block Height failed: " + response.body;
      print(errorMsg);
      return errorMsg;
    }

  }

}
