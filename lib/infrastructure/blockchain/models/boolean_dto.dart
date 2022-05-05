import 'dart:core';

import 'package:http/http.dart' as http;

import 'base_dto.dart';
import 'package:hnotes/util/common_data.dart';
import 'package:hnotes/infrastructure/blockchain/services/request_helper.dart';


// For response results that only contain a text string
class BooleanResultDto extends BaseResultDto {
  bool? boolean;

  BooleanResultDto.fromResponse(http.Response response, String method) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final bool result = phraseResponseBooleanData(response.body, "result");
      this.boolean = result;
    } else {
      final String errorMsg = "Query $method failed ($statusCode): ${response.body}";
      logger.e(errorMsg);
      this.errorMessage = errorMessage;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "boolean": this.boolean,
      "timestamp": this.timestamp,
      "errorMessage": this.errorMessage
    };
  }
}
