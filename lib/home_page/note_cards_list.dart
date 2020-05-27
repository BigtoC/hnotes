import 'dart:io';
import 'package:hnotes/home_page/note_cards.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/note_services/notes_bloc.dart';
import 'package:hnotes/note_services/note_model.dart';

class NoteCardsList extends StatelessWidget {
  const NoteCardsList({
    this.onTapAction,
    Key key
  }) : super(key: key);

  final Function(File noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    notesBloc.fetchAllNotes();
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
    final int itemCount = snapshot.data.noteContentsList.length;
    final List<File> noteFilesList = snapshot.data.noteFilesList;
    final List<String> noteContentsList = snapshot.data.noteContentsList;
    final List<int> noteTimestampsList = snapshot.data.noteTimestampsList;

    if (itemCount > 0) {
      return ListView.builder(
        shrinkWrap: true,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return new NoteCardComponent(
            noteFile: noteFilesList[index],
            noteContents: noteContentsList[index],
            timestamp: noteTimestampsList[index],
            onTapAction: onTapAction,
          );
        }
      );
    }
    else {
      return new Center(
        child: new Text("Click the Add Note button to create a new note")
      );
    }
  }

}
