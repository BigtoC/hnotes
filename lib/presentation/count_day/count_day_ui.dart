import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/presentation/home_page/home_ui.dart';
import 'package:hnotes/domain/count_day/count_day_model.dart';
import 'package:hnotes/presentation/components/fade_route.dart';
import 'package:hnotes/application/count_day/count_day_bloc.dart';
import 'package:hnotes/presentation/count_day/count_day_background.dart';


// ignore: must_be_immutable
class CountDay extends StatefulWidget {
  Function(ThemeData themeData)? changeTheme;
  CountDay({
    Key? key, required this.isSplash, Function(ThemeData themeData)? changeTheme})
    : super(key: key) {
    this.changeTheme = changeTheme;
  }

  final bool isSplash;

  @override
  _DaySince createState() => new _DaySince();
}

class _DaySince extends State<CountDay> {

  // a key to set on our Text widget, so we can measure later
  GlobalKey colorTextKey = GlobalKey();
  // a RenderBox object to use in state
  late RenderBox colorTextRenderBox;

  @override
  void initState() {
    super.initState();
    // this will be called after first draw, and then call _recordSize() method _recordSize() method
    WidgetsBinding.instance.addPostFrameCallback((_) => _recordSize());
  }

  void _recordSize() {
    // now we set the RenderBox and trigger a redraw
    setState(() {
      colorTextRenderBox = colorTextKey.currentContext?.findRenderObject()! as RenderBox;
    });
  }
  /// Offset for widgets
  Offset offset = Offset(20, kToolbarHeight + 100);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double fromTop = screenHeight * 0.31082019;  /// 彩蛋
    return new Scaffold(
      key: colorTextKey,
      body: Stack(
        children: <Widget>[
          countDayBackground(),
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
              int? daySince = snapshot.data?.dayCount;
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
              String? startDateStr = snapshot.data?.loveStartDate;
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
    final ButtonStyle style = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ), backgroundColor: primaryColor.withAlpha(80),
      padding: EdgeInsets.all(12),
    );

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 60.0,
        horizontal: 100.0
      ),
      child: ElevatedButton(
        style: style,
        onPressed: () async {
          if (widget.isSplash) {
            await Future.delayed(Duration(milliseconds: 200), () {});
            Navigator.of(context).pushAndRemoveUntil(
              FadeRoute(
                page: MyHomePage(changeTheme: widget.changeTheme, key: null)
              ),
                (Route<dynamic> route) => false);
            await Future.delayed(Duration(milliseconds: 200), () {});
          }
          else {
            Navigator.pop(context);
          }
        },
        child: Text(
          'Love You~',
          style: TextStyle(color: Colors.white)
        ),
      ),
    );
  }
}
