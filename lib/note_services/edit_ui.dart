import 'dart:ui';
import 'dart:io'; // access to File and Directory classes
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/painting.dart' as prefix0;
import 'package:path_provider/path_provider.dart';

import 'package:zefyr/zefyr.dart';
import 'package:hnotes/util/theme.dart';
import 'package:quill_delta/quill_delta.dart';
import 'dart:convert'; // access to jsonEncode()

// ignore: must_be_immutable
class EditorPage extends StatefulWidget {
  File noteFile;

  EditorPage({
    File noteFile,
    Key key
  }) : super(key: key) {
    this.noteFile = noteFile;
  }

  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  bool isDirty = false;

  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(() => _onControllerChange());
//    _controller.addListener(() => _onControllerChange());
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
    });
  }

  void _onControllerChange() {
    setState(() {
      isDirty = !isDirty;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    final Widget body = (_controller == null)
      ? Center(child: CircularProgressIndicator())
      : ZefyrScaffold(
          child: ZefyrEditor(
            padding: EdgeInsets.all(16),
            controller: _controller,
            focusNode: _focusNode,
            autofocus: false,
          ),
      );

    return Scaffold(
      appBar: appBar(context),
      body: body,
    );
  }

  Widget appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(50.0), // here the desired height
      child: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: primaryColor),
          onPressed: () => _handleBack(context),
        ),
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(
                Icons.delete_outline,
                color: primaryColor,
              ),
              onPressed: () => _handleDelete(context),
            ),
          ),
          Builder(
            builder: (context) => AnimatedContainer(
              margin: EdgeInsets.only(left: 10),
              duration: Duration(milliseconds: 100),
              width: isDirty ? 100 : 0,
              height: 42,
              curve: Curves.decelerate,
              child: RaisedButton.icon(
                color: primaryColor,
                textColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(100),
                    bottomLeft: Radius.circular(100)
                  )
                ),
                icon: Icon(Icons.done),
                label: Text(
                  'SAVE',
                  style: TextStyle(letterSpacing: 0),
                ),
                onPressed: () => _handleSave(context),
              ),
            ),
          ),
        ],
      )
    );
  }

  Widget beautyAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          height: 80,
          color: Theme.of(context).canvasColor.withOpacity(0.3),
          child: SafeArea(
            child: Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => _handleBack(context),
                ),
                Spacer(),
//                IconButton(
//                  tooltip: 'Mark note as important',
//                  icon: Icon(isImportant
//                    ? Icons.flag
//                    : Icons.outlined_flag),
//                  onPressed: contentController.text.trim().isNotEmpty
//                    ? markImportantAsDirty
//                    : null,
//                ),
                IconButton(
                  icon: Icon(Icons.delete_outline),
                  onPressed: () => _handleDelete(context),
                ),
                AnimatedContainer(
                  margin: EdgeInsets.only(left: 10),
                  duration: Duration(milliseconds: 200),
                  width: isDirty ? 100 : 0,
                  height: 42,
                  curve: Curves.decelerate,
                  child: RaisedButton.icon(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100))),
                    icon: Icon(Icons.done),
                    label: Text(
                      'SAVE',
                      style: TextStyle(letterSpacing: 1),
                    ),
                    onPressed: () => _handleSave(context),
                  ),
                )
              ],
            ),
          ),
        )),
    );
  }

  /// Loads the document to be edited in Zefyr.
  Future<NotusDocument> _loadDocument() async {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final file = widget.noteFile;
    if (file != null && await file.exists()) {
      final contents = await file.readAsString();
      return NotusDocument.fromJson(jsonDecode(contents));
    }
    final Delta delta = Delta()..insert("");
    return NotusDocument.fromDelta(delta);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getCurrentFile() async {
    // Take timestamp as file name
    final timestampStr = new DateTime.now().millisecondsSinceEpoch;
    File file;

    if (null == widget.noteFile) {  // A new note
      // Get file path
      final path = await _localPath;
      file = File('$path/notes-$timestampStr.json');
    }
    else {
      file = widget.noteFile;
    }

    return file;
  }

  void markContentAsDirty(String content) {
    setState(() {
      isDirty = true;
    });
  }

  void _handleSave(BuildContext context) async {
    setState(() {
      isDirty = false;
    });

    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);

    File file = await _getCurrentFile();

    // Write file and show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }

  void _handleDelete(BuildContext context) async {
    if (null == widget.noteFile) {  // A new note
      _handleBack(context);
    }
    else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8)),
            title: Text('Delete Note'),
            content: Text('This note will be deleted permanently'),
            actions: <Widget>[
              FlatButton(
                child: Text('DELETE',
                  style: prefix0.TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1)
                ),
                onPressed: () async {
                  File file = await _getCurrentFile();
                  file.delete(recursive: false).then((_) async {
                    await new Future.delayed(new Duration(milliseconds: 500));
                    Navigator.pop(context);
                  });
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: btnColor,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ]
          );
        }
      );
    }
  }

  void _handleBack(BuildContext context) {
    Navigator.pop(context);
  }
}