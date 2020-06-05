import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hnotes/home_page/note_cards.dart';

import 'package:hnotes/note_services/notes_bloc.dart';
import 'package:hnotes/note_services/note_model.dart';

class NoteCardsList extends StatelessWidget {
  const NoteCardsList({
    this.onTapAction,
    this.isSearching,
    Key key
  }) : super(key: key);

  final Function(File noteData) onTapAction;
  final bool isSearching;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: notesBloc.noteFiles,
      builder: (context, AsyncSnapshot<NoteModel> snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(
            child: buildNoteCardList(context, snapshot, onTapAction),
          );
        }
        else if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        return Center(
          child: CircularProgressIndicator()
        );
      }
    );
  }

  Widget buildNoteCardList(
    BuildContext context,
    AsyncSnapshot<NoteModel> snapshot,
    Function(File noteData) onTapAction
    ) {
    final int itemCount = snapshot.data.noteKeyValueList.length;
    List<Map<String, dynamic>> notesList = snapshot.data.noteKeyValueList;

    if (!isSearching) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return new NoteCardComponent(
            noteFile: notesList[index]["File"],
            noteContents: notesList[index]["Contents"],
            onTapAction: onTapAction,
          );
        }
      );
    }
    else if (isSearching) {
      return new Center(
        child: new Text("Note(s) not found.")
      );
    }
    else {
      return new Center(
        child: new Text("Click the Add Note button to create a new note")
      );
    }
  }

}
