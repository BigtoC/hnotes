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

String? networkNameGlobal = "";

String globalLoveStartDate = "";
int globalDayCount = 0;
