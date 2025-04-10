
class SymbolMetadataDto {
  final String symbol;
  final int exponent;

  SymbolMetadataDto({required this.symbol, required this.exponent});

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "exponent": exponent,
  };

  factory SymbolMetadataDto.fromJson(Map<String, dynamic> json) {
    return SymbolMetadataDto(
      symbol: json["symbol"] as String,
      exponent: json["exponent"] as int,
    );
  }
}

class CoinWithExponent {
  final String denom;
  final String amount;
  final int exponent;

  CoinWithExponent({
    required this.denom,
    required this.amount,
    required this.exponent,
  });

  Map<String, dynamic> toJson() => {
    "denom": denom,
    "amount": amount,
    "exponent": exponent,
  };

  factory CoinWithExponent.fromJson(Map<String, dynamic> json) {
    return CoinWithExponent(
      denom: json["denom"] as String,
      amount: json["amount"] as String,
      exponent: json["exponent"] as int,
    );
  }
}
