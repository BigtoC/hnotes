import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/domain/blockchain/dtos/base_dto.dart';


// For response results that only contain one number
class NumberResultDto extends BaseResultDto {
  String? number;
  String? hexNumber;

  NumberResultDto.fromResponse(http.Response response, String method) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final String result = jsonDecode(response.body)["result"];
      if (result.contains("0x")) {
        this.hexNumber = result;
        final String number = int.tryParse(result).toString();
        this.number = number;
      } else {
        this.number = result;
      }
    } else {
      final String errorMsg = "Query $method failed ($statusCode): ${response.body}";
      logger.e(errorMsg);
      this.errorMessage = errorMessage;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "number": this.number,
      "hexNumber": this.hexNumber,
      "timestamp": this.timestamp,
      "errorMessage": this.errorMessage
    };
  }
}
