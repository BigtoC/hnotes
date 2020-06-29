import 'dart:async';
import 'dart:io';
import 'dart:collection';
import 'package:flutter/material.dart';

import 'package:hnotes/home_page/note_card.dart';
import 'package:hnotes/note_services/notes_services_collections.dart';

List<Widget> NoteCardsListWidget(
  Function(File noteData) onTapAction,
  bool isSearching
  ) {
  List<HashMap<String, dynamic>> noteContentsList = [];
  List<Widget> cardList = [];
  notesBloc.noteFiles.forEach((element) {
    noteContentsList.addAll(element.noteKeyValueList);
    noteContentsList.forEach((noteInstance) {
      cardList.add(NoteCardComponent(
        noteFile: noteInstance["File"],
        noteContents: noteInstance["Contents"],
        onTapAction: onTapAction,
      ));
    });
    return cardList;
  });

  notesBloc.noteFiles.listen((data) {
    noteContentsList.addAll(data.noteKeyValueList);
    noteContentsList.forEach((noteInstance) {
      cardList.add(NoteCardComponent(
        noteFile: noteInstance["File"],
        noteContents: noteInstance["Contents"],
        onTapAction: onTapAction,
      ));
    });
  });
  print(cardList);

}
