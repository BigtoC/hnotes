import "dart:math";

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
  @override
  void initState() {
    super.initState();
    addressBloc.getAddressBalances(widget.walletAddress);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(widget.walletAddress),
        StreamBuilder<List<CoinWithExponent>>(
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
                      final amount =
                          int.parse(coin.amount) /
                          (pow(10, coin.exponent).toDouble());
                      return DropdownMenuItem<CoinWithExponent>(
                        value: coin,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [Text("$amount"), Text(coin.symbol)],
                        ),
                      );
                    }).toList(),
                onChanged: (CoinWithExponent? value) {
                  // Handle selection if needed
                },
              );
            }
          },
        ),
      ],
    );
  }
}
