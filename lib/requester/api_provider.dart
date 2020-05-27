import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hnotes/note_services/note_model.dart';

class NoteApiProvider {

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
