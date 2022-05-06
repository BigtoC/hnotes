import 'package:http/http.dart' as http;

import 'base_dto.dart';
import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/infrastructure/blockchain/services/request_helper.dart';


// For response results that only contain a text string
class TextResultDto extends BaseResultDto {
  String? text;

  TextResultDto.fromResponse(http.Response response, String method) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final String result = phraseResponseData(response.body, "result");
      this.text = result;
    } else {
      final String errorMsg = "Query $method failed ($statusCode): ${response.body}";
      logger.e(errorMsg);
      this.errorMessage = errorMessage;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "text": this.text,
      "timestamp": this.timestamp,
      "errorMessage": this.errorMessage
    };
  }
}
