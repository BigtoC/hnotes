import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/chain_call/google_crypto/google_crypto_collections.dart';


class ChainCallTransaction {
  var client = http.Client();

  String token;
  String accessId;
  String accAddress;
  String myKmsKeyId;
  RSAPrivateKey privateKey;

  ChainCallTransaction({
    this.token,
    this.accessId,
    this.accAddress,
    this.myKmsKeyId,
    this.privateKey,
  });

  factory ChainCallTransaction.getInstance(
    String token,
    String accessId,
    String accAddress,
    String myKmsKeyId,
    RSAPrivateKey privateKey,
    ) {

    return new ChainCallTransaction(
      token: token,
      accessId: accessId,
      accAddress: accAddress,
      myKmsKeyId: myKmsKeyId,
      privateKey: privateKey,
    );
  }


}
