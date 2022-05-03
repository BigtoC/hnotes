import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:hnotes/util/theme.dart';


Widget buildCardWidget(BuildContext context, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogBackgroundColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 8),
          color: Colors.black.withAlpha(20),
          blurRadius: 16
        )
      ]
    ),
    margin: EdgeInsets.all(24),
    padding: EdgeInsets.all(16),
    child: child,
  );
}

Widget buildHeaderWidget(String headerTitle) {
  return Container(
    margin: EdgeInsets.only(top: 8, bottom: 16, left: 8),
    child: Text(
      headerTitle,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 36,
        color: primaryColor,
      ),
    ),
  );
}

Widget cardTitle(String cardTitle) {
  return Text(
    cardTitle,
    style: TextStyle(
      fontSize: 24,
      color: primaryColor,
    )
  );
}

Widget cardContentTitle(String cardContentTitle) {
  return Center(
    child: Text(
    cardContentTitle.toUpperCase(),
    style: TextStyle(
      color: Colors.grey.shade600,
      fontWeight: FontWeight.w500,
      letterSpacing: 1
    )
    )
  );
}

Widget cardContent(BuildContext context, String contentText, Color? textColor) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
      child: Text(
        contentText,
        style: TextStyle(
          fontSize: 24,
          color: Theme.of(context).brightness == Brightness.light ? Colors.black : Colors.white
        ),
      ),
    )
  );
}

Widget cardContentGap() {
  return Container(
    height: 30,
  );
}

Widget buildTitleAndContent(BuildContext context, var streamData, String title, String content, Color? textColor) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      cardContentTitle(title),
      blockInfoStreamBuilder(context, streamData, content, textColor),
      cardContentGap(),
    ],
  );
}

Widget blockInfoStreamBuilder(BuildContext context, var streamData, String valueKey, Color? textColor) {
  return StreamBuilder(
    stream: streamData,
    builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return cardContent(context, 'Query data filed...', textColor);
        case ConnectionState.waiting:
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).brightness == Brightness.dark
                ? btnColor
                : primaryColor,
            )
          );
        case ConnectionState.active:
          String showData = snapshot.data![valueKey].toString();
          if (valueKey == 'timestamp') {
            showData = convertTime(showData);
          }
          return cardContent(context, showData, textColor);
        case ConnectionState.done:
          print("done");
      }
      return SizedBox();
    },
  );
}

String convertTime(String timestamp) {
  String neatDate = DateFormat.yMMMd().add_jm().format(
    DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp))).toString();
  return neatDate;
}
