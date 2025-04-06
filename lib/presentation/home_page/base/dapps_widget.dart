import "package:flutter/material.dart";

class DAppsWidget extends StatelessWidget {
  final Radius topRadius;
  final String title;

  const DAppsWidget({
    super.key,
    required this.topRadius,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 5),
      child: ClipRRect(
        // Image border
        borderRadius: BorderRadius.vertical(
          top: topRadius,
          bottom: Radius.zero,
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: titleText(title),
            ),
          ],
        ),
      ),
    );
  }

  Widget titleText(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.normal),
    );
  }
}
