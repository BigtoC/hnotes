import "dart:collection";
import "package:flutter/material.dart";
import "package:flutter/rendering.dart";

import "package:hnotes/presentation/drawer/drawer_ui.dart";
import "package:hnotes/presentation/home_page/dapps/wallet_balance_card.dart";
import "package:hnotes/presentation/home_page/header/header_widget.dart";
import "package:hnotes/presentation/home_page/items/build_item_list.dart";
import "package:hnotes/presentation/home_page/header/drawer_icon_widget.dart";
import "package:hnotes/presentation/home_page/control_bar/control_bar_widget.dart";
import "package:hnotes/presentation/home_page/control_bar/toggled_text_widget.dart";
import "package:hnotes/presentation/home_page/add_items/add_item_button_widget.dart";

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, this.changeTheme});

  Function(ThemeData themeData)? changeTheme;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  bool isExtend = true;
  bool isFlagOn = false;
  bool isSearching = false;
  final ScrollController _scrollController = ScrollController();
  TextEditingController searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<HashMap<String, dynamic>> noteContentsList = [];
  List<Widget> itemList = [];

  @override
  void initState() {
    super.initState();
    _handleScroll();
  }

  @override
  Widget build(BuildContext context) {
    buildItemList(_addItemToList);
    return Scaffold(
      key: _scaffoldKey,
      drawer: DrawerWidget(widget.changeTheme),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          child: ListView(
            physics: BouncingScrollPhysics(),
            // controller: _scrollController,
            children: <Widget>[
              DrawerIcon(scaffoldKey: _scaffoldKey),
              HomeHeaderWidget(),
              ControlBar(
                isFlagOn: isFlagOn,
                isSearching: isSearching,
                toggleFlagOnOff: toggleFlagOnOff,
                searchController: searchController,
                handleSubmitSearch: _handleSubmitSearch,
                handleCancelSearch: _handleCancelSearch,
                handleTypingInSearchFiled: _handleTypingInSearchFiled,
              ),
              Container(height: 32),
              ImportantIndicatorText(isFlagOn: isFlagOn),
              WalletBalanceCard(),
              ...itemList,
              Container(height: 100),
            ],
          ),
        ),
      ),
      floatingActionButton: AddItemButton(isExtend: isExtend),
    );
  }

  toggleFlagOnOff() {
    setState(() {
      isFlagOn = !isFlagOn;
    });
  }

  _addItemToList(List<Widget> aList) {
    setState(() {
      itemList = aList;
    });
  }

  void _handleCancelSearch() {
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      searchController.clear();
      isSearching = false;
    });
  }

  void _handleSubmitSearch(String value) {
    setState(() {
      isSearching = false;
    });
  }

  void _handleTypingInSearchFiled(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearching = true;
      });
    } else {
      setState(() {
        isSearching = false;
      });
    }
  }

  void _handleScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        setState(() {
          isExtend = false;
        });
      }
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        setState(() {
          isExtend = true;
        });
      }
    });
  }
}
