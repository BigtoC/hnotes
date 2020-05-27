import 'dart:io'; // access to File and Directory classes
import 'package:rxdart/rxdart.dart';

import 'package:hnotes/requester/repository.dart';
import 'package:hnotes/note_services/note_model.dart';

class NotesListBloc {
  final _repository = new Repository();
  final _allNotesList = new PublishSubject<NoteModel>();

  Stream<NoteModel> get noteFiles => _allNotesList.stream;

  fetchAllNotes() async {
    NoteModel noteModel = await _repository.fetchAllNotes();
    await new Future.delayed(new Duration(milliseconds: 305));
    _allNotesList.sink.add(noteModel);
  }

  bool isDispose = false;

  void dispose() {
    _allNotesList.close();
  }

}

final notesBloc = new NotesListBloc();
