import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/note_services/notes_bloc.dart';
import 'package:hnotes/note_services/note_model.dart';

class NoteCardsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    notesBloc.fetchAllNotes();
    return StreamBuilder(
      stream: notesBloc.noteFiles,
      builder: (context, AsyncSnapshot<NoteModel> snapshot) {
        if (snapshot.hasData) {
          return Scrollbar(

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

  Widget NoteCardComponent(BuildContext context, AsyncSnapshot<NoteModel> snapshot) {
    if (snapshot.data.noteFilesList.length > 0) {

    }
  }

}
