import 'dart:io';

import 'package:hnotes/requester/api_provider.dart';
import 'package:hnotes/note_services/note_model.dart';

class Repository {
  final apiProvider = NoteApiProvider();

  Future<NoteModel> fetchAllNotes() => apiProvider.getAllNotes();

}

