import 'dart:convert';

final String versionNumber = "v1.7.1 beta";

final String baasUrl = "https://rest.baas.alipay.com/api/contract";
final requestHeaders = {'Content-type': 'application/json'};

final String keysFilePath = "assets/secrets/my-keys.key";
final String publicKeyPath = "assets/secrets/client.key";
final String privateKeyPath = "assets/secrets/access.key";

final String queryAccountName = "bigto-hnotes";
final String contractName = "NoteManager";
final String bizid = "a00e36c5";

String globalLoveStartDate = "2019-08-31";
int globalDayCount;


String phraseResponseData(String body, String key) {
  return jsonDecode(body)[key];
}

String phraseInputParamListStr(String contentType, String content, String isImportant) {
  String noteId = new DateTime.now().millisecondsSinceEpoch.toString();
  String date = DateTime.now().toString();
  String owner = "b";

}
