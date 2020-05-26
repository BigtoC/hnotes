import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';

class NoteCardComponent extends StatelessWidget {
  const NoteCardComponent({
    this.noteFile,
    this.noteContents,
    this.onTapAction,
    Key key
  }) : super(key: key);

  final File noteFile;
  final String noteContents;
  final Function(File noteData) onTapAction;

  @override
  Widget build(BuildContext context) {

    bool isImportant = false;

    String title = noteContents.toString().split(" ")[1];
    int dateFromFileName = int.parse(noteFile.uri.path.split('/').last.replaceAll('.json', "").replaceAll('notes-', ""));
    String neatDate = DateFormat.yMMMd().add_jm().format(DateTime.fromMillisecondsSinceEpoch(dateFromFileName)).toString();
    Color color = colorList.elementAt(noteContents.length % colorList.length);

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
            onTapAction(noteFile);
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
                    fontSize: 20,
                    fontWeight: isImportant
                      ? FontWeight.w800
                      : FontWeight.normal),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  child: Text(
                    '${
                      noteContents.trim().length <= 25
                      ? noteContents.trim()
                      : noteContents.trim().substring(0, 25) + '...'
                    }',
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
        offset: Offset(0, 8)
      );
    }
    return BoxShadow(
      color: isImportant == true
        ? color.withAlpha(60)
        : color.withAlpha(25),
      blurRadius: 8,
      offset: Offset(0, 8)
    );
  }

}
