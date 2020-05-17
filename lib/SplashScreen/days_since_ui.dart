import 'package:flutter/material.dart';
import 'package:hnotes/HomePage/home_ui.dart';
import 'package:hnotes/SplashScreen/count_day_model.dart';

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
  static int daySince = CountDayModel.daysSince;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget showDays() {
    return Center(
      child: Text(
        "在一起已经${daySince.toString()}天了呢",
        style: TextStyle(
          fontSize: 36,
          color: Colors.black87,
        ),
      ),
    );
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
        onPressed: () {
          if (widget.isSplash) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) =>
                MyHomePage(changeTheme: widget.changeTheme)
              ),
                (Route<dynamic> route) => false);
          }
          else {
            Navigator.pop(context);
          }
        },
        padding: EdgeInsets.all(12),
        color: Colors.blueAccent,
        child: Text(
          '爱你哟~',
          style: TextStyle(color: Colors.white)
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'assets/Images/splash-bg.png',
              fit: BoxFit.cover,
              height: 2000,
            ),
          ),
          Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(left: 24.0, right: 24.0),
              children: <Widget>[
                showDays(),
                loveUBtn()
              ],
            ),
          )
        ],
      ),
    );
  }
}

