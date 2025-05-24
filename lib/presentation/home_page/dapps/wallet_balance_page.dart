import "dart:math";

import "package:flutter/material.dart";

import "package:hnotes/application/wallet/address_bloc.dart";
import "package:hnotes/application/wallet/wallet_bloc.dart";
import "package:hnotes/domain/blockchain/dtos/address_dto.dart";
import "package:hnotes/infrastructure/constants.dart";
import "package:hnotes/presentation/theme.dart";
import "package:hnotes/presentation/home_page/dapps/tx_status_widget.dart";

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
  int _selectedExponent = 6;
  final TextEditingController _sendAmountController = TextEditingController();
  final TextEditingController _receiverAddressController =
      TextEditingController();
  bool _isTransactionInProgress = false;

  @override
  void initState() {
    super.initState();
    addressBloc.getAddressBalances(widget.walletAddress);
  }

  @override
  void dispose() {
    _sendAmountController.dispose();
    _receiverAddressController.dispose();
    super.dispose();
  }

  final selectTokenHint = "Please select a token first";

  double parseBalance(CoinWithExponent coin) {
    return BigInt.parse(coin.amount) / BigInt.from(10).pow(coin.exponent);
  }

  Future<void> sendToken() async {
    if (_selectedDenom == null
        || _sendAmountController.text.isEmpty
        || _receiverAddressController.text.isEmpty
    ) {
      return;
    }

    setState(() {
      _isTransactionInProgress = true;
    });

    print(
      "Sending ${_sendAmountController.text} $_selectedSymbol to "
      "${_receiverAddressController.text}",
    );

    final amount = BigInt.from(
      double.parse(_sendAmountController.text) * pow(10, _selectedExponent),
    );

    try {
      final txHash = await walletBloc.sendToken(
        widget.walletAddress,
        amount,
        _selectedDenom!,
        _receiverAddressController.text,
      );

      if (!mounted) return;

      setState(() {
      });

      // Use a function to handle transaction status to avoid context issues
      if (txHash == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Transaction failed"), backgroundColor: Colors.red
          ),
        );
        return;
      } else {
        _showTransactionStatusDialog(txHash);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text("Error sending transaction: $e"),
            backgroundColor: Colors.red
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTransactionInProgress = false;
        });
      }
    }
  }

  void _showTransactionStatusDialog(String txHash) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Text("Transaction Status"),
        content: SizedBox(
          width: 300,
          height: 200,
          child: TxStatusWidget(
            txHash: txHash,
            onComplete: (success) {
              // Use a function that captures the current dialogContext
              _handleTransactionComplete(dialogContext, success);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _handleCLoseDialog(dialogContext),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _handleCLoseDialog(BuildContext dialogContext) {
    // First close the dialog
    Navigator.of(dialogContext).pop();

    // Reset the state in the next frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        // Reset the form state
        setState(() {
          _selectedDenom = null;
          _selectedSymbol = null;
          _selectedBalance = null;
          _selectedExponent = 6;
          _sendAmountController.clear();
          _receiverAddressController.clear();
        });

        // Then refresh balances after state is cleared
        addressBloc.getAddressBalances(widget.walletAddress);
      }
    });
  }

  void _handleTransactionComplete(BuildContext dialogContext, bool success) {
    // Show success or failure message
    ScaffoldMessenger.of(dialogContext).showSnackBar(
      SnackBar(
        content: Text(
            success
                ? "Transaction confirmed successfully!"
                : "Transaction failed"
        ),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
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
                return DropdownButtonFormField<String>(
                  value: _selectedDenom,
                  hint: Text("Select a token"),
                  items: snapshot.data!.map((coin) {
                    final amount = parseBalance(coin);
                    return DropdownMenuItem<String>(
                      value: coin.denom,
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
                  onChanged: (String? denom) {
                    if (denom != null) {
                      final selectedCoin = snapshot.data!.firstWhere(
                        (coin) => coin.denom == denom,
                        orElse: () => snapshot.data!.first,
                      );
                      setState(() {
                        _selectedDenom = denom;
                        _selectedSymbol = selectedCoin.symbol;
                        _selectedExponent = selectedCoin.exponent;
                        _selectedBalance = parseBalance(selectedCoin);
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
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _sendAmountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText:
                      _selectedBalance == null
                          ? selectTokenHint
                          : "Enter amount",
                  hintText:
                      _selectedDenom == null
                          ? selectTokenHint
                          : "Amount to send",
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
                    if (_selectedBalance != null &&
                        amount > _selectedBalance!) {
                      return "Amount cannot exceed available balance";
                    }
                    return null;
                  } catch (e) {
                    return "Please enter a valid number";
                  }
                },
                autovalidateMode: AutovalidateMode.onUserInteraction,
              ),
              Container(height: 30),
              TextFormField(
                controller: _receiverAddressController,
                decoration: InputDecoration(
                  labelText:
                      _selectedBalance == null
                          ? selectTokenHint
                          : "Enter receiver address",
                  hintText:
                      _selectedDenom == null
                          ? selectTokenHint
                          : "${chainAddressPrefix}1...",
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a receiver address";
                  }
                  if (!value.startsWith(chainAddressPrefix)) {
                    return "Invalid address";
                  }
                  return null;
                },
              ),
              Container(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: sendToken,
                  style: ElevatedButton.styleFrom(backgroundColor: btnColor),
                  child: _isTransactionInProgress ?
                    SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2
                        )) :
                    Text(
                      "Send",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
