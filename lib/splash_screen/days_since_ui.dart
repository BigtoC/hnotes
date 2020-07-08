import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';
import 'package:hnotes/home_page/home_ui.dart';
import 'package:hnotes/components/fade_route.dart';
import 'package:hnotes/splash_screen/splash_collections.dart';

// ignore: must_be_immutable
class DaySince extends StatefulWidget {
  Function(Brightness brightness) changeTheme;
  DaySince({
    Key key, this.isSplash, Function(Brightness brightness) changeTheme})
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final bool isSplash;

  @override
  _DaySince createState() => new _DaySince();
}

class _DaySince extends State<DaySince> {

  // a key to set on our Text widget, so we can measure later
  GlobalKey colorTextKey = GlobalKey();
  // a RenderBox object to use in state
  RenderBox colorTextRenderBox;

  @override
  void initState() {
    super.initState();
    // this will be called after first draw, and then call _recordSize() method _recordSize() method
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      colorTextRenderBox = colorTextKey.currentContext.findRenderObject();
    });
  }
  //设定Widget的偏移量
  Offset offset = Offset(20, kToolbarHeight + 100);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fromTop = screenHeight * 0.31082019;  /// 彩蛋
    return new Scaffold(
      key: colorTextKey,
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/Images/sun-bg.jpg',
              fit: BoxFit.fitHeight,
              height: 2000,
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: fromTop, left: 24.0, right: 24.0),
              child: Column(
                children: <Widget>[
                  showDays(),
                  loveUBtn(),
                ],
              ),
            ),
          ),
//          draggableBtn(),
        ],
      ),
    );
  }

  Widget draggableBtn() {
    return Positioned(
      left: 100,
      top: 100,
      child: Draggable(
        child: Text("我只是演示使用"),
        childWhenDragging: Text("我被拉出去了😢"),
        feedback: Text("我是拉出去的东西"),
        onDragEnd: (detail) {
          print(
            "Draggable onDragEnd ${detail.velocity.toString()} ${detail.offset.toString()}"
          );
        },
        onDragCompleted: () {
          print("Draggable onDragCompleted");
        },
        onDragStarted: () {
          print("Draggable onDragStarted");
        },
        onDraggableCanceled: (Velocity velocity, Offset offset) {
          print(
            "Draggable onDraggableCanceled ${velocity.toString()} ${offset.toString()}"
          );
        },
      )
    );
  }

  Widget showDays() {
    daysBloc.fetchLoveStartDate();
    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: daysBloc.dayModel,
          builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              int daySince = snapshot.data.dayCount;
              return Center(
                child: Text(
                  "${daySince.toString()}",
                  style: TextStyle(
                    fontSize: 90,
                    color: Colors.white,
                  ),
                ),
              );
            }
            return Center(
              child: CircularProgressIndicator()
            );
          }
        ),
        Container(height: 30,),
        StreamBuilder(
          stream: daysBloc.dayModel,
          builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (snapshot.hasData) {
              String startDateStr = snapshot.data.loveStartDate;
              return Center(
                child: new Text(
                  "On $startDateStr, \nthe world became colorful",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontSize: 20.0,
                    foreground: Paint()..shader = getTextGradient(colorTextRenderBox)),
                ),
              );
            }
            return Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30.0,
                ),
                child:CircularProgressIndicator()
              )
            );
          }
        ),
      ],
    );
  }

  Shader getTextGradient(RenderBox renderBox) {
    if (renderBox == null) return null;
    return LinearGradient(
      colors: <Color>[
        Colors.purpleAccent, Colors.greenAccent, Colors.yellowAccent,
        Colors.lightBlueAccent, Colors.redAccent, Colors.deepOrange,
      ],
    ).createShader(Rect.fromLTWH(
      renderBox.localToGlobal(Offset.zero).dx,
      renderBox.localToGlobal(Offset.zero).dy,
      renderBox.size.width,
      renderBox.size.height));
  }

  Widget loveUBtn() {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 60.0,
        horizontal: 100.0
      ),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        onPressed: () async {
          if (widget.isSplash) {
            await Future.delayed(Duration(milliseconds: 200), () {});
            Navigator.of(context).pushAndRemoveUntil(
              FadeRoute(
                page: MyHomePage(changeTheme: widget.changeTheme)
              ),
                (Route<dynamic> route) => false);
            await Future.delayed(Duration(milliseconds: 200), () {});
          }
          else {
            Navigator.pop(context);
          }
        },
        padding: EdgeInsets.all(12),
        color: primaryColor.withOpacity(0.3),
        child: Text(
          'Love You~',
          style: TextStyle(color: Colors.white)
        ),
      ),
    );
  }
}

