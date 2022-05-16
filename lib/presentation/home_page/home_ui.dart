import 'dart:io';
import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'note_card.dart';
import 'note_cards_list.dart';
import 'package:hnotes/presentation/drawer/drawer_ui.dart';
import 'package:hnotes/presentation/home_page/header/header_widget.dart';
import 'package:hnotes/presentation/home_page/header/drawer_icon_widget.dart';
import 'package:hnotes/presentation/home_page/control_bar/control_bar_widget.dart';
import 'package:hnotes/presentation/home_page/control_bar/toggled_text_widget.dart';
import 'package:hnotes/presentation/home_page/add_items/add_item_button_widget.dart';

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    Function(ThemeData themeData)? changeTheme,
  }) : super(key: key) {
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
              HomeHeaderWidget(),
              new ControlBar(
                  isFlagOn: isFlagOn,
                  isSearching: isSearching,
                  toggleFlagOnOff: toggleFlagOnOff,
                  searchController: searchController,
                  handleSubmitSearch: _handleSubmitSearch,
                  handleCancelSearch: _handleCancelSearch,
                  handleTypingInSearchFiled: _handleTypingInSearchFiled),
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

  toggleFlagOnOff() {
    setState(() {
      isFlagOn = !isFlagOn;
    });
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

  void _handleCancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
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

  Future<void> _handleRefresh() async {
    setState(() {
      isFlagOn = false;
      isSearching = false;
      searchController.clear();
    });
  }

  void _handleScroll() {
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection == ScrollDirection.reverse) {
        setState(() {
          isExtend = false;
        });
      }
      if (_scrollController.position.userScrollDirection == ScrollDirection.forward) {
        setState(() {
          isExtend = true;
        });
      }
    });
  }
}
