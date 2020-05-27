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

  factory NoteModel.fromList (List<File> fileList) {
    List<File> files = fileList;
    List<String> contentsList = new List<String>();
    List<int> timestamps = new List<int>();

    files.forEach((file) async {
      // Get timestamp from file path (filePath = "xxx/xxx/notes-<timestamp>.json")
      int thisTime = int.parse(file.uri.path.split('/').last.replaceAll('.json', "").replaceAll('notes-', ""));
      timestamps.add(thisTime);

      // Extract note contents from file data
      final noteContent = await file.readAsString();
      await new Future.delayed(new Duration(milliseconds: 100));
      final String contents = noteContent.toString();
      await new Future.delayed(new Duration(milliseconds: 100));
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
    .replaceAll("embed", "")
    .replaceAll("attributes", "")
    .replaceAll("ul", "");

  return extractedContents;
}
