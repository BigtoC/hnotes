import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:hnotes/note_services/note_model.dart';
import 'package:hnotes/chain_call/chain_call_collections.dart';

class NoteApiProvider {
  var client = http.Client();

  final chainCall = ChainCall();

  final chainCallTx = ChainCall().chainCallTx;

  final chainCallQuery = ChainCall().chainCallQuery;

  Future<NoteModel> getAllNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    await new Future.delayed(new Duration(milliseconds: 100));
    List<File> tmpList = [];

    directory.list().forEach((element) {
      String fileName = element.path.toString();
      if (fileName.contains(".json")) {
        File aFile = File(fileName);
        tmpList.add(aFile);
      }
    });

    tmpList.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });
    await new Future.delayed(new Duration(milliseconds: 100));
    return NoteModel.fromList(tmpList);
  }

}
