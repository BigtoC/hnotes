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


  /// Allows to control the editor and the document.
  ZefyrController _controller;

  /// Zefyr editor like any other input field requires a focus node.
  FocusNode _focusNode;


  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _loadDocument().then((document) {
      setState(() {
        _controller = ZefyrController(document);
      });
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
          ),
      );

    return Scaffold(
      appBar: AppBar(
        title: Text("Take Notes"),
        backgroundColor: primaryColor,
        actions: <Widget>[
          Builder(
            builder: (context) => IconButton(
              icon: Icon(Icons.delete_outline),
              onPressed: () => _handleDelete(context),
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
      body: body,
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
    final Delta delta = Delta()..insert("爱你哟\n");
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

    if (null == widget.noteFile) {
      // Get file path
      final path = await _localPath;
      file = File('$path/notes-$timestampStr.json');
    }
    else {
      file = widget.noteFile;
    }

    return file;
  }

  void _handleSave(BuildContext context) async {
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
    File file = await _getCurrentFile();
    file.delete(recursive: false).then((_) async {
      Scaffold.of(context).showSnackBar(SnackBar(content: Text("Delete Success.")));
      await new Future.delayed(new Duration(milliseconds: 500));
      _handleBack(context);
    });
  }

  void _handleBack(BuildContext context) {
    Navigator.pop(context);
  }
}