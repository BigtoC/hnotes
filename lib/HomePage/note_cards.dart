import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

List<Color> colorList = [
  Colors.blue,
  Colors.green,
  Colors.indigo,
  Colors.red,
  Colors.cyan,
  Colors.teal,
  Colors.amber.shade900,
  Colors.deepOrange
];

String noteContents = '';

class NoteCardComponent extends StatelessWidget {
  const NoteCardComponent({
    this.noteData,
    this.onTapAction,
    Key key
  }) : super(key: key);

  final File noteData;
  final Function(File noteData) onTapAction;

  @override
  Widget build(BuildContext context) {
    print(noteContents);
    print(getStrFromNoteDate());
    bool isImportant = false;

    String title = noteContents.split(" ")[0];
    int dateFromFileName = int.parse(noteData.uri.path.split('/').last.replaceAll('.json', "").replaceAll('notes-', ""));
    String neatDate = DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(dateFromFileName)).toString();
    Color color = colorList.elementAt(noteData.length.call().toString().length % colorList.length);

    return Container(
      margin: EdgeInsets.fromLTRB(10, 8, 10, 8),
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [buildBoxShadow(context, color, isImportant)],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        color: Theme.of(context).dialogBackgroundColor,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            onTapAction(noteData);
          },
          splashColor: color.withAlpha(20),
          highlightColor: color.withAlpha(10),
          child: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${title.length <= 20 ? title : title.substring(0, 20) + '...'}',
                  style: TextStyle(
                    fontFamily: 'ZillaSlab',
                    fontSize: 20,
                    fontWeight: isImportant
                      ? FontWeight.w800
                      : FontWeight.normal),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    '${noteContents.trim().split('\n').first.length <= 30 ? noteContents.trim().split('\n').first : noteContents.trim().split('\n').first.substring(0, 30) + '...'}',
                    style:
                    TextStyle(fontSize: 14, color: Colors.grey.shade400),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 14),
                  alignment: Alignment.centerRight,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.flag,
                        size: 16,
                        color: isImportant
                          ? color
                          : Colors.transparent),
                      Spacer(),
                      Text(
                        '$neatDate',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ));
  }

  BoxShadow buildBoxShadow(BuildContext context, Color color, bool isImportant) {
    if (Theme.of(context).brightness == Brightness.dark) {
      return BoxShadow(
        color: isImportant == true
          ? Colors.black.withAlpha(100)
          : Colors.black.withAlpha(10),
        blurRadius: 8,
        offset: Offset(0, 8));
    }
    return BoxShadow(
      color: isImportant == true
        ? color.withAlpha(60)
        : color.withAlpha(25),
      blurRadius: 8,
      offset: Offset(0, 8));
  }

  Future<void> getStrFromNoteDate() async {
    final noteContent = await noteData.readAsString();
    await new Future.delayed(new Duration(milliseconds: 500));
    final String contents = noteContent.toString();
    await new Future.delayed(new Duration(milliseconds: 500));
    noteContents = contents;
    await new Future.delayed(new Duration(milliseconds: 500));
    extraRealContents();
  }

  void extraRealContents() {
    RegExp exp = new RegExp(r"([\u4e00-\u9fa5_a-zA-Z0-9]+)");
    Iterable<Match> matches = exp.allMatches(noteContents);
    String info = "";
    for (Match m in matches) {
      String match = m.group(0);
      info += match + " ";
    }

    noteContents = info.replaceAll("insert", "")
      .replaceAll("delete", "").replaceAll("retain", "");
    print(noteContents);
  }

}
