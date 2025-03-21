import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';
import 'package:hnotes/domain/common_data.dart';
import 'package:hnotes/presentation/components/loading_circle.dart';

Widget buildCardWidget(BuildContext context, Widget child) {
  return Container(
    decoration: BoxDecoration(
      color: Theme.of(context).dialogTheme.backgroundColor,
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

Widget cardContent(BuildContext context, String contentText, {Color? textColor}) {
  return new Center(
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

Widget buildTitleAndContent(
    BuildContext context,
    var streamData,
    String title,
    String content,
    {Color? textColor, Widget Function(String value)? handleData}
    ) {
  return new Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      cardContentTitle(title),
      blockInfoStreamBuilder(context, streamData, content, handleData: handleData),
      cardContentGap(),
    ],
  );
}

Widget blockInfoStreamBuilder(
    BuildContext context,
    var streamData,
    String valueKey,
    {Color? textColor, Widget Function(String value)? handleData}
    ) {
  return new StreamBuilder(
    stream: streamData,
    builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
      if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      }
      switch (snapshot.connectionState) {
        case ConnectionState.none:
          return cardContent(context, 'Query data failed...');
        case ConnectionState.waiting:
          return Center(
            child: LoadingCircle(),
          );
        case ConnectionState.active:
          String data = snapshot.data![valueKey].toString();
          return handleData == null ? cardContent(context, data) : handleData(data);
        case ConnectionState.done:
          logger.i("Finish rendering $valueKey");
      }
      return SizedBox();
    },
  );
}
