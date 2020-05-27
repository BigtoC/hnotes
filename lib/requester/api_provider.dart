import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:http/http.dart' as http;
import 'package:steel_crypt/steel_crypt.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;

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
  var privateKey;
  var publicKey;

  readKeys() async {
    String keyString = await rootBundle.loadString(keysFilePath);
    Map<String, dynamic> keysJson = jsonDecode(keyString);

    String publicKeyString = await rootBundle.loadString(publicKeyPath);
    await new Future.delayed(new Duration(milliseconds: 200));
    publicKeyString = "-----BEGIN PUBLIC KEY-----\n$publicKeyString\n-----END PUBLIC KEY-----";
    publicKey = RSAKeyParser().parse(publicKeyString);

    final String privateKeyString = await rootBundle.loadString(privateKeyPath);
    privateKey = RSAKeyParser().parse(privateKeyString);
//    privateKey = RsaCrypt().parseKeyFromString(privateKeyString);

    accessId = keysJson["access-id"];

    myKmsKeyId = keysJson["myKmsKeyId"];
    accAddress = keysJson["account-address"];
  }

  handShake() async {
    await new Future.delayed(new Duration(milliseconds: 2000));
    String timestamp = new DateTime.now().millisecondsSinceEpoch.toString();
    String secret = _sign(timestamp);

    final response = await client.post(
      "$baasUrl/shakeHand",
      body: {
        "accessId": accessId,
        "time": timestamp,
        "secret": secret
      }
    );
    print("response.body: ${response.body}");
  }

  String _sign(String timestamp) {
    final String message = accessId + timestamp;
    final signer = Signer(RSASigner(
      RSASignDigest.SHA256, publicKey: publicKey, privateKey: privateKey
    ));

    final String secret = signer.sign(message).base64;

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
