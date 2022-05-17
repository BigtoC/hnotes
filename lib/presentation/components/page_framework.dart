import 'package:flutter/material.dart';

import 'package:hnotes/presentation/theme.dart';

class PageFramework extends StatelessWidget {
  final String title;
  final Widget widgets;
  final Function() handleBack;

  PageFramework({required this.title, required this.widgets, required this.handleBack});

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView(
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: handleBack(),
                    child: Container(
                      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                      child: const Icon(Icons.arrow_back),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                    child: _buildHeaderWidget(title),
                  ),
                  widgets,
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _buildHeaderWidget(String headerTitle) {
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
}
