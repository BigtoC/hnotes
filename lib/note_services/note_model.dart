import 'dart:io';

class NoteModel {
  final List<File> noteFilesList;
  final List<String> noteContentsList;
  final List<int> noteTimestampsList;

  NoteModel({
    this.noteFilesList,
    this.noteContentsList,
    this.noteTimestampsList,
  });

  factory NoteModel.fromJson (List<File> fileList) {
    List<File> files = fileList;
    List<String> contentsList;
    List<int> timestamps;

    files.forEach((file) async {
      // Get timestamp from file path (filePath = "xxx/xxx/notes-<timestamp>.json")
      timestamps.add(int.parse(file.uri.path.split('/').last.replaceAll('.json', "").replaceAll('notes-', "")));

      // Extract note contents from file data
      final noteContent = await file.readAsString();
      await new Future.delayed(new Duration(milliseconds: 150));
      final String contents = noteContent.toString();
      await new Future.delayed(new Duration(milliseconds: 150));
      contentsList.add(_extractContents(contents));
    });

    return new NoteModel(
      noteFilesList: files,
      noteContentsList: contentsList,
      noteTimestampsList: timestamps
    );
  }
}


String _extractContents(String contents) {
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
