import 'dart:io';
import 'package:rxdart/rxdart.dart';

import 'package:hnotes/note_services/note_model.dart';
import 'package:hnotes/infrastructure/local_storage/requester/repository.dart';

class NotesListBloc {
  final _repository = new Repository();
  final _allNotesList = new PublishSubject<NoteModel>();

  Stream<NoteModel> get noteFiles => _allNotesList.stream;
  Future<int> get noteListLength => _allNotesList.length;

  fetchAllNotes() async {
    NoteModel noteModel = await _repository.fetchAllNotes();
    await new Future.delayed(new Duration(milliseconds: 500));

    _allNotesList.sink.add(noteModel);
  }

  searchNotes(String keywords) async {
    List<File> tmpFileList = [];
    NoteModel noteModel = await _repository.fetchAllNotes();
    await new Future.delayed(new Duration(milliseconds: 500));
    for (int i = 0; i < noteModel.noteKeyValueList!.length; i++) {
      String content = noteModel.noteKeyValueList![i]["Contents"];
      if (content.contains(keywords)) {
        tmpFileList.add(noteModel.noteKeyValueList![i]["File"]);
      }
    }
    _allNotesList.sink.add(NoteModel.fromList(tmpFileList));

  }

  bool isDispose = false;

  void dispose() {
    _allNotesList.close();
  }

}

final notesBloc = new NotesListBloc();
