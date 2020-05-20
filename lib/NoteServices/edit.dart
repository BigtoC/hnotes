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

class EditorPage extends StatefulWidget {
  @override
  EditorPageState createState() => EditorPageState();
}

class EditorPageState extends State<EditorPage> {
  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;

  bool isNoteNew = true;

  @override
  void initState() {
    super.initState();
    // Here we must load the document and pass it to Zefyr controller.
    final document = _loadDocument();
    _controller = ZefyrController(document);
    _focusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    // Note that the editor requires special `ZefyrScaffold` widget to be
    // one of its parents.
    return Scaffold(
      appBar: AppBar(
        title: Text("Take Notes"),
        backgroundColor: primaryColor,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => _handleDelete(),
            ),
          ),
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.save),
              onPressed: () => _handleSave(context),
            ),
          ),
        ],
      ),
      body: ZefyrScaffold(
        child: ZefyrEditor(
          padding: EdgeInsets.all(16),
          controller: _controller,
          focusNode: _focusNode,
        ),
      ),

    );
  }

  /// Loads the document to be edited in Zefyr.
  NotusDocument _loadDocument() {
    // For simplicity we hardcode a simple document with one line of text
    // saying "Zefyr Quick Start".
    // (Note that delta must always end with newline.)
    final Delta delta = Delta()..insert("爱你哟\n");
    return NotusDocument.fromDelta(delta);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  void _handleSave(BuildContext context) async{
    // Notus documents can be easily serialized to JSON by passing to
    // `jsonEncode` directly
    final contents = jsonEncode(_controller.document);

    // Take timestamp as file name
    final timestampStr = new DateTime.now().millisecondsSinceEpoch;

    // Get file path
    final path = await _localPath;
    print(path);
    final file = File('$path/notes-$timestampStr.json');

    // Write file and show a snack bar on success.
    file.writeAsString(contents).then((_) {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Saved.")));
    });
  }

  void _handleDelete() {

  }

  void _handleBack() {
    Navigator.pop(context);
  }
}