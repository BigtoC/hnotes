import "package:flutter/material.dart";
import "package:cosmos_sdk/cosmos_sdk.dart";
import "dart:convert"; // Add this for JsonEncoder

/// Shows a transaction confirmation dialog to the user
/// Returns true if the user confirms, false otherwise
Future<bool> showTransactionConfirmationDialog({
  required BuildContext context,
  required String fromAddress,
  required List<CosmosMessage> messages,
  required Fee transactionFee,
}) async {
  // Format the fee for display
  final feeCoins = transactionFee.amount;
  final formattedFees = feeCoins.map((coin) {
    final amount = coin.amount;
    final denom = coin.denom;
    return "$amount $denom";
  }).join(", ");

  // Use the built-in toJson() method to display messages in JSON format
  final jsonEncoder = JsonEncoder.withIndent("  ");
  final formattedMessages = messages.map((msg) {
    final msgJson = msg.toJson();
    return jsonEncoder.convert(msgJson);
  }).join("\n\n");

  // Show the dialog and return the result
  return await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm Transaction"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text("From: $fromAddress"),
              SizedBox(height: 8),
              Text("Action:"),
              Container(
                margin: EdgeInsets.only(top: 4, bottom: 8),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[900], // Darker background for better contrast
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[700]!), // Border for definition
                ),
                child: SelectableText( // Make text selectable
                  formattedMessages,
                  style: TextStyle(
                    color: Colors.greenAccent[200], // Code-like text color
                    fontFamily: "monospace", // Monospace font for code display
                    fontSize: 13, // Appropriate size for JSON content
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text("Transaction Fee: $formattedFees"),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          ElevatedButton(
            child: Text("Confirm"),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  ) ?? false; // Return false if dialog is dismissed
}
