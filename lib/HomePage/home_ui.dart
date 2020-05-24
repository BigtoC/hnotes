import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'note_cards.dart';
import 'package:hnotes/util/theme.dart';
import 'package:hnotes/drawer/drawer_ui.dart';
import 'package:hnotes/NoteServices/edit.dart';
import 'package:hnotes/components/components_collections.dart';


// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
    Function(Brightness brightness) changeTheme,
    List<File> noteFilesList,
    List<String> noteContentsList,
  })
    : super(key: key) {
    this.changeTheme = changeTheme;
    this.noteFilesList = noteFilesList;
    this.noteContentsList = noteContentsList;
  }

  Function(Brightness brightness) changeTheme;
  List<File> noteFilesList;
  List<String> noteContentsList;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isFlagOn = false;
  bool headerShouldHide = false;
  TextEditingController searchController = TextEditingController();
  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
        ),
        backgroundColor: primaryColor,
      ),
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
              buildButtonRow(),
              Container(height: 32),
              buildImportantIndicatorText(),
              RefreshIndicator(
                child: ListView(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  children: <Widget>[
                    ...buildNoteComponentsList()
                  ],
                ),
                onRefresh: _handleRefresh
              ),
              Container(height: 100)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewNotes,
        label: Text('Add note'.toUpperCase()),
        icon: Icon(Icons.add),
        backgroundColor: primaryColor,
      ),
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
                color: isFlagOn ? Colors.blue : Colors.transparent,
                border: Border.all(
                  width: isFlagOn ? 2 : 1,
                  color:
                  isFlagOn ? Colors.blue.shade700 : Colors.grey.shade300,
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
                        handleSearch(value);
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
                      isSearchEmpty ? Icons.search : Icons.cancel,
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

  List<Widget> buildNoteComponentsList() {
    List<Widget> noteCardsList = [];
    int index = 0;

    widget.noteFilesList.forEach((file) {
      String contents = widget.noteContentsList[index];
      noteCardsList.add(
        NoteCardComponent(
          noteFile: file,
          noteContents: contents,
          onTapAction: openNoteToRead
        )
      );
      index += 1;
    });

    return noteCardsList;
  }

  Widget buildImportantIndicatorText() {
    return AnimatedCrossFade(
      duration: Duration(milliseconds: 200),
      firstChild: Center(
        child: Text(
          'Only showing notes marked important'.toUpperCase(),
          style: TextStyle(
            fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500
          ),
        ),
      ),
      secondChild: Container(
        height: 2,
      ),
      crossFadeState:
      isFlagOn ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  }

  void _addNewNotes() {
    Navigator.of(context).push(new CupertinoPageRoute(builder: (_) {
      return new EditorPage(noteFile: null,);
    }));
  }

  openNoteToRead(File noteData) async {
    setState(() {
      headerShouldHide = true;
    });
    await Future.delayed(Duration(milliseconds: 230), () {});
    Navigator.push(
      context,
      FadeRoute(
        page: EditorPage(
          noteFile: noteData)));
    await Future.delayed(Duration(milliseconds: 300), () {});

    setState(() {
      headerShouldHide = false;
    });
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(() {
      searchController.clear();
      isSearchEmpty = true;
    });
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(() {
        isSearchEmpty = false;
      });
    } else {
      setState(() {
        isSearchEmpty = true;
      });
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      isFlagOn = false;
      searchController.clear();
    });
  }
}