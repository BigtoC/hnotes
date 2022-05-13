import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AddItemDialogWidget extends StatelessWidget {
  final BuildContext context;

  AddItemDialogWidget(this.context);

  TextEditingController _contractAddressController = TextEditingController();
  TextEditingController _tokenIdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Import NFT"),

      actions: [
        TextButton(
          child: const Text("Cancel"),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: const Text("Import"),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
  
} 