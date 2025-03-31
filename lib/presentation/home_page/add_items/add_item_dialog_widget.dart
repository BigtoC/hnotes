import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:hnotes/presentation/components/text_field_widget.dart";
import "package:hnotes/domain/blockchain/models/token_type_model.dart";
import "package:hnotes/application/blockchain_info/nft_info_bloc.dart";
import "package:hnotes/presentation/home_page/add_items/dialog_actions_widget.dart";

// ignore: must_be_immutable
class AddItemDialogWidget extends StatelessWidget {
  final BuildContext context;

  AddItemDialogWidget(this.context, {super.key});

  final TextEditingController _contractAddressController =
      TextEditingController();
  final TextEditingController _tokenIdController = TextEditingController();

  final TextInputFormatter _addressFormatter =
      FilteringTextInputFormatter.allow(RegExp("^0x[a-zA-Z0-9]*"));
  final TextInputFormatter _numberFormatter =
      FilteringTextInputFormatter.digitsOnly;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      title: const Text("Import NFT"),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFieldWidget(
              controller: _contractAddressController,
              fieldLabel: "Contract Address",
              hintText: "0x...",
              keyboardType: TextInputType.text,
              formatters: [_addressFormatter],
            ),
            TextFieldWidget(
              controller: _tokenIdController,
              fieldLabel: "Token Id",
              hintText: "Number",
              keyboardType: TextInputType.number,
              formatters: [_numberFormatter],
            ),
          ],
        ),
      ),
      actions: [DialogActionsWidget(handleImportErc721: _handleImport)],
    );
  }

  void _handleImport() async {
    final String contractAddress = _contractAddressController.text;
    final int tokenId = int.parse(_tokenIdController.text);

    await nftInfoBloc.fetchBlockchainNftData(
      contractAddress,
      tokenId,
      TokenType.erc_721.name,
    );
  }
}
