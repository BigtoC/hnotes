import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/HomePage/home_ui.dart';
import 'package:hnotes/NoteServices/notes_bloc.dart';
import 'package:hnotes/SplashScreen/count_day_model.dart';

// ignore: must_be_immutable
class DaySince extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  DaySince({
    Key key, this.isSplash, Function(Brightness brightness) changeTheme})
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final bool isSplash;

  @override
  _DaySince createState() => new _DaySince();
}

class _DaySince extends State<DaySince> {
  static int daySince = CountDayModel.daysSince;
  static String startDateStr = CountDayModel.startDateStr;
  List<File> noteFilesList = [];
  List<String> noteContentsList = [];

  @override
  void initState() {
    super.initState();
    if (widget.isSplash) {
      // Read note data file after opening the splash page in the first time
      getAllNoteFiles();
    }

  }

  Future<void> getAllNoteFiles() async {
    var fs = await notesBloc.getAllNotes;
    await new Future.delayed(new Duration(milliseconds: 105));
    List<File> tmpList = [];
    tmpList.addAll(fs);
    tmpList.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });

    setState(() {
      noteFilesList = tmpList;
    });
    await new Future.delayed(new Duration(milliseconds: 150));

    await getStrFromNoteDate();
  }

  Future<void> getStrFromNoteDate() async {
    List<String> tmpList = [];

    noteFilesList.forEach((file) async {
      final noteContent = await file.readAsString();
      await new Future.delayed(new Duration(milliseconds: 150));
      final String contents = noteContent.toString();
      await new Future.delayed(new Duration(milliseconds: 150));
      tmpList.add(extractContents(contents));
    });
    await new Future.delayed(new Duration(milliseconds: 305));

    setState(() {
      noteContentsList = tmpList;
    });
  }

  String extractContents(String contents) {
    contents = contents.replaceAll("\\n", "");
    RegExp exp = new RegExp(r"([\u4e00-\u9fa5_a-zA-Z0-9]+)");
    Iterable<Match> matches = exp.allMatches(contents);
    String info = "";
    for (Match m in matches) {
      String match = m.group(0);
      info += match + " ";
    }
    String extractedContents = info.replaceAll("insert", "")
      .replaceAll("delete", "")
      .replaceAll("retain", "")
      .replaceAll("heading", "")
      .replaceAll("block", "")
      .replaceAll("embed", "");

    return extractedContents;
  }

  Widget showDays() {
    return Center(
      child: Column(
        children: <Widget>[
          Text(
            "${daySince.toString()}",
            style: TextStyle(
              fontSize: 90,
              color: Colors.white,
            ),
          ),
          Container(height: 30,),
          Text(
            "Start Date: $startDateStr",
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget loveUBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 60.0,
        horizontal: 100.0
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () {
          if (widget.isSplash) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>
                MyHomePage(
                  changeTheme: widget.changeTheme,
                  noteFilesList: noteFilesList,
                  noteContentsList: noteContentsList,
                )
              ),
                (Route<dynamic> route) => false);
          }
          else {
            Navigator.pop(context);
          }
        },
        padding: EdgeInsets.all(12),
        color: primaryColor.withOpacity(0.3),
        child: Text(
          'Love You~',
          style: TextStyle(color: Colors.white)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/Images/sun-bg.jpg',
              fit: BoxFit.fitHeight,
              height: 2000,
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                showDays(),
                loveUBtn()
              ],
            ),
          )
        ],
      ),
    );
  }
}

