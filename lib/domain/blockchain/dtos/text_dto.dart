import "dart:convert";
import "package:http/http.dart" as http;

import "package:hnotes/domain/blockchain/dtos/base_dto.dart";
import "package:hnotes/domain/common_data.dart";

// For response results that only contain a text string
class TextResultDto extends BaseResultDto {
  String? text;

  TextResultDto.fromResponse(http.Response response, String method) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final String result = jsonDecode(response.body)["result"];
      text = result;
    } else {
      final String errorMsg =
          "Query $method failed ($statusCode): ${response.body}";
      logger.e(errorMsg);
      errorMessage = errorMsg;
    }
  }

  Map<String, dynamic> toMap() {
    return {"text": text, "timestamp": timestamp, "errorMessage": errorMessage};
  }
}
