import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';


class AddItemButton extends StatelessWidget {
  final bool isExtend;

  AddItemButton({required this.isExtend});

  @override
  Widget build(BuildContext context) {
    return isExtend ? _addItemButtonExtend() : _addItemButtonNormal();
  }

  Widget _addItemButtonExtend() {
    return FloatingActionButton.extended(
      onPressed: _handleAddNewItem,
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

  Widget _addItemButtonNormal() {
    return FloatingActionButton(
      onPressed: _handleAddNewItem,
      child: Icon(
        Icons.link,
        color: Colors.white,
      ),
      backgroundColor: btnColor,
    );
  }

  void _handleAddNewItem() {
    print("add");
  }

}