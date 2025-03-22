import 'package:flutter/material.dart';

import 'package:hnotes/presentation/home_page/control_bar/control_bar_flag_widget.dart';
import 'package:hnotes/presentation/home_page/control_bar/control_bar_search_widget.dart';

// ignore: must_be_immutable
class ControlBar extends StatefulWidget {
  late bool isFlagOn;
  late Function() toggleFlagOnOff;
  late bool isSearching;
  late TextEditingController searchController;
  late Function() handleCancelSearch;
  late Function(String value) handleSubmitSearch;
  late Function(String value) handleTypingInSearchFiled;

  ControlBar({
    super.key,
    required this.isFlagOn,
    required this.toggleFlagOnOff,
    required this.isSearching,
    required this.searchController,
    required this.handleCancelSearch,
    required this.handleSubmitSearch,
    required this.handleTypingInSearchFiled,
  });

  @override
  State<StatefulWidget> createState() => _ControlBar();
}

class _ControlBar extends State<ControlBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        children: [
          FlagToggleWidget(
            isFlagOn: widget.isFlagOn,
            toggleFlagOnOff: widget.toggleFlagOnOff,
          ),
          SearchBarWidget(
            isSearching: widget.isSearching,
            searchController: widget.searchController,
            handleCancelSearch: widget.handleCancelSearch,
            handleSubmitSearch: widget.handleSubmitSearch,
            handleTypingInSearchFiled: widget.handleTypingInSearchFiled,
          ),
        ],
      ),
    );
  }
}
