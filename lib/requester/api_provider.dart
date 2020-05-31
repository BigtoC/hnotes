import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:hnotes/crypto/rsa.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:hnotes/crypto/pem.dart';
import 'package:hnotes/crypto/rsa_sign.dart';
import 'package:hnotes/note_services/note_model.dart';

class NoteApiProvider {
  var client = http.Client();
  final String baasUrl = "https://rest.baas.alipay.com/api/contract";
  final String keysFilePath = "assets/secrets/my-keys.key";
  final String publicKeyPath = "assets/secrets/client.key";
  final String privateKeyPath = "assets/secrets/access.key";
  String accessId = "";
  String clientId = "";
  String myKmsKeyId = "";
  String accAddress = "";
  String publicKeyString;
  String privateKeyString;
  RSAPrivateKey privateKey;

  readKeys() async {
    String keyString = await rootBundle.loadString(keysFilePath);
    Map<String, dynamic> keysJson = jsonDecode(keyString);

    String tmpPublicKeyString = await rootBundle.loadString(publicKeyPath);
    publicKeyString = "-----BEGIN PUBLIC KEY-----\n$tmpPublicKeyString\n-----END PUBLIC KEY-----";
    privateKeyString = await rootBundle.loadString(privateKeyPath);
    privateKey = keyFromString(privateKeyString);

    accessId = keysJson["access-id"];
    myKmsKeyId = keysJson["myKmsKeyId"];
    accAddress = keysJson["account-address"];
  }

  handShake() async {
    await new Future.delayed(new Duration(milliseconds: 650));
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    final String secret = _sign(timestamp);

    final requestBody = jsonEncode({
      "accessId": "$accessId",
      "time": "$timestamp",
      "secret": "$secret"
    });

    final response = await client.post(
      "$baasUrl/shakeHand",
      headers: {'Content-type': 'application/json'},
      body: requestBody,
    );
    print("response.body: ${response.body}");
  }

  String _sign(String timestamp) {
    final String _message = accessId + timestamp;
    List<int> bytesMessage = ascii.encode(_message);
    final RS256Signer _signer = new RS256Signer(privateKey);
    final signature = _signer.sign(bytesMessage);

    final String secret = hex.encode(signature);
    return secret;
  }

  Future<NoteModel> getAllNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    await new Future.delayed(new Duration(milliseconds: 100));
    List<File> tmpList = [];

    directory.list().forEach((element) {
      String fileName = element.path.toString();
      if (fileName.contains(".json")) {
        File aFile = File(fileName);
        tmpList.add(aFile);
      }
    });

    tmpList.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });
    await new Future.delayed(new Duration(milliseconds: 100));
    return NoteModel.fromList(tmpList);
  }

}
