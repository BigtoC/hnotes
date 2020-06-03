import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'note_cards_list.dart';
import 'package:hnotes/util/theme.dart';
import 'package:hnotes/drawer/drawer_ui.dart';
import 'package:hnotes/note_services/edit_ui.dart';
import 'package:hnotes/note_services/notes_bloc.dart';
import 'package:hnotes/components/components_collections.dart';


// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    Function(Brightness brightness) changeTheme,
  })
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  Function(Brightness brightness) changeTheme;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 200),
                        padding: EdgeInsets.only(top: 16, bottom: 10, right: 20),
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.menu,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                buildHeaderWidget(context),
                buildButtonRow(),
                Container(height: 32),
                buildImportantIndicatorText(),
                RefreshIndicator(
                  child: buildNoteComponentsList(),
                  onRefresh: _handleRefresh
                ),
                Container(height: 100)
              ],
            ),
          ),
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewNotes,
        label: Text(
          'Add note'.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: btnColor,
      ),
    );
  }

  Widget buildHeaderWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        AnimatedContainer(
          duration: Duration(milliseconds: 200),
          curve: Curves.easeIn,
          margin: EdgeInsets.only(top: 0, bottom: 10, left: 20),
          width: headerShouldHide ? 0 : 200,
          child: Text(
            'Notes',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: primaryColor
            ),
            overflow: TextOverflow.clip,
            softWrap: false,
          ),
        ),
      ],
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

  Widget buildNoteComponentsList() {
    if (!isSearching) {
      notesBloc.fetchAllNotes();
    }
    if (isSearching) {
      String keywords = searchController.text;
      notesBloc.searchNotes(keywords);
    }
    return new NoteCardsList(
      onTapAction: openNoteToRead,
      isSearching: isSearching,
    );
  }

  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Center(
        child: Text(
          'Only showing notes marked important'.toUpperCase(),
          style: TextStyle(
            fontSize: 12, color: btnColor, fontWeight: FontWeight.w500
          ),
        ),
      ),
      secondChild: Container(height: 1,),
      crossFadeState:
      isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  void _addNewNotes() {
    Navigator.of(context).push(new CupertinoPageRoute(builder: (_) {
      return new EditorPage(noteFile: null,);
    }));
  }

  openNoteToRead(File noteFile) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
      context,
      FadeRoute(page: EditorPage(noteFile: noteFile))
    );
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
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
}