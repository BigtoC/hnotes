import 'package:hnotes/util/common_data.dart';

class BaseResultDto {
  String? errorMessage;
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
}
