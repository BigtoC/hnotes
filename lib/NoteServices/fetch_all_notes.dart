import 'package:path_provider/path_provider.dart';
import 'dart:io'; // access to File and Directory classes

class NotesListBloc {
  List<File> allNoteFiles;

  getAllNotes() async {
    final directory = await getApplicationDocumentsDirectory();
    var _localPath = directory.path;
    final path = _localPath;
    directory.list().forEach((element) {
      String fileName = element.path.toString();
      if (fileName.contains(".json")) {
        File aFile = File(fileName);
        allNoteFiles.add(aFile);
      }
    });
    return allNoteFiles;
  }

}

final noteBloc = new NotesListBloc();
