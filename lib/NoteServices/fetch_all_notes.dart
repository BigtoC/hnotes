import 'dart:io'; // access to File and Directory classes
import 'package:path_provider/path_provider.dart';

class NotesListBloc {

  Future<List<File>> get getAllNotes async {
    final directory = await getApplicationDocumentsDirectory();

    List<File> allNoteFiles = [];

    directory.list().forEach((element) {
      String fileName = element.path.toString();
      if (fileName.contains(".json")) {
        File aFile = File(fileName);
        allNoteFiles.add(aFile);
      }
    });
    await new Future.delayed(new Duration(milliseconds: 100));

    return allNoteFiles;
  }
}

final notesBloc = new NotesListBloc();
