import 'dart:io'; // access to File and Directory classes
import 'package:path_provider/path_provider.dart';

class NotesListBloc {
  List<File> noteFilesList = [];
  List<String> noteContentsList = [];

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

  Future<void> getAllNoteFiles() async {
    var fs = await notesBloc.getAllNotes;
    await new Future.delayed(new Duration(milliseconds: 105));
    List<File> tmpList = [];
    tmpList.addAll(fs);
    tmpList.sort((a, b) {
      return b.lastModifiedSync().compareTo(a.lastModifiedSync());
    });

    await new Future.delayed(new Duration(milliseconds: 150));

    await getStrFromNoteDate();
  }

  Future<void> getStrFromNoteDate() async {
    List<String> tmpList = [];

    noteFilesList.forEach((file) async {
      final noteContent = await file.readAsString();
      await new Future.delayed(new Duration(milliseconds: 150));
      final String contents = noteContent.toString();
      await new Future.delayed(new Duration(milliseconds: 150));
      tmpList.add(extractContents(contents));
    });
    await new Future.delayed(new Duration(milliseconds: 305));

  }

  String extractContents(String contents) {
    contents = contents.replaceAll("\\n", "");
    RegExp exp = new RegExp(r"([\u4e00-\u9fa5_a-zA-Z0-9]+)");
    Iterable<Match> matches = exp.allMatches(contents);
    String info = "";
    for (Match m in matches) {
      String match = m.group(0);
      info += match + " ";
    }
    String extractedContents = info.replaceAll("insert", "")
      .replaceAll("delete", "")
      .replaceAll("retain", "")
      .replaceAll("heading", "")
      .replaceAll("block", "")
      .replaceAll("embed", "");

    return extractedContents;
  }


}

final notesBloc = new NotesListBloc();
