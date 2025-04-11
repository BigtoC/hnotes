import "package:flutter/material.dart";

import "package:hnotes/application/wallet/address_bloc.dart";
import "package:hnotes/domain/blockchain/dtos/address_dto.dart";

class WalletBalancePage extends StatefulWidget {
  final String walletAddress;

  const WalletBalancePage({super.key, required this.walletAddress});

  @override
  State<WalletBalancePage> createState() => _WalletBalancePageState();
}

class _WalletBalancePageState extends State<WalletBalancePage> {
  String? _selectedDenom;
  String? _selectedSymbol;
  double? _selectedBalance;

  @override
  void initState() {
    super.initState();
    addressBloc.getAddressBalances(widget.walletAddress);
  }

  final selectTokenHint = "Please select a token first";

  double parseBalance(CoinWithExponent coin) {
    return BigInt.parse(coin.amount) / BigInt.from(10).pow(coin.exponent);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.walletAddress),
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 10, right: 20),
          child: StreamBuilder<List<CoinWithExponent>>(
            stream: addressBloc.walletBalancesStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No balances found");
              } else {
                return DropdownButtonFormField<CoinWithExponent>(
                  hint: Text("Select a wallet balance"),
                  items:
                      snapshot.data!.map((coin) {
                        final amount = parseBalance(coin);
                        return DropdownMenuItem<CoinWithExponent>(
                          value: coin,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("$amount"),
                              Text(" "),
                              Text(coin.symbol),
                            ],
                          ),
                        );
                      }).toList(),
                  onChanged: (CoinWithExponent? coin) {
                    // Handle selection if needed
                    if (coin != null) {
                      setState(() {
                        _selectedDenom = coin.denom;
                        _selectedSymbol = coin.symbol;
                        _selectedBalance = parseBalance(coin);
                      });
                    }
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
          child: TextFormField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText:
                  _selectedBalance == null ? selectTokenHint : "Enter amount",
              hintText:
                  _selectedDenom == null ? selectTokenHint : "Amount to send",
              border: OutlineInputBorder(),
              suffixText: _selectedSymbol,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter an amount";
              }
              try {
                final amount = double.parse(value);
                if (amount <= 0) {
                  return "Amount must be greater than 0";
                }
                if (_selectedBalance != null && amount > _selectedBalance!) {
                  return "Amount cannot exceed available balance";
                }
                return null;
              } catch (e) {
                return "Please enter a valid number";
              }
            },
            autovalidateMode: AutovalidateMode.onUserInteraction,
          ),
        ),
      ],
    );
  }
}
