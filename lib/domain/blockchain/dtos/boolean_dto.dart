import 'dart:core';
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'base_dto.dart';
import 'package:hnotes/domain/common_data.dart';


// For response results that only contain a text string
class BooleanResultDto extends BaseResultDto {
  bool? boolean;

  BooleanResultDto.fromResponse(http.Response response, String method) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final bool result = jsonDecode(response.body)["result"];
      boolean = result;
    } else {
      final String errorMsg = "Query $method failed ($statusCode): ${response.body}";
      logger.e(errorMsg);
      errorMessage = errorMessage;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      "boolean": boolean,
      "timestamp": timestamp,
      "errorMessage": errorMessage
    };
  }
}
