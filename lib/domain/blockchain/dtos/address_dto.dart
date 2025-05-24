class SymbolMetadataDto {
  final String symbol;
  final int exponent;

  SymbolMetadataDto({required this.symbol, required this.exponent});

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "exponent": exponent,
  };

  factory SymbolMetadataDto.fromJson(Map<String, dynamic> json) {
    if (json["symbol"] == null || json["exponent"] == null) {
      throw ArgumentError("Missing required fields: symbol or exponent");
    }

    final symbol = json["symbol"];
    final exponent = json["exponent"];

    if (symbol is! String) {
      throw ArgumentError(
          "Expected 'symbol' to be a String, got ${symbol.runtimeType}"
      );
    }

    if (exponent is! int) {
      throw ArgumentError(
          "Expected 'exponent' to be an int, got ${exponent.runtimeType}"
      );
    }

    return SymbolMetadataDto(
      symbol: symbol,
      exponent: exponent,
    );
  }
}

class CoinWithExponent {
  final String denom;
  final String amount;
  final String symbol;
  final int exponent;

  CoinWithExponent({
    required this.denom,
    required this.amount,
    required this.symbol,
    required this.exponent,
  });

  Map<String, dynamic> toJson() => {
    "denom": denom,
    "amount": amount,
    "symbol": symbol,
    "exponent": exponent,
  };

  factory CoinWithExponent.fromJson(Map<String, dynamic> json) {
    if (json["denom"] == null || json["amount"] == null ||
        json["symbol"] == null || json["exponent"] == null) {
      throw ArgumentError(
          "Missing required fields in CoinWithExponent: "
              "denom, amount, symbol, or exponent"
      );
    }

    final denom = json["denom"];
    final amount = json["amount"];
    final symbol = json["symbol"];
    final exponent = json["exponent"];

    if (denom is! String) {
      throw ArgumentError(
          "Expected 'denom' to be a String, got ${denom.runtimeType}"
      );
    }

    if (amount is! String) {
      throw ArgumentError(
          "Expected 'amount' to be a String, got ${amount.runtimeType}"
      );
    }

    if (symbol is! String) {
      throw ArgumentError(
          "Expected 'symbol' to be a String, got ${symbol.runtimeType}"
      );
    }

    if (exponent is! int) {
      throw ArgumentError(
          "Expected 'exponent' to be an int, got ${exponent.runtimeType}"
      );
    }

    if (exponent < 0) {
      throw ArgumentError("'exponent' must be a non-negative integer, got $exponent");
    }

    return CoinWithExponent(
      denom: denom,
      amount: amount,
      symbol: symbol,
      exponent: exponent,
    );
  }
}
