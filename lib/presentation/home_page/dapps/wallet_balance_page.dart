import "package:flutter/material.dart";

import "package:hnotes/application/wallet/address_bloc.dart";

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
    addressBloc.getAddressAndBalance();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[Text(widget.walletAddress)],
    );
  }
}
