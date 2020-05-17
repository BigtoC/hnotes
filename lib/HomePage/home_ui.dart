import 'package:flutter/material.dart';
import 'package:hnotes/util/theme.dart';
import 'package:hnotes/HomePage/edit.dart';
import 'package:hnotes/drawer/drawer_ui.dart';

// ignore: must_be_immutable
class MyHomePage extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  MyHomePage({Key key, Function(Brightness brightness) changeTheme})
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Home",
        ),
        backgroundColor: primaryColor,
      ),
      drawer: drawer(context, widget.changeTheme),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '更多功能敬请期待！',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewNotes,
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void _addNewNotes() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (_) {
      return new EditorPage();
    }));
  }
}