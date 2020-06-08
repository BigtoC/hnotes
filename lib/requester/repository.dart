import 'package:hnotes/chain_call/chain_call.dart';
import 'package:hnotes/requester/api_provider.dart';
import 'package:hnotes/note_services/note_model.dart';

class Repository {
  final apiProvider = NoteApiProvider();

  Future<NoteModel> fetchAllNotes() => apiProvider.getAllNotes();

  ChainCall chainCall() => apiProvider.chainCall;

  Future<String> fetchLoveStartDate() => apiProvider.getLoveStartDate();

}
