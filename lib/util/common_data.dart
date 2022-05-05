import 'package:logger/logger.dart';
import 'package:package_info_plus/package_info_plus.dart';

PackageInfo packageInfo = PackageInfo(
  appName: 'Unknown',
  packageName: 'Unknown',
  version: 'Unknown',
  buildNumber: 'Unknown',
  buildSignature: 'Unknown',
);

var logger = Logger(printer: PrettyPrinter());

final String baasUrl = "https://rest.baas.alipay.com/api/contract";

final String secretsFilePath = "assets/secrets/secret.yaml";

late String? networkNameGlobal;

String globalLoveStartDate = "";
int globalDayCount = 0;


String phraseInputParamListStr(String contentType, String content, String isImportant) {
  String noteId = new DateTime.now().millisecondsSinceEpoch.toString();
  String date = DateTime.now().toString();
  String owner = "b";
  String status = "1";
  String inputParamListStr = "[$noteId, $date, $owner, $contentType, $content, $isImportant, $status]";
  return inputParamListStr;
}
