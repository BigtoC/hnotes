import 'package:hnotes/requester/api_provider.dart';
import 'package:hnotes/note_services/note_model.dart';
import 'package:hnotes/chain_call/chain_call_collections.dart';

class Repository {
  final apiProvider = NoteApiProvider();

  Future<NoteModel> fetchAllNotes() => apiProvider.getAllNotes();

  ChainCall chainCall() => apiProvider.chainCall;

  ChainCallTransaction chainCallTx() => apiProvider.chainCallTx();

  ChainCallQuery chainCallQuery() => apiProvider.chainCallQuery();

}

