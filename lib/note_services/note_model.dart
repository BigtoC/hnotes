import 'dart:io';
import 'dart:collection';

class NoteModel {
  final List<HashMap<String, dynamic>>? noteKeyValueList;

  NoteModel({
    this.noteKeyValueList,
  });

  factory NoteModel.fromList (List<File> fileList) {
    var tmpKeyValueList = <HashMap<String, dynamic>>[];

    fileList.forEach((file) async {
      var tmpMap = new HashMap<String, dynamic>();

      // Add the file instance
      tmpMap["File"] = file;

      // Extract note contents from file data
      final noteContent = await file.readAsString();
      await new Future.delayed(new Duration(milliseconds: 100));
      final String contents = noteContent.toString();
      await new Future.delayed(new Duration(milliseconds: 100));
      tmpMap["Contents"] = _extractContents(contents);

      tmpKeyValueList.add(tmpMap);
    });

    tmpKeyValueList.sort((a, b) {
      return a["File"]..lastModifiedSync().compareTo(b["File"]..lastModifiedSync());
    });

    return new NoteModel(
      noteKeyValueList: tmpKeyValueList,
    );
  }
}


String _extractContents(String contents) {
  contents = contents.replaceAll("\\n", "");
  RegExp exp = new RegExp(r"([\u4e00-\u9fa5_a-zA-Z0-9]+)");
  Iterable<Match> matches = exp.allMatches(contents);
  String info = "";
  for (Match m in matches) {
    String? match = m.group(0);
    info += match! + " ";
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
