import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

import "package:hnotes/presentation/components/browser.dart";
import "package:hnotes/presentation/components/page_header_widget.dart";

class DAppDetailsPage extends StatelessWidget {
  final String dAppName;
  final Widget dAppDetailsWidget;

  const DAppDetailsPage({
    super.key,
    required this.dAppDetailsWidget,
    required this.dAppName,
  });

  @override
  Widget build(BuildContext context) {
    void handleBack() {
      Navigator.of(context).pop();
    }

    return Scaffold(
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: handleBack,
                child: Container(
                  padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
                  child: const Icon(Icons.arrow_back),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 36, right: 24),
                child: PageHeaderWidget(title: dAppName),
              ),
              itemDetails(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget itemDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          dAppDetailsWidget,
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget content({required String subtitleText, required String text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 14),
        textWidget(subtitleText, 24.0, FontWeight.w600),
        textWidget(text, 18.0, FontWeight.w200),
      ],
    );
  }

  Widget textWidget(String title, double fontSize, FontWeight fontWeight) {
    return Text(
      title,
      style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
    );
  }

  Widget urlText(
    BuildContext context,
    String text,
    String url,
    String webTitle,
  ) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w300,
          color: Colors.lightBlue,
        ),
        recognizer:
            TapGestureRecognizer()
              ..onTap = () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) {
                      return Browser(title: webTitle, url: url);
                    },
                  ),
                );
              },
      ),
    );
  }
}
