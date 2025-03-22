import 'package:flutter/material.dart';

// ignore: must_be_immutable
class SearchBarWidget extends StatefulWidget {
  late bool isSearching;
  late TextEditingController searchController;
  late Function() handleCancelSearch;
  late Function(String value) handleSubmitSearch;
  late Function(String value) handleTypingInSearchFiled;

  SearchBarWidget({
    super.key,
    required this.isSearching,
    required this.searchController,
    required this.handleCancelSearch,
    required this.handleSubmitSearch,
    required this.handleTypingInSearchFiled,
  });

  @override
  State<StatefulWidget> createState() => _SearchBarWidget();
}

class _SearchBarWidget extends State<SearchBarWidget> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.only(left: 16),
        height: 50,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: widget.searchController,
                onSubmitted: widget.handleSubmitSearch,
                maxLines: 1,
                onChanged: widget.handleTypingInSearchFiled,
                autofocus: false,
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration.collapsed(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade300,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                widget.isSearching ? Icons.cancel : Icons.search,
                color: Colors.grey.shade300,
              ),
              onPressed: widget.handleCancelSearch,
            ),
          ],
        ),
      ),
    );
  }
}
