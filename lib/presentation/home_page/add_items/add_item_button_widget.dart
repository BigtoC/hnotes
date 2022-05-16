import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/presentation/home_page/add_items/add_item_dialog_widget.dart';

class AddItemButton extends StatelessWidget {
  final bool isExtend;

  AddItemButton({required this.isExtend});

  @override
  Widget build(BuildContext context) {
    return isExtend ? _addItemButtonExtend(context) : _addItemButtonNormal(context);
  }

  Widget _addItemButtonExtend(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () async => _handleAddNewItem(context),
      label: Text(
        'Import NFT'.toUpperCase(),
        style: TextStyle(color: Colors.white),
      ),
      icon: Icon(
        Icons.link,
        color: Colors.white,
      ),
      backgroundColor: btnColor,
    );
  }

  Widget _addItemButtonNormal(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async => _handleAddNewItem(context),
      child: Icon(
        Icons.link,
        color: Colors.white,
      ),
      backgroundColor: btnColor,
    );
  }

  Future<void> _handleAddNewItem(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AddItemDialogWidget(context);
        });
  }
}
