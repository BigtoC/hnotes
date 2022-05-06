import 'package:hnotes/note_services/note_model.dart';
import 'package:hnotes/infrastructure/local_storage/requester/api_provider.dart';

class Repository {
  final apiProvider = NoteApiProvider();

  Future<NoteModel> fetchAllNotes() => apiProvider.getAllNotes();

}
