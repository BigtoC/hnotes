import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'note_card.dart';
import 'note_cards_list.dart';
import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/presentation/drawer/drawer_ui.dart';
import 'package:hnotes/presentation/home_page/drawer_icon_widget.dart';
import 'package:hnotes/presentation/home_page/flag_on_text_widget.dart';
import 'package:hnotes/presentation/home_page/header_widget.dart';
import 'package:hnotes/presentation/home_page/add_item_button_widget.dart';


// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    Function(ThemeData themeData)? changeTheme,
  })
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  Function(ThemeData themeData)? changeTheme;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isExtend = true;
  bool isFlagOn = false;
  bool isSearching = false;
  ScrollController _scrollController = new ScrollController();
  TextEditingController searchController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<HashMap<String, dynamic>> noteContentsList = [];
  List<Widget> cardList = [];

  @override
  void initState() {
    super.initState();
    _handleScroll();
  }

  @override
  Widget build(BuildContext context) {
    // _buildNotesList();
    return Scaffold(
      key: _scaffoldKey,
      drawer: drawer(context, widget.changeTheme),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            child: ListView(
              physics: BouncingScrollPhysics(),
              // controller: _scrollController,
              children: <Widget>[
                new DrawerIcon(scaffoldKey: _scaffoldKey),
                new HomeHeaderWidget(),
                buildButtonRow(),
                Container(height: 32),
                new ImportantIndicatorText(isFlagOn: isFlagOn),
                ...cardList,
                Container(height: 100)
              ],
            ),
          ),
        ),
      floatingActionButton: new AddItemButton(isExtend: isExtend),
    );
  }

  Widget buildButtonRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
      child: Row(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                isFlagOn = !isFlagOn;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 160),
              height: 50,
              width: 50,
              curve: Curves.slowMiddle,
              child: Icon(
                isFlagOn ? Icons.flag : Icons.outlined_flag,
                color: isFlagOn ? Colors.white : Colors.grey.shade300,
              ),
              decoration: BoxDecoration(
                color: isFlagOn ? btnColor : Colors.transparent,
                border: Border.all(
                  width: isFlagOn ? 2 : 1,
                  color:
                  isFlagOn ? btnColor : Colors.grey.shade300,
                ),
                borderRadius: BorderRadius.all(Radius.circular(16))),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 8),
              padding: EdgeInsets.only(left: 16),
              height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.all(Radius.circular(16))
              ),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      maxLines: 1,
                      onChanged: (value) {
                        _handleSearch(value);
                      },
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Search',
                        hintStyle: TextStyle(
                          color: Colors.grey.shade300,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      isSearching ? Icons.cancel : Icons.search,
                      color: Colors.grey.shade300
                    ),
                    onPressed: cancelSearch,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // _buildNotesList() {
  //   if (!isSearching) {
  //     notesBloc.fetchAllNotes();
  //   }
  //   if (isSearching) {
  //     String keywords = searchController.text;
  //     notesBloc.searchNotes(keywords);
  //   }
  //
  //   Stream<NoteModel> noteStream = notesBloc.noteFiles;
  //   noteStream.take(1);
  //
  //   noteStream.listen((element) {
  //     element.noteKeyValueList?.forEach((noteInstance) {
  //       setState(() {
  //         cardList.add(NoteCardComponent(
  //           noteFile: noteInstance["File"],
  //           noteContents: noteInstance["Contents"],
  //           onTapAction: openNoteToRead,
  //         ));
  //       });
  //     });
  //   }, onDone: () {
  //     print("流已完成");
  //   });
  // }

  // Widget buildNoteComponentsList() {
  //   if (!isSearching) {
  //     notesBloc.fetchAllNotes();
  //   }
  //   if (isSearching) {
  //     String keywords = searchController.text;
  //     notesBloc.searchNotes(keywords);
  //   }
  //   return new NoteCardsList(
  //     onTapAction: openNoteToRead,
  //     isSearching: isSearching,
  //   );
  // }

  openNoteToRead(File noteFile) async {
    throw Exception("Not implemented yet");
    // setState(() {
    //   headerShouldHide = true;
    // });
    // await Future.delayed(Duration(milliseconds: 200), () {});
    // Navigator.push(
    //   context,
    //   FadeRoute(page: EditorPage(noteFile: noteFile, key: null,))
    // );
    // await Future.delayed(Duration(milliseconds: 200), () {});
    //
    // setState(() {
    //   headerShouldHide = false;
    // });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearching = false;
    });
  }

  void _handleSearch(String value) {
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

  Future<void> _handleRefresh() async {
    setState(() {
      isFlagOn = false;
      isSearching = false;
      searchController.clear();
    });
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
