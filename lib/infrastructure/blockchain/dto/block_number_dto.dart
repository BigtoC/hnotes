import 'package:http/http.dart' as http;

import 'package:hnotes/infrastructure/blockchain/request_helper.dart';

class BlockNumberDto {
  String? blockNumber;
  String? errorMessage;

  BlockNumberDto.fromResponse(http.Response response) {
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      final result = phraseResponseData(response.body, "result");
      final String latestBlockNumber = int.tryParse(result).toString();
      this.blockNumber = latestBlockNumber;
    }
    else {
      final String errorMsg = "Query latest block failed ($statusCode): ${response.body}";
      print(errorMsg);
      this.errorMessage = errorMessage;
    }
  }

  Map <String, dynamic> toMap() {
    return {
      "blockNumber": this.blockNumber,
      "errorMessage": this.errorMessage
    };
  }
}
