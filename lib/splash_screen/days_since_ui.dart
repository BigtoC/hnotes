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

  @override
  void initState() {
    super.initState();

  }

  Widget showDays() {
    daysBloc.fetchLoveStartDate();
    return StreamBuilder(
      stream: daysBloc.dayModel,
      builder: (context, AsyncSnapshot<CountDayModel> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (snapshot.hasData) {
          int daySince = snapshot.data.dayCount;
          String startDateStr = snapshot.data.loveStartDate;
          return Center(
            child: Column(
              children: <Widget>[
                Text(
                  "${daySince.toString()}",
                  style: TextStyle(
                    fontSize: 90,
                    color: Colors.white,
                  ),
                ),
                Container(height: 30,),
                Text(
                  "Start Date: $startDateStr",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator()
        );
      }
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
              FadeRoute(
                page: MyHomePage(changeTheme: widget.changeTheme)
              ),
                (Route<dynamic> route) => false);
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

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
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

